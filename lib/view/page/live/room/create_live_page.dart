import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:livekit_client/livekit_client.dart' hide ConnectionState;
import 'package:post_client/domain/live/live_message.dart';
import 'package:post_client/model/live/live_room.dart';
import 'package:post_client/service/live/live_room_service.dart';
import 'package:post_client/view/widget/button/common_action_one_button.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../config/net_config.dart';
import '../../../../constant/live.dart';
import '../../../component/input/common_text_comment_input.dart';

class CreateLivePage extends StatefulWidget {
  const CreateLivePage({super.key});

  @override
  State<CreateLivePage> createState() => _CreateLivePageState();
}

class _CreateLivePageState extends State<CreateLivePage> {
  late Future _futureBuilderFuture;

  // 共享屏幕，否则摄像头
  int liveMediaMode = LiveMediaMode.backFacingCamera;
  List<LiveMessage> msgList = <LiveMessage>[];

  final chatChannel = WebSocketChannel.connect(
    Uri.parse(NetConfig.liveChatUrl),
  );

  LiveRoom? liveRoom;
  bool started = false;
  String? joinToken;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
  }

  Future getData() async {
    return Future.wait([initLocalMedia(), connectLiveChat()]);
  }

  Future<void> initLocalMedia() async {
    await setLocalTrack();
  }

  Future<void> connectLiveChat() async {
    var (token, lr) = await LiveRoomService.openRoom();
    liveRoom = lr;
    joinToken = token;
    // 注册到聊天室
    var joinMsg = LiveMessage.joinRoom(roomId: liveRoom!.id!);
    chatChannel.sink.add(json.encode(joinMsg.toJson()));
    // 监听消息
    chatChannel.stream.listen((message) {
      log("接收到消息: $message");
      var liveMsg = LiveMessage.fromJson(json.decode(message));
      if (msgList.length > 100) msgList.removeLast();
      msgList.insert(0, liveMsg);
      setState(() {});
    });
  }

  void stopLiveChat() async {
    chatChannel.sink.close();
    msgList.clear();
  }

  @override
  void dispose() {
    super.dispose();
    // 关闭ws chat 连接
    stopLiveChat();
    // 离开并关闭room
    LiveRoomService.closeRoom();
    room?.disconnect();
    localVideo?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          return Scaffold(
            //防止键盘越界
            resizeToAvoidBottomInset: true,
            backgroundColor: Theme.of(context).colorScheme.background,
            body: SafeArea(
              child: Stack(
                children: [
                  if (localVideo != null)
                    Column(
                      children: [
                        const SizedBox(height: 50),
                        Expanded(
                          child: VideoTrackRenderer(
                            key: ValueKey(localVideo),
                            localVideo!,
                            fit: RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  if (started && liveRoom != null)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Column(
                        children: [
                          Container(
                            height: 300,
                            margin: const EdgeInsets.only(top: 1, bottom: 1),
                            child: ListView.builder(
                              controller: _scrollController,
                              reverse: true,
                              itemBuilder: (BuildContext context, int index) {
                                var msg = msgList[index];
                                return Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                      margin: const EdgeInsets.only(top: 2),
                                      decoration: BoxDecoration(
                                        color: colorScheme.primaryContainer.withAlpha(220),
                                        borderRadius: const BorderRadius.all(Radius.circular(30)),
                                      ),
                                      child: Text("${msg.username}: ${msg.content}"),
                                    )
                                  ],
                                );
                              },
                              itemCount: msgList.length,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            color: colorScheme.surface,
                            child: CommentTextCommentInput(
                              onSubmit: (value) {
                                var msg = LiveMessage.roomMessage(content: value, roomId: liveRoom!.id!);
                                chatChannel?.sink.add(json.encode(msg.toJson()));
                              },
                              controller: TextEditingController(),
                              focusNode: FocusNode(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (!started)
                    Positioned(
                      bottom: 20,
                      left: 50,
                      right: 50,
                      child: CommonActionOneButton(
                        backgroundColor: colorScheme.primaryContainer,
                        title: '开启直播',
                        onTap: () async {
                          started = await startLive();
                          setState(() {});
                        },
                      ),
                    ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 45,
                      color: colorScheme.surface,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (!started)
                            IconButton(
                              tooltip: "离开",
                              icon: const Icon(Icons.exit_to_app),
                              iconSize: 30,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          if (started)
                            IconButton(
                              tooltip: "关闭直播",
                              icon: const Icon(Icons.stop_circle),
                              iconSize: 30,
                              onPressed: () async {
                                await stopLive();
                                started = false;
                                setState(() {});
                              },
                            ),
                          //翻转屏幕
                          if (!started && liveMediaMode != LiveMediaMode.screenShare)
                            IconButton(
                              tooltip: "翻转摄像头",
                              icon: const Icon(Icons.cameraswitch),
                              iconSize: 30,
                              onPressed: () async {
                                switch (liveMediaMode) {
                                  case LiveMediaMode.frontFacingCamera:
                                    await setLocalTrack(newLiveMediaMode: LiveMediaMode.backFacingCamera);
                                  case LiveMediaMode.backFacingCamera:
                                    await setLocalTrack(newLiveMediaMode: LiveMediaMode.frontFacingCamera);
                                }
                                setState(() {});
                              },
                            ),
                          //屏幕分享
                          if (!started && liveMediaMode != LiveMediaMode.screenShare)
                            IconButton(
                              tooltip: "分享屏幕",
                              icon: const Icon(Icons.screen_share),
                              iconSize: 30,
                              onPressed: () async {
                                await setLocalTrack(newLiveMediaMode: LiveMediaMode.screenShare);
                                setState(() {});
                              },
                            ),
                          if (liveMediaMode == LiveMediaMode.screenShare)
                            IconButton(
                              tooltip: "摄像头",
                              icon: const Icon(Icons.camera),
                              iconSize: 30,
                              onPressed: () async {
                                await setLocalTrack(newLiveMediaMode: LiveMediaMode.frontFacingCamera);
                                setState(() {});
                              },
                            ),
                          if (!started)
                            IconButton(
                              tooltip: "屏幕方向",
                              icon: const Icon(Icons.change_circle),
                              iconSize: 30,
                              onPressed: () {
                                if (MediaQuery.of(context).orientation == Orientation.landscape) {
                                  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                                } else if (MediaQuery.of(context).orientation == Orientation.portrait) {
                                  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
                                }
                                setState(() {});
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          );
        }
      },
    );
  }

  Room? room;
  LocalVideoTrack? localVideo;

  Future<bool> startLive() async {
    if (joinToken == null) return false;
    try {
      // 创建房间
      room = Room(
        roomOptions: const RoomOptions(),
        // 关闭自动订阅，主播不需要订阅任何其他track
        connectOptions: const ConnectOptions(autoSubscribe: false),
      );

      // 连接
      await room!.connect(NetConfig.liveKitUrl, joinToken!);

      // 获取本地track
      await setLocalTrack();

      // 推流
      await room!.localParticipant?.publishVideoTrack(localVideo!);
    } catch (e) {
      log(e.toString());
      return false;
    }
    return true;
  }

  Future<void> setLocalTrack({int? newLiveMediaMode}) async {
    if (newLiveMediaMode != null) {
      liveMediaMode = newLiveMediaMode;
    }
    // 设置推流
    try {
      switch (liveMediaMode) {
        case LiveMediaMode.frontFacingCamera:
          localVideo?.dispose();

          localVideo = await LocalVideoTrack.createCameraTrack(const CameraCaptureOptions(
            cameraPosition: CameraPosition.front,
          ));
          break;
        case LiveMediaMode.backFacingCamera:
          localVideo?.dispose();

          localVideo = await LocalVideoTrack.createCameraTrack(const CameraCaptureOptions(
            cameraPosition: CameraPosition.back,
          ));
          break;
        case LiveMediaMode.screenShare:
          localVideo?.dispose();

          localVideo = await LocalVideoTrack.createScreenShareTrack(const ScreenShareCaptureOptions());
          break;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> stopLive() async {
    // 停止推流断开连接
    room?.disconnect();
    // 停止推送
    // room?.localParticipant?.setScreenShareEnabled(false);
    // room?.localParticipant?.setCameraEnabled(false);
  }
}

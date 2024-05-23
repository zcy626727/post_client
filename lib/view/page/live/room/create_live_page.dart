import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:livekit_client/livekit_client.dart' hide ConnectionState;
import 'package:post_client/config/global.dart';
import 'package:post_client/domain/live/live_message.dart';
import 'package:post_client/model/live/live_room.dart';
import 'package:post_client/service/live/live_room_service.dart';
import 'package:post_client/view/widget/button/common_action_one_button.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../config/net_config.dart';
import '../../../../constant/live.dart';

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

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
  }

  Future getData() async {
    return Future.wait([
      initLocalMedia(),
      initLiveChat(),
    ]);
  }

  Future<void> initLocalMedia() async {
    await setLocalTrack();
  }

  Future<void> initLiveChat() async {
    // 获取room基本信息
    liveRoom = await LiveRoomService.getRoomByAnchor();
    // 注册到聊天室
    var joinMsg = LiveMessage(Global.user.id!, liveRoom!.id!, "加入", LiveMessageType.join);
    chatChannel.sink.add(joinMsg);
    // 监听消息
    chatChannel.stream.listen((message) {
      print("收到消息:$message");
      var liveMsg = LiveMessage.fromJson(message);
      if (msgList.length > 100) msgList.removeAt(1);
      msgList.add(liveMsg);
    });
  }

  @override
  void dispose() {
    super.dispose();
    // 关闭ws chat 连接
    chatChannel.sink.close();
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
            backgroundColor: Theme.of(context).colorScheme.background,
            body: SafeArea(
              child: Stack(
                children: [
                  if (localVideo != null)
                    VideoTrackRenderer(
                      key: ValueKey(localVideo),
                      localVideo!,
                      fit: RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
                    ),
                  if (!started)
                    Positioned(
                      bottom: 80,
                      left: 50,
                      right: 50,
                      child: Container(
                        child: CommonActionOneButton(
                          backgroundColor: colorScheme.primaryContainer,
                          title: '开启直播',
                          onTap: () async {
                            started = true;
                            await startLive();
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 50,
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
                          if (liveMediaMode != LiveMediaMode.screenShare)
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
                          if (liveMediaMode != LiveMediaMode.screenShare)
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

  Future<void> startLive() async {
    var (token, lr) = await LiveRoomService.openRoom();
    liveRoom = lr;
    // 创建房间
    room = Room(
      roomOptions: const RoomOptions(),
      // 关闭自动订阅，主播不需要订阅任何其他track
      connectOptions: const ConnectOptions(autoSubscribe: false),
    );

    // 连接
    await room!.connect(NetConfig.liveKitUrl, token);

    // 获取本地track
    await setLocalTrack();

    // 推流
    await room!.localParticipant?.publishVideoTrack(localVideo!);
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
    } catch (e) {}
  }

  Future<void> stopLive() async {
    // 停止推流断开连接
    room?.disconnect();
    // 停止推送
    // room?.localParticipant?.setScreenShareEnabled(false);
    // room?.localParticipant?.setCameraEnabled(false);
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:livekit_client/livekit_client.dart' as livekit;
import 'package:post_client/config/net_config.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../constant/ui.dart';
import '../../../../domain/live/live_message.dart';
import '../../../../model/message/live_room.dart';
import '../../../../service/message/live_room_service.dart';
import '../../../component/input/common_text_comment_input.dart';

class LiveRoomPage extends StatefulWidget {
  const LiveRoomPage({super.key, required this.liveRoom});

  final LiveRoom liveRoom;

  @override
  State<LiveRoomPage> createState() => _LiveRoomPageState();
}

class _LiveRoomPageState extends State<LiveRoomPage> {
  late Future _futureBuilderFuture;

  final ScrollController _scrollController = ScrollController();

  final FocusNode _focusNode = FocusNode();

  livekit.TrackPublication? videoPub;

  livekit.Room? room;

  // 主播参与者，如果为null说明主播已经离开
  livekit.Participant? anchorParticipant;

  final chatChannel = WebSocketChannel.connect(
    Uri.parse(NetConfig.liveChatUrl),
  );

  List<ChatMessage> msgList = <ChatMessage>[];

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
  }

  @override
  void dispose() {
    super.dispose();
    room?.disconnect();
    chatChannel.sink.close();
  }

  Future getData() async {
    return Future.wait([joinRoom(), initLiveChat()]);
  }

  Future<void> joinRoom() async {
    try {
      // 获取加入room的token
      var roomToken = await LiveRoomService.getJoinRoomToken(roomId: widget.liveRoom.id!);
      // 连接房间
      room = livekit.Room(connectOptions: const livekit.ConnectOptions(autoSubscribe: true));

      await room!.connect(NetConfig.liveKitUrl, roomToken);

      // 添加监听
      room?.addListener(_onChange);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> initLiveChat() async {
    // 注册到聊天室
    var joinMsg = ChatMessage.joinRoom(roomId: widget.liveRoom.id!);
    chatChannel.sink.add(json.encode(joinMsg.toJson()));
    // 监听消息
    chatChannel.stream.listen((message) {
      log("接收到消息: $message");
      var liveMsg = ChatMessage.fromJson(json.decode(message));
      if (msgList.length > 100) msgList.removeLast();
      msgList.insert(0, liveMsg);
      setState(() {});
    });
  }

  // livekit 中 room 改变
  void _onChange() {
    // 重新找主播
    if (anchorParticipant == null) {
      room?.remoteParticipants.forEach((key, value) {
        if (key == widget.liveRoom.anchorId.toString()) {
          //是主播
          anchorParticipant = value;
        }
      });
    }
    // 获取视频track
    if (anchorParticipant != null && videoPub == null) {
      videoPub = anchorParticipant!.videoTrackPublications.firstOrNull;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          return GestureDetector(
            onTap: () {
              _focusNode.unfocus();
            },
            child: SafeArea(
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: colorScheme.background,
                appBar: AppBar(
                  toolbarHeight: 50,
                  centerTitle: true,
                  elevation: 0,
                  backgroundColor: colorScheme.surface,
                  leading: IconButton(
                    splashRadius: 20,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: colorScheme.onBackground,
                    ),
                  ),
                  title: Text(
                    "直播间",
                    style: TextStyle(color: colorScheme.onSurface, fontSize: appbarTitleFontSize),
                  ),
                  actions: [],
                ),
                body: Column(
                  children: [
                    // 直播视频播放
                    if (videoPub != null && videoPub!.track != null)
                      AspectRatio(
                        aspectRatio: 2,
                        child: Container(
                          color: colorScheme.primaryContainer,
                          child: livekit.VideoTrackRenderer(
                            key: ValueKey(videoPub),
                            videoPub!.track as livekit.VideoTrack,
                            fit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                          ),
                        ),
                      ),
                    // 聊天内容
                    Expanded(
                      child: Container(
                        color: colorScheme.surface,
                        margin: const EdgeInsets.only(top: 1, bottom: 1),
                        child: ListView.builder(
                          controller: _scrollController,
                          reverse: true,
                          itemBuilder: (BuildContext context, int index) {
                            var msg = msgList[index];
                            return Text("${msg.username}: ${msg.content}");
                          },
                          itemCount: msgList.length,
                        ),
                      ),
                    ),
                    // 评论
                    Container(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      color: colorScheme.surface,
                      child: CommentTextCommentInput(
                        onSubmit: (value) {
                          var msg = ChatMessage.roomMessage(content: value, roomId: widget.liveRoom.id!);
                          chatChannel.sink.add(json.encode(msg.toJson()));
                        },
                        controller: TextEditingController(),
                        focusNode: FocusNode(),
                      ),
                    ),
                  ],
                ),
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        if (MediaQuery.of(context).viewInsets.bottom == 0) {
          // 关闭键盘
          _focusNode.unfocus();
        } else {
          // 显示键盘
        }
      }
    });
  }
}

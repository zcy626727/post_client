import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:livekit_client/livekit_client.dart' as livekit;
import 'package:post_client/config/net_config.dart';
import 'package:post_client/model/live/live_room.dart';
import 'package:post_client/service/live/live_room_service.dart';

import '../../../../constant/ui.dart';
import '../../../component/input/comment_text_field.dart';

class LiveRoomPage extends StatefulWidget {
  const LiveRoomPage({super.key, required this.liveRoom});

  final LiveRoom liveRoom;

  @override
  State<LiveRoomPage> createState() => _LiveRoomPageState();
}

class _LiveRoomPageState extends State<LiveRoomPage> {
  late Future _futureBuilderFuture;

  final QuillController _controller = QuillController.basic();

  final FocusNode _focusNode = FocusNode();

  livekit.TrackPublication? videoPub;

  livekit.Room? room;

  // 主播参与者，如果为null说明主播已经离开
  livekit.Participant? anchorParticipant;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
  }

  @override
  void dispose() {
    super.dispose();
    _listener.dispose();
  }

  Future getData() async {
    return Future.wait([joinRoom()]);
  }

  late final livekit.EventsListener<livekit.RoomEvent> _listener;

  Future<void> joinRoom() async {
    // 获取加入room的token
    var roomToken = await LiveRoomService.getJoinRoomToken(roomId: widget.liveRoom.id!);
    // 连接房间
    room = livekit.Room(connectOptions: const livekit.ConnectOptions(autoSubscribe: false));

    await room!.connect(NetConfig.liveKitUrl, roomToken);
    // 找到主播
    room?.remoteParticipants.forEach((key, value) {
      if (key == widget.liveRoom.anchorId.toString()) {
        //是主播
        anchorParticipant = value;
      }
    });
    // 添加监听
    room?.addListener(_onChange);
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
    var visibleVideos = anchorParticipant!.videoTrackPublications;
    if (visibleVideos.isNotEmpty) {
      videoPub = visibleVideos.first;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var videoPub = this.videoPub;

    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          return GestureDetector(
            onTap: () {
              _focusNode.unfocus();
            },
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
              body: Container(
                color: colorScheme.background,
                child: Column(
                  children: [
                    // 视频
                    AspectRatio(
                      aspectRatio: 2,
                      child: Container(
                        color: colorScheme.primaryContainer,
                        child: videoPub == null ? null : livekit.VideoTrackRenderer(videoPub.track as livekit.VideoTrack),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              color: colorScheme.surface,
                              margin: const EdgeInsets.only(top: 1, bottom: 1),
                              child: ListView(
                                scrollDirection: Axis.vertical,
                                reverse: true,
                                children: [
                                  Text("张三：我要吃饭"),
                                ],
                              ),
                            ),
                          ),
                          // 评论
                          Container(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            color: colorScheme.surface,
                            child: CommentTextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              onSubmit: () async {
                                _focusNode.unfocus();
                              },
                            ),
                          ),
                        ],
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

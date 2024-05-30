import 'dart:convert';
import 'dart:developer';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:post_client/config/global.dart';
import 'package:post_client/model/message/user_interaction.dart';
import 'package:post_client/model/message/user_message.dart';
import 'package:post_client/service/message/user_message_service.dart';
import 'package:post_client/view/component/show/show_snack_bar.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../config/net_config.dart';
import '../../../constant/ui.dart';
import '../../../domain/live/live_message.dart';
import '../../component/input/common_text_comment_input.dart';
import '../../component/message/chat_bubble.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.userInteraction});

  final UserInteraction userInteraction;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late Future _futureBuilderFuture;
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final chatChannel = WebSocketChannel.connect(
    Uri.parse(NetConfig.userChatUrl),
  );

  @override
  void dispose() {
    super.dispose();
    chatChannel.sink.close();
  }

  final EasyRefreshController _refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  var msgList = <UserMessage>[];
  int pageIndex = 0;
  DateTime startTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
  }

  Future getData() async {
    return Future.wait([loadUserMessage(), initUserChat()]);
  }

  Future<void> initUserChat() async {
    // 注册自己连接到服务器
    chatChannel.sink.add(json.encode(ChatMessage.userJoin().toJson()));
    // 监听消息
    chatChannel.stream.listen((message) {
      // 收到发来的消息
      log("收到消息:$message");
      var msg = ChatMessage.fromJson(json.decode(message));
      if (msgList.length > 100) msgList.removeLast();
      msgList.insert(0, UserMessage.fromChatMessage(msg));
      setState(() {});
    });
  }

  // 加载历史消息
  Future loadUserMessage() async {
    var usm = await UserMessageService.getUserMessageListByInteraction(interactionId: widget.userInteraction.id!, pageIndex: pageIndex, pageSize: 10, startTime: startTime);
    pageIndex++;
    msgList.addAll(usm);
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
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: colorScheme.background,
              appBar: AppBar(
                toolbarHeight: 50,
                centerTitle: true,
                elevation: 0,
                surfaceTintColor: colorScheme.surface,
                leading: IconButton(
                  splashRadius: 20,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: colorScheme.onSurface,
                  ),
                ),
                title: Text(
                  widget.userInteraction.otherUser?.name ?? "未知",
                  style: TextStyle(color: colorScheme.onSurface, fontSize: appbarTitleFontSize),
                ),
                actions: [],
              ),
              body: Column(
                children: [
                  Expanded(
                    child: Container(
                      color: colorScheme.surface,
                      margin: const EdgeInsets.only(top: 1, bottom: 1),
                      child: EasyRefresh(
                        footer: MaterialFooter(backgroundColor: colorScheme.primaryContainer, color: colorScheme.onPrimaryContainer),
                        controller: _refreshController,
                        onLoad: _onLoad,
                        child: ListView.builder(
                          reverse: true,
                          itemBuilder: (BuildContext context, int index) {
                            var msg = msgList[index];
                            var isMe = msg.fromId == Global.user.id;
                            return ChatBubble(
                              message: msg.content ?? "",
                              isMe: isMe,
                              user: isMe ? Global.user : widget.userInteraction.otherUser!,
                            );
                          },
                          itemCount: msgList.length,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    color: colorScheme.surface,
                    child: CommentTextCommentInput(
                      onSubmit: (value) {
                        if (widget.userInteraction.otherUser?.id == null) {
                          ShowSnackBar.error(context: context, message: "用户信息错误");
                          return;
                        }
                        var msg = ChatMessage.userMessage(targetUserId: widget.userInteraction.otherUser!.id!, content: value);
                        chatChannel.sink.add(json.encode(msg.toJson()));
                      },
                      controller: _textEditingController,
                      focusNode: _focusNode,
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

  //加载更多
  void _onLoad() async {
    try {
      await loadUserMessage();
      //获取成功
      _refreshController.finishLoad();
      // _refreshController.resetFooter();
      // _refreshController.resetHeader();

      setState(() {});
    } catch (e) {
      //获取失败
    }
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

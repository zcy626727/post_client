import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../../../constant/ui.dart';
import '../input/comment_text_field.dart';
import 'chat_bubble.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late Future _futureBuilderFuture;
  final QuillController _controller = QuillController.basic();

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
  }

  Future getData() async {
    return Future.wait([]);
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
                  "路由器",
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
                      child: ListView.builder(
                        reverse: true,
                        itemBuilder: (BuildContext context, int index) {
                          if (index % 2 == 1) {
                            return ChatBubble(message: "你是谁？", isMe: true);
                          } else {
                            return ChatBubble(message: "你好？", isMe: false);
                          }
                        },
                        itemCount: 15,
                      ),
                    ),
                  ),
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

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:post_client/model/comment.dart';
import 'package:post_client/view/component/comment/comment_card.dart';
import 'package:post_client/view/component/input/comment_text_field.dart';
import 'package:post_client/view/component/quill/quill_tool_bar.dart';
import 'package:post_client/view/page/comment/reply_page.dart';
import 'package:post_client/view/widget/common_item_list.dart';
import 'package:post_client/view/widget/input_text_field.dart';

import '../../component/quill/quill_editor.dart';

class PostCommentPage extends StatefulWidget {
  const PostCommentPage({Key? key}) : super(key: key);

  @override
  State<PostCommentPage> createState() => _PostCommentPageState();
}

class _PostCommentPageState extends State<PostCommentPage> {
  final QuillController _controller = QuillController.basic();

  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).viewInsets.bottom == 0) focusNode.unfocus();
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
          "评论",
          style: TextStyle(color: colorScheme.onSurface),
        ),
      ),
      backgroundColor: colorScheme.background,
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: colorScheme.surface,
              margin: const EdgeInsets.only(top: 2),
              child: CommonItemList<Comment>(
                onLoad: (int page) async {
                  var commentList = <Comment>[];
                  commentList.add(Comment.one());
                  commentList.add(Comment.one());
                  commentList.add(Comment.one());
                  commentList.add(Comment.one());
                  return commentList;
                },
                itemName: "动态",
                itemHeight: null,
                isGrip: false,
                enableScrollbar: true,
                itemBuilder: (ctx, comment) {
                  return CommentCard(
                    comment: comment,
                    onTap: () {
                      //展开评论
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReplyPage(comment: comment)),
                      );
                      focusNode.unfocus();
                    },
                    onReply: () {
                      //展开评论并聚焦
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReplyPage(comment: comment)),
                      );
                      focusNode.unfocus();

                    },
                  );
                },
              ),
            ),
          ),
          if (MediaQuery.of(context).viewInsets.bottom > 0) PostQuillToolBar(controller: _controller),
          CommentTextField(controller: _controller, focusNode: focusNode),
        ],
      ),
    );
  }
}

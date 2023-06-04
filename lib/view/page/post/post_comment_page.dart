import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:post_client/model/comment.dart';
import 'package:post_client/view/component/post/comment_card.dart';
import 'package:post_client/view/widget/common_item_list.dart';

class PostCommentPage extends StatefulWidget {
  const PostCommentPage({Key? key}) : super(key: key);

  @override
  State<PostCommentPage> createState() => _PostCommentPageState();
}

class _PostCommentPageState extends State<PostCommentPage> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
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
            )),
        title: Text(
          "评论",
          style: TextStyle(color: colorScheme.onSurface),
        ),
      ),
      backgroundColor: colorScheme.background,
      body: Container(
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
          enableUp: true,
          itemName: "动态",
          itemHeight: null,
          isGrip: false,
          enableScrollbar: true,
          itemBuilder: (ctx, post) {
            return CommentCard();
          },
        ),
      ),
    );
  }
}

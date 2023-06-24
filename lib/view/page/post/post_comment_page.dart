import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:post_client/model/comment.dart';
import 'package:post_client/model/post.dart';
import 'package:post_client/service/comment_service.dart';
import 'package:post_client/view/component/comment/comment_card.dart';
import 'package:post_client/view/component/comment/comment_list.dart';
import 'package:post_client/view/component/input/comment_text_field.dart';
import 'package:post_client/view/component/quill/quill_tool_bar.dart';
import 'package:post_client/view/page/comment/reply_page.dart';
import 'package:post_client/view/widget/common_item_list.dart';
import 'package:post_client/view/widget/input_text_field.dart';

import '../../component/quill/quill_editor.dart';

class PostCommentPage extends StatefulWidget {
  const PostCommentPage({Key? key, required this.post}) : super(key: key);
  final Post post;

  @override
  State<PostCommentPage> createState() => _PostCommentPageState();
}

class _PostCommentPageState extends State<PostCommentPage> {
  @override
  Widget build(BuildContext context) {
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
          style: TextStyle(color: colorScheme.onSurface, fontSize: 17),
        ),
      ),
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: CommentList(
          onLoad: (pageIndex) async {
            var commentList = CommentService.getCommentListByParent(widget.post.id!, CommentParentType.post.index, pageIndex, 20);
            return commentList;
          },
          parentId: widget.post.id!,
          parentType: CommentParentType.post.index,
        ),
      ),
    );
  }
}

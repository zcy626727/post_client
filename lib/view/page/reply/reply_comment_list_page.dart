import 'package:flutter/material.dart';
import 'package:post_client/model/post/comment.dart';
import 'package:post_client/service/post/comment_service.dart';
import 'package:post_client/view/component/reply/reply_comment_list_tile.dart';

import '../../../common/list/common_item_list.dart';

class ReplyCommentListPage extends StatefulWidget {
  const ReplyCommentListPage({super.key});

  @override
  State<ReplyCommentListPage> createState() => _ReplyCommentListPageState();
}

class _ReplyCommentListPageState extends State<ReplyCommentListPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
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
          "回复",
          style: TextStyle(color: colorScheme.onSurface),
        ),
        actions: [],
      ),
      body: CommonItemList<Comment>(
        onLoad: (int page) async {
          var commentList = await CommentService.getReplyCommentList(page, 20);
          return commentList;
        },
        itemName: "回复",
        itemHeight: null,
        isGrip: false,
        enableScrollbar: true,
        itemBuilder: (ctx, comment, commentList, onFresh) {
          return ReplyCommentListTile(comment: comment);
        },
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../model/comment.dart';
import '../../../service/comment_service.dart';
import '../../component/comment/comment_list.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({super.key, required this.commentParentType, required this.commentParentId});

  final int commentParentType;
  final String commentParentId;

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
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
            var commentList = CommentService.getCommentListByParent(widget.commentParentId, widget.commentParentType, pageIndex, 20);
            return commentList;
          },
          parentId: widget.commentParentId,
          parentType: widget.commentParentType,
        ),
      ),
    );
  }
}

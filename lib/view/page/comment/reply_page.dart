import 'package:flutter/material.dart';
import 'package:post_client/model/message/comment.dart';
import 'package:post_client/service/message/comment_service.dart';
import 'package:post_client/view/component/comment/comment_list.dart';

import '../../component/comment/comment_list_tile.dart';

class ReplyPage extends StatefulWidget {
  const ReplyPage({Key? key, required this.comment, required this.onDeleteComment}) : super(key: key);

  final Comment comment;
  final Function(Comment) onDeleteComment;

  @override
  State<ReplyPage> createState() => _ReplyPageState();
}

class _ReplyPageState extends State<ReplyPage> {


  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    //关闭聚焦
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
          ),
        ),
        title: Text(
          "回复",
          style: TextStyle(color: colorScheme.onSurface,fontSize: 17),
        ),
      ),
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 2),
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverToBoxAdapter(
                  child: Container(
                    color: colorScheme.surface,
                    margin: const EdgeInsets.only(bottom: 1),
                    child: CommentListTile(
                      comment: widget.comment,
                      onTap: () {
                        //回复评论
                      },
                      onReply: () {
                        //回复评论
                      },
                      onDeleteComment: (comment) {
                        widget.onDeleteComment(comment);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                )
              ];
            },
            body: Column(
              children: [
                Divider(
                  color: colorScheme.onSurface.withAlpha(100),
                  height: 1,
                ),
                Expanded(
                  child: Container(
                    color: colorScheme.surface,
                    padding: const EdgeInsets.only(top: 2),
                    child: CommentList(
                      onLoad: (pageIndex) async {
                        var commentList = await CommentService.getCommentListByParent(widget.comment.id!, CommentParentType.comment, pageIndex, 20);
                        return commentList;
                      },
                      parentId: widget.comment.id!,
                      parentType: CommentParentType.comment,
                      parentUserId: widget.comment.userId!,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // 监听键盘可见性
    // WidgetsBinding.instance.addObserver(this);
  }

}

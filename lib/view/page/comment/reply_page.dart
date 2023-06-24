import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:post_client/model/comment.dart';
import 'package:post_client/service/comment_service.dart';
import 'package:post_client/view/component/comment/comment_list.dart';

import '../../component/comment/comment_card.dart';

class ReplyPage extends StatefulWidget {
  const ReplyPage({Key? key, required this.comment, required this.onDeleteComment}) : super(key: key);

  final Comment comment;
  final Function(Comment) onDeleteComment;
  @override
  State<ReplyPage> createState() => _ReplyPageState();
}

class _ReplyPageState extends State<ReplyPage> {

  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    //关闭聚焦
    if (MediaQuery.of(context).viewInsets.bottom == 0) focusNode.unfocus();
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
                    child: CommentCard(
                      comment: widget.comment,
                      onTap: () {
                        //回复评论
                        focusNode.requestFocus();
                      },
                      onReply: () {
                        //回复评论
                        focusNode.requestFocus();
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
                        var commentList = await CommentService.getCommentListByParent(widget.comment.id!, CommentParentType.comment.index, pageIndex, 20);
                        return commentList;
                      },
                      parentId: widget.comment.id!,
                      parentType: CommentParentType.comment.index,
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

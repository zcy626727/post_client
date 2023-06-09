import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:post_client/model/comment.dart';
import 'package:post_client/view/component/input/comment_text_field.dart';
import 'package:post_client/view/component/quill/quill_tool_bar.dart';

import '../../component/comment/comment_card.dart';
import '../../widget/common_item_list.dart';

class ReplyPage extends StatefulWidget {
  const ReplyPage({Key? key, required this.comment}) : super(key: key);

  final Comment comment;

  @override
  State<ReplyPage> createState() => _ReplyPageState();
}

class _ReplyPageState extends State<ReplyPage> {
  final QuillController _controller = QuillController.basic();

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
          style: TextStyle(color: colorScheme.onSurface),
        ),
      ),
      backgroundColor: colorScheme.background,
      body: Container(
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
                  ),
                ),
              )
            ];
          },
          body: Column(
            children: [
              Expanded(child: Container(
                color: colorScheme.surface,
                padding: const EdgeInsets.only(top: 2, left: 20),
                child: CommonItemList<Comment>(
                  onLoad: (int page) async {
                    var commentList = <Comment>[];
                    commentList.add(Comment.two());
                    commentList.add(Comment.two());
                    commentList.add(Comment.two());
                    commentList.add(Comment.two());
                    return commentList;
                  },
                  enableRefresh: false,
                  enableLoad: true,
                  itemName: "动态",
                  itemHeight: null,
                  isGrip: false,
                  enableScrollbar: true,
                  itemBuilder: (ctx, comment) {
                    return CommentCard(
                      comment: comment,
                      onTap: () {
                        //回复@此人
                        log("@这个人");
                      },
                    );
                  },
                ),
              ),),
              if (MediaQuery.of(context).viewInsets.bottom > 0) PostQuillToolBar(controller: _controller),
              CommentTextField(controller: _controller, focusNode: focusNode)
            ],
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

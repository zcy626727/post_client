import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:post_client/config/global.dart';
import 'package:post_client/model/message/comment.dart';
import 'package:post_client/service/message/comment_service.dart';
import 'package:post_client/view/component/input/comment_text_field.dart';
import 'package:post_client/view/component/quill/quill_tool_bar.dart';
import 'package:post_client/view/page/comment/reply_page.dart';

import '../../../model/user/user.dart';
import 'comment_list_tile.dart';

class CommentList extends StatefulWidget {
  const CommentList({
    Key? key,
    this.enableRefresh = true,
    this.enableScrollbar = false,
    this.enableLoad = true,
    required this.onLoad,
    required this.parentId,
    required this.parentType,
    required this.parentUserId,
  }) : super(key: key);

  final Future<List<Comment>> Function(int) onLoad;
  final bool enableRefresh;
  final bool enableLoad;
  final bool enableScrollbar;
  final String parentId;
  final int parentType;
  final int parentUserId;

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  final EasyRefreshController _refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  final QuillController _controller = QuillController.basic();

  final FocusNode _focusNode = FocusNode();

  List<Comment> _commentList = <Comment>[];

  //当前页数
  int _page = 0;

  late Future _futureBuilderFuture;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  Future getData() async {
    return Future.wait([getDataList()]);
  }

  Future<void> getDataList() async {
    try {
      var list = await widget.onLoad(_page);
      _commentList.addAll(list);
      _page++;
    } on DioException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  //刷新
  void _onRefresh() async {
    try {
      _commentList = await widget.onLoad(0);
      _page = 1;
      //获取成功
      _refreshController.finishRefresh();
      setState(() {});
    } catch (e) {
      //获取失败
      // _refreshController.refreshFailed();
    }
  }

  //加载更多
  void _onLoading() async {
    try {
      var list = await widget.onLoad(_page);
      if (list.isEmpty) {
        //获取
        _refreshController.finishLoad();
      } else {
        _commentList.addAll(list);
        _page++;
        //获取成功
        _refreshController.finishLoad();
        if (mounted) setState(() {});
      }
    } catch (e) {
      //获取失败
      log(e.toString());
      // _refreshController.loadFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _focusNode.unfocus();
                  },
                  child: Container(
                    color: colorScheme.surface,
                    margin: const EdgeInsets.only(top: 2),
                    child: listBuild(),
                  ),
                ),
              ),
              if (_focusNode.hasFocus) PostQuillToolBar(controller: _controller),
              CommentTextField(
                controller: _controller,
                focusNode: _focusNode,
                onSubmit: () async {
                  var content = jsonEncode(_controller.document.toDelta().toJson());
                  var delta = _controller.document.toDelta().toList();
                  List<int> targetUserIdList = <int>[];

                  for (var d in delta) {
                    var data = d.data;
                    if (data is Map<String, dynamic>) {
                      //只要有map类型的就应该不是空的
                      //获取@的人
                      var user = User.fromJson(json.decode(data['at']));
                      targetUserIdList.add(user.id!);
                    }
                  }

                  var comment = await CommentService.createComment(widget.parentId, widget.parentType, widget.parentUserId, targetUserIdList, content);
                  comment.user = Global.user;
                  _commentList.insert(0, comment);
                  _controller.clear();
                  _focusNode.unfocus();
                  setState(() {});
                },
              ),
            ],
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

  Widget listBuild() {
    var colorScheme = Theme.of(context).colorScheme;
    if (_commentList.isEmpty) {
      return Center(
        child: Text("没有评论", style: TextStyle(color: colorScheme.onSurface)),
      );
    }
    var card = ListView.builder(
      itemCount: _commentList.length,
      itemBuilder: (context, index) {
        var comment = _commentList[index];
        return CommentListTile(
          key: ValueKey(comment.id),
          focusNode: _focusNode,
          comment: comment,
          onDeleteComment: (comment) {
            _focusNode.unfocus();
            _commentList.remove(comment);
            setState(() {});
          },
          onTap: () {
            //展开评论
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReplyPage(
                  comment: comment,
                  onDeleteComment: (comment) {
                    _commentList.remove(comment);
                    _focusNode.unfocus();
                    setState(() {});
                  },
                ),
              ),
            );
            _focusNode.unfocus();
          },
        );
      },
    );
    return EasyRefresh(
      header: MaterialHeader(backgroundColor: colorScheme.primaryContainer, color: colorScheme.onPrimaryContainer),
      footer: CupertinoFooter(backgroundColor: colorScheme.primaryContainer, foregroundColor: colorScheme.onPrimaryContainer),
      controller: _refreshController,
      onRefresh: widget.enableRefresh ? _onRefresh : null,
      onLoad: widget.enableLoad ? _onLoading : null,
      child: widget.enableScrollbar
          ? Scrollbar(
              child: card,
            )
          : card,
    );
  }
}

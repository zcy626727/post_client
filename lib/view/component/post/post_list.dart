import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:post_client/model/message/feed_feedback.dart';
import 'package:post_client/view/component/post/post_list_tile.dart';

import '../../../model/message/post.dart';

class PostList extends StatefulWidget {
  const PostList({
    Key? key,
    required this.itemName,
    this.itemHeight,
    this.enableRefresh = true,
    this.enableScrollbar = false,
    this.enableLoad = true,
    required this.onLoad,
  }) : super(key: key);

  final Future<List<Post>> Function(int) onLoad;
  final bool enableRefresh;
  final bool enableLoad;
  final String itemName;
  final double? itemHeight;
  final bool enableScrollbar;

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  final EasyRefreshController _refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  List<Post> _postList = <Post>[];

  //当前页数
  int _page = 0;

  late Future _futureBuilderFuture;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
  }

  Future getData() async {
    var s = ScrollController();
    return Future.wait([getDataList()]);
  }

  Future<void> getDataList() async {
    try {
      var list = await widget.onLoad(_page);
      _postList.addAll(list);
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
      _postList = await widget.onLoad(0);
      _page = 1;
      //获取成功
      _refreshController.finishRefresh();
      // _refreshController.resetNoData();
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
        _postList.addAll(list);
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
    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          return listBuild();
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
    if (_postList.isEmpty) {
      return Center(
        child: Text("没有动态", style: TextStyle(color: colorScheme.onSurface)),
      );
    }
    var card = ListView.builder(
      itemCount: _postList.length,
      itemBuilder: (context, index) {
        var post = _postList[index];
        return PostListTile(
          key: ValueKey(post.id),
          post: post,
          onDeletePost: (deletedPost) {
            _postList.remove(deletedPost);
            setState(() {});
          },
          feedback: post.feedback??FeedFeedback(),
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

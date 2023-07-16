import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:post_client/model/comment.dart';
import 'package:post_client/service/comment_service.dart';

class ReplyCommentListPage extends StatefulWidget {
  const ReplyCommentListPage({super.key});

  @override
  State<ReplyCommentListPage> createState() => _ReplyCommentListPageState();
}

class _ReplyCommentListPageState extends State<ReplyCommentListPage> {
  late Future _futureBuilderFuture;

  List<Comment> _commentList = <Comment>[];

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
  }

  Future getData() async {
    return Future.wait([getFolloweeList()]);
  }

  Future<void> getFolloweeList() async {
    try {
      _commentList = await CommentService.getReplyCommentList(0, 20);
    } on DioException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
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
              title: Text("回复",style: TextStyle(color: colorScheme.onSurface),),
              actions: [],
            ),
            body: ListView.builder(
              itemCount: _commentList.length,
              itemBuilder: (context, index) {
                var comment = _commentList[index];
                return ListTile(
                  leading: Text(comment.content!),
                );
              },
            ),
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
}

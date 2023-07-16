import 'package:dio/dio.dart';

import '../../../model/comment.dart';
import '../../../model/user.dart';
import '../message_http_config.dart';

class CommentApi {
  static Future<Comment> createComment(
    String parentId,
    int parentType,
    String content,
  ) async {
    var r = await MessageHttpConfig.dio.post(
      "/comment/createComment",
      data: {
        "parentId": parentId,
        "parentType": parentType,
        "content": content,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    //获取数据
    return Comment.fromJson(r.data['comment']);
  }

  static Future<void> deleteCommentById(
    String commentId,
  ) async {
    await MessageHttpConfig.dio.post(
      "/comment/deleteCommentById",
      data: {
        "commentId": commentId,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<List<Comment>> getCommentListByParent(
    String parentId,
    int parentType,
    int pageIndex,
    int pageSize,
  ) async {
    var r = await MessageHttpConfig.dio.get(
      "/comment/getCommentListByParent",
      queryParameters: {
        "parentId": parentId,
        "parentType": parentType,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": false,
      }),
    );
    var commentList = _parseCommentWithUser(r);
    return commentList;
  }

  static Future<Comment> getCommentById(
    String commentId,
  ) async {
    var r = await MessageHttpConfig.dio.get(
      "/comment/getCommentById",
      data: {
        "commentId": commentId,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    return Comment.fromJson(r.data['comment']);
  }

  //获取回复我的评论列表
  static Future<List<Comment>> getReplyCommentList(
    int pageIndex,
    int pageSize,
  ) async {
    var r = await MessageHttpConfig.dio.get(
      "/comment/getReplyCommentList",
      data: {
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    var commentList = _parseCommentWithUser(r);
    return commentList;
  }

  static List<Comment> _parseCommentWithUser(Response<dynamic> r) {
    Map<int, User> userMap = {};
    for (var userJson in r.data['userList']) {
      var user = User.fromJson(userJson);
      userMap[user.id ?? 0] = user;
    }
    List<Comment> commentList = [];
    for (var postJson in r.data['commentList']) {
      var comment = Comment.fromJson(postJson);
      comment.user = userMap[comment.userId];
      commentList.add(comment);
    }
    return commentList;
  }
}

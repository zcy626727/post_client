import 'package:dio/dio.dart';

import '../../../model/post/comment.dart';
import '../../../model/user/user.dart';
import '../post_http_config.dart';

class CommentApi {
  static Future<Comment> createComment(
    String parentId,
    int parentType,
    int parentUserId,
    List<int> targetUserIdList,
    String content,
  ) async {
    var r = await PostHttpConfig.dio.post(
      "/comment/createComment",
      data: {
        "parentId": parentId,
        "parentType": parentType,
        "parentUserId": parentUserId,
        "content": content,
        "targetUserIdList": targetUserIdList,
      },
      options: PostHttpConfig.options.copyWith(extra: {
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
    await PostHttpConfig.dio.post(
      "/comment/deleteCommentById",
      data: {
        "commentId": commentId,
      },
      options: PostHttpConfig.options.copyWith(extra: {
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
    var r = await PostHttpConfig.dio.get(
      "/comment/getCommentListByParent",
      queryParameters: {
        "parentId": parentId,
        "parentType": parentType,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": false,
      }),
    );
    var commentList = _parseCommentListWithUser(r);
    return commentList;
  }

  static Future<Comment> getCommentById(
    String commentId,
  ) async {
    var r = await PostHttpConfig.dio.get(
      "/comment/getCommentById",
      queryParameters: {
        "commentId": commentId,
      },
      options: PostHttpConfig.options.copyWith(extra: {
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
    var r = await PostHttpConfig.dio.get(
      "/comment/getReplyCommentList",
      queryParameters: {
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    var commentList = _parseCommentListWithUser(r);
    return commentList;
  }

  static Future<Map<String, Comment>> getCommentMapByIdList(
    List<String> commentIdList,
  ) async {
    var r = await PostHttpConfig.dio.post(
      "/comment/getCommentListByIdList",
      data: {
        "commentIdList": commentIdList,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": false,
      }),
    );

    return _parseCommentMapWithUser(r);
  }

  static List<Comment> _parseCommentListWithUser(Response<dynamic> r) {
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

  static Map<String, Comment> _parseCommentMapWithUser(Response<dynamic> r) {
    Map<int, User> userMap = {};
    if (r.data['userList'] != null) {
      for (var userJson in r.data['userList']) {
        var user = User.fromJson(userJson);
        userMap[user.id!] = user;
      }
    }

    Map<String, Comment> commentMap = {};
    if (r.data['commentList'] != null) {
      for (var commentJson in r.data['commentList']) {
        var comment = Comment.fromJson(commentJson);
        comment.user = userMap[comment.userId];
        commentMap[comment.id!] = comment;
      }
    }
    return commentMap;
  }
}

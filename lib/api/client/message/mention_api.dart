
import 'package:dio/dio.dart';
import 'package:post_client/model/message/comment.dart';
import 'package:post_client/model/message/mention.dart';

import '../../../model/message/post.dart';
import '../../../model/user/user.dart';
import '../message_http_config.dart';

class MentionApi{
  //获取回复我的评论列表
  static Future<List<Mention>> getReplyMentionList(
      int pageIndex,
      int pageSize,
      ) async {
    var r = await MessageHttpConfig.dio.get(
      "/mention/getReplyMentionList",
      queryParameters: {
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    var mentionList = _parseCommentWithUser(r);
    return mentionList;
  }

  static List<Mention> _parseCommentWithUser(Response<dynamic> r) {
    Map<int, User> sourceUserMap = {};
    for (var userJson in r.data['sourceUserList']) {
      var user = User.fromJson(userJson);
      sourceUserMap[user.id ?? 0] = user;
    }
    List<Mention> mentionList = [];
    for (var postJson in r.data['mentionList']) {
      var mention = Mention.fromJson(postJson);
      mention.sourceUser = sourceUserMap[mention.targetUserId];
      mentionList.add(mention);
    }
    return mentionList;
  }

  static Future<(Map<String, Post>, Map<String, Comment>)> getMentionSourceListByIdList({
    required List<String> postIdList,
    required List<String> commentIdList,
  }) async {
    var r = await MessageHttpConfig.dio.get(
      "/mention/getMentionSourceListByIdList",
      queryParameters: {
        "postIdList": postIdList,
        "commentIdList": commentIdList,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": false,
      }),
    );

    Map<String, Post> postMap = {};
    if (r.data['postList'] != null) {
      for (var articleJson in r.data['postList']) {
        var post = Post.fromJson(articleJson);
        postMap[post.id!] = post;
      }
    }

    Map<String, Comment> commentMap = {};
    if (r.data['commentList'] != null) {
      for (var commentJson in r.data['commentList']) {
        var comment = Comment.fromJson(commentJson);
        commentMap[comment.id!] = comment;
      }
    }

    return (postMap, commentMap);
  }
}
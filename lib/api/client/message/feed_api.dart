import 'package:dio/dio.dart';
import 'package:post_client/api/client/message_http_config.dart';
import 'package:post_client/model/message/comment.dart';
import 'package:post_client/model/message/post.dart';

import '../../../model/user/user.dart';

class FeedApi {
  static Future<(Map<String, Post>, Map<String, Comment>)> getFeedMapByIdList({
    required List<String> posIdtList,
    required List<String> commentIdList,
  }) async {
    var r = await MessageHttpConfig.dio.get(
      "/feed/getFeedListByIdList",
      queryParameters: {
        "posIdtList": posIdtList,
        "commentIdList": commentIdList,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": false,
      }),
    );

    return _parseFeedMap(r);
  }

  static Future<(List<Post>, List<Comment>)> getFeedListByIdList({
    List<String>? postIdList,
    List<String>? commentIdList,
  }) async {
    var r = await MessageHttpConfig.dio.get(
      "/feed/getFeedListByIdList",
      queryParameters: {
        "postIdList": postIdList ?? [],
        "commentIdList": commentIdList ?? [],
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": false,
      }),
    );

    return _parseFeedList(r);
  }

  static (Map<String, Post>, Map<String, Comment>) _parseFeedMap(Response<dynamic> r) {
    Map<int, User> userMap = {};
    if (r.data['userList'] != null) {
      for (var userJson in r.data['userList']) {
        var user = User.fromJson(userJson);
        userMap[user.id!] = user;
      }
    }

    Map<String, Post> postMap = {};
    if (r.data['postList'] != null) {
      for (var postJson in r.data['postList']) {
        var post = Post.fromJson(postJson);
        post.user = userMap[post.userId];
        postMap[post.id!] = post;
      }
    }

    Map<String, Comment> commentMap = {};
    if (r.data['commentList'] != null) {
      for (var audioJson in r.data['commentList']) {
        var comment = Comment.fromJson(audioJson);
        comment.user = userMap[comment.userId];
        commentMap[comment.id!] = comment;
      }
    }
    return (postMap, commentMap);
  }

  static (List<Post>, List<Comment>) _parseFeedList(Response<dynamic> r) {
    Map<int, User> userMap = {};
    if (r.data['userList'] != null) {
      for (var userJson in r.data['userList']) {
        var user = User.fromJson(userJson);
        userMap[user.id!] = user;
      }
    }

    List<Post> postList = [];
    if (r.data['postList'] != null) {
      for (var postJson in r.data['postList']) {
        var post = Post.fromJson(postJson);
        post.user = userMap[post.userId];
        postList.add(post);
      }
    }

    List<Comment> commentList = [];
    if (r.data['commentList'] != null) {
      for (var audioJson in r.data['commentList']) {
        var comment = Comment.fromJson(audioJson);
        comment.user = userMap[comment.userId];
        commentList.add(comment);
      }
    }
    return (postList, commentList);
  }
}

import 'package:dio/dio.dart';

import '../../../model/message/post.dart';
import '../../../model/user/user.dart';
import '../message_http_config.dart';

class PostApi {
  static Future<Post> createPost(
    String? sourceId,
    int? sourceType,
    String content,
    List<String>? pictureUrlList,
    List<int>? targetUserIdList,
  ) async {
    var r = await MessageHttpConfig.dio.post(
      "/post/createPost",
      data: {
        "sourceId": sourceId,
        "sourceType": sourceType,
        "content": content,
        "pictureUrlList": pictureUrlList,
        "targetUserIdList": targetUserIdList,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    //获取数据
    return Post.fromJson(r.data['post']);
  }

  static Future<void> deletePost(
    String postId,
  ) async {
    await MessageHttpConfig.dio.post(
      "/post/deletePostById",
      data: {
        "postId": postId,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<Post> getPostById(
    String postId,
  ) async {
    var r = await MessageHttpConfig.dio.get(
      "/post/getPostById",
      queryParameters: {
        "postId": postId,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": true,
      }),
    );
    //获取数据
    return Post.fromJson(r.data['post']);
  }

  static Future<List<Post>> getPostListByUserId(
    int userId,
    int pageIndex,
    int pageSize,
  ) async {
    var r = await MessageHttpConfig.dio.get(
      "/post/getPostListByUserId",
      queryParameters: {
        "userId": userId,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": false,
      }),
    );
    List<Post> postList = [];
    for (var postJson in r.data['postList']) {
      var post = Post.fromJson(postJson);
      postList.add(post);
    }
    return postList;
  }

  static Future<List<Post>> getPostListRandom(
    int pageSize,
  ) async {
    var r = await MessageHttpConfig.dio.get(
      "/post/getPostListRandom",
      queryParameters: {
        "pageSize": pageSize,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": false,
      }),
    );

    var postList = _parsePostWithUser(r);
    return postList;
  }

  static Future<List<Post>> getFolloweePostList(
    int sourceType,
    int pageIndex,
    int pageSize,
  ) async {
    var r = await MessageHttpConfig.dio.get(
      "/post/getFolloweePostList",
      queryParameters: {
        "sourceType": sourceType,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": true,
      }),
    );

    var postList = _parsePostWithUser(r);
    return postList;
  }

  static Future<Map<String, Post>> getPostMapByIdList(
      List<String> postIdList,
      ) async {
    var r = await MessageHttpConfig.dio.post(
      "/post/getPostListByIdList",
      data: {
        "commentIdList": postIdList,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": false,
      }),
    );

    return _parsePostMapWithUser(r);
  }

  static List<Post> _parsePostWithUser(Response<dynamic> r) {
    Map<int, User> userMap = {};
    for (var userJson in r.data['userList']) {
      var user = User.fromJson(userJson);
      userMap[user.id ?? 0] = user;
    }
    List<Post> postList = [];
    for (var postJson in r.data['postList']) {
      var post = Post.fromJson(postJson);
      post.user = userMap[post.userId];
      postList.add(post);
    }
    return postList;
  }

  static Map<String, Post> _parsePostMapWithUser(Response<dynamic> r) {
    Map<int, User> userMap = {};
    if (r.data['userList'] != null) {
      for (var userJson in r.data['userList']) {
        var user = User.fromJson(userJson);
        userMap[user.id!] = user;
      }
    }

    Map<String, Post> postMap = {};
    if (r.data['commentList'] != null) {
      for (var commentJson in r.data['commentList']) {
        var post = Post.fromJson(commentJson);
        post.user = userMap[post.userId];
        postMap[post.id!] = post;
      }
    }
    return postMap;
  }
}

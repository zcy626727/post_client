import 'package:dio/dio.dart';

import '../../../model/post/post.dart';
import '../../../model/user/user.dart';
import '../post_http_config.dart';

class PostApi {
  static Future<Post> createPost(
    String? sourceId,
    int? sourceType,
    String content,
    List<String>? pictureUrlList,
    List<int>? targetUserIdList,
  ) async {
    var r = await PostHttpConfig.dio.post(
      "/post/createPost",
      data: {
        "sourceId": sourceId,
        "sourceType": sourceType,
        "content": content,
        "pictureUrlList": pictureUrlList,
        "targetUserIdList": targetUserIdList,
      },
      options: PostHttpConfig.options.copyWith(extra: {
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
    await PostHttpConfig.dio.post(
      "/post/deletePostById",
      data: {
        "postId": postId,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<Post> getPostById(
    String postId,
  ) async {
    var r = await PostHttpConfig.dio.get(
      "/post/getPostById",
      queryParameters: {
        "postId": postId,
      },
      options: PostHttpConfig.options.copyWith(extra: {
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
    var r = await PostHttpConfig.dio.get(
      "/post/getPostListByUserId",
      queryParameters: {
        "userId": userId,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": false,
      }),
    );
    List<Post> postList = [];
    if (r.data['postList'] != null) {
      for (var postJson in r.data['postList']) {
        var post = Post.fromJson(postJson);
        postList.add(post);
      }
    }

    return postList;
  }

  static Future<List<Post>> getPostListRandom(
    int pageSize,
  ) async {
    var r = await PostHttpConfig.dio.get(
      "/post/getPostListRandom",
      queryParameters: {
        "pageSize": pageSize,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": false,
      }),
    );

    var postList = _parsePostListWithUser(r);
    return postList;
  }

  static Future<List<Post>> getFolloweePostList(
    int sourceType,
    int pageIndex,
    int pageSize,
  ) async {
    var r = await PostHttpConfig.dio.get(
      "/post/getFolloweePostList",
      queryParameters: {
        "sourceType": sourceType,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": true,
      }),
    );

    var postList = _parsePostListWithUser(r);
    return postList;
  }

  static Future<Map<String, Post>> getPostMapByIdList(
    List<String> postIdList,
  ) async {
    var r = await PostHttpConfig.dio.post(
      "/post/getPostListByIdList",
      data: {
        "commentIdList": postIdList,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": false,
      }),
    );

    return _parsePostMapWithUser(r);
  }

  static Future<List<Post>> searchPost(
    String content,
    int page,
    int pageSize,
  ) async {
    var r = await PostHttpConfig.dio.get(
      "/post/searchPost",
      queryParameters: {
        "content": content,
        "page": page,
        "pageSize": pageSize,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": false,
      }),
    );

    return _parsePostListWithUser(r);
  }

  static List<Post> _parsePostListWithUser(Response<dynamic> r) {
    Map<int, User> userMap = {};
    if (r.data['userList'] != null) {
      for (var userJson in r.data['userList']) {
        var user = User.fromJson(userJson);
        userMap[user.id ?? 0] = user;
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

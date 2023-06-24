import 'package:dio/dio.dart';
import 'package:post_client/model/comment.dart';
import 'package:post_client/model/post.dart';
import 'package:post_client/model/user.dart';

import '../../config/global.dart';
import '../../config/net_config.dart';

class PostHttpConfig {
  static Options options = Options();

  static Dio dio = Dio(BaseOptions(
    baseUrl: NetConfig.postApiUrl,
  ));

  static void init() {
    // 添加拦截器
    dio.interceptors.add(Global.netCacheInterceptor);
    dio.interceptors.add(Global.netCommonInterceptor);
  }
}

class PostApi {
  static Future<Post> createPost(
    String? sourceId,
    int? sourceType,
    String content,
    List<String>? pictureUrlList,
  ) async {
    var r = await PostHttpConfig.dio.post(
      "/post/createPost",
      data: {
        "sourceId": sourceId,
        "sourceType": sourceType,
        "content": content,
        "pictureUrlList": pictureUrlList,
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
    var postList = _parsePostWithUser(r);
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

    var postList = _parsePostWithUser(r);
    return postList;
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
}

class CommentApi {
  static Future<Comment> createComment(
    String parentId,
    int parentType,
    String content,
  ) async {
    var r = await PostHttpConfig.dio.post(
      "/comment/createComment",
      data: {
        "parentId": parentId,
        "parentType": parentType,
        "content": content,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    //获取数据
    return Comment.fromJson(r.data['comment']);
  }

  static Future<void> deleteComment(
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

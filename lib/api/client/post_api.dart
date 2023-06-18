import 'package:dio/dio.dart';
import 'package:post_client/model/post.dart';

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
      "/post/deletePost",
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
    for (var postJson in r.data['postList']) {
      postList.add(Post.fromJson(postJson));
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
    List<Post> postList = [];
    for (var postJson in r.data['postList']) {
      postList.add(Post.fromJson(postJson));
    }
    return postList;
  }
}

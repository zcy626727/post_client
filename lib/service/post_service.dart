import 'package:post_client/api/client/message_http_config.dart';
import 'package:post_client/model/post.dart';

import '../api/client/message/post_api.dart';
import '../model/user.dart';

class PostService {
  static Future<Post> createPost(
    String? sourceId,
    int? sourceType,
    String content,
    List<String>? pictureUrlList,
  ) async {
    var post = await PostApi.createPost(sourceId, sourceType, content, pictureUrlList);
    return post;
  }

  static Future<void> deletePost(
    String postId,
  ) async {
    await PostApi.deletePost(postId);
  }

  static Future<Post> getPostById(
    String postId,
  ) async {
    var post = await PostApi.getPostById(postId);
    return post;
  }

  static Future<List<Post>> getPostListByUserId(
    User user,
    int pageIndex,
    int pageSize,
  ) async {
    var postList = await PostApi.getPostListByUserId(user.id!, pageIndex, pageSize);
    for (var post in postList) {
      post.user = user;
    }
    return postList;
  }

  static Future<List<Post>> getPostListRandom(
    int pageSize,
  ) async {
    var postList = await PostApi.getPostListRandom(pageSize);
    return postList;
  }
}

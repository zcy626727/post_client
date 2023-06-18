import 'package:post_client/api/client/post_api.dart';
import 'package:post_client/model/post.dart';

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
    int userId,
    int pageIndex,
    int pageSize,
  ) async {
    var postList = await PostApi.getPostListByUserId(userId, pageIndex, pageSize);
    return postList;
  }

  static Future<List<Post>> getPostListRandom(
    int pageSize,
  ) async {
    var postList = await PostApi.getPostListRandom(pageSize);
    return postList;
  }
}

import 'package:post_client/api/client/media/media_api.dart';
import 'package:post_client/model/post.dart';

import '../api/client/message/post_api.dart';
import '../model/user.dart';

class PostService {
  static Future<Post> createPost(
    String? sourceId,
    int? sourceType,
    String content,
    List<String>? pictureUrlList,
    List<int>? targetUserIdList,
  ) async {
    var post = await PostApi.createPost(sourceId, sourceType, content, pictureUrlList, targetUserIdList);
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
    await fillMedia(postList);
    return postList;
  }

  static Future<List<Post>> getPostListRandom(
    int pageSize,
  ) async {
    var postList = await PostApi.getPostListRandom(pageSize);
    await fillMedia(postList);
    return postList;
  }

  static Future<List<Post>> getFolloweePostList(
    int sourceType,
    int pageIndex,
    int pageSize,
  ) async {
    var postList = await PostApi.getFolloweePostList(sourceType, pageIndex, pageSize);
    await fillMedia(postList);
    return postList;
  }

  static Future<void> fillMedia(List<Post> postList) async {
    List<String> articleIdList = <String>[];
    List<String> audioIdList = <String>[];
    List<String> galleryIdList = <String>[];
    List<String> videoIdList = <String>[];
    //获取媒体列表
    for (var post in postList) {
      if (post.hasMedia() && post.sourceId != null) {
        switch (post.sourceType) {
          case PostSourceType.article:
            articleIdList.add(post.sourceId!);
          case PostSourceType.video:
            videoIdList.add(post.sourceId!);
          case PostSourceType.audio:
            audioIdList.add(post.sourceId!);
          case PostSourceType.gallery:
            galleryIdList.add(post.sourceId!);
        }
      }
    }
    var (articleMap, audioMap, galleryMap, videoMap) = await MediaApi.getMediaListByIdList(
      articleIdList: articleIdList,
      audioIdList: audioIdList,
      galleryIdList: galleryIdList,
      videoIdList: videoIdList,
    );

    //填充
    for (var post in postList) {
      if (post.hasMedia() && post.sourceId != null) {
        switch (post.sourceType) {
          case PostSourceType.article:
            post.media = articleMap[post.sourceId];
          case PostSourceType.video:
            post.media = videoMap[post.sourceId];
          case PostSourceType.audio:
            post.media = audioMap[post.sourceId];
          case PostSourceType.gallery:
            post.media = galleryMap[post.sourceId];
        }
      }
    }
  }
}

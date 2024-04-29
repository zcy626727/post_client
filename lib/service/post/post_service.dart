import 'package:post_client/config/global.dart';

import '../../api/client/post/post_api.dart';
import '../../api/client/post/source_api.dart';
import '../../constant/source.dart';
import '../../model/post/feedback.dart';
import '../../model/post/post.dart';
import '../../model/user/user.dart';
import 'feedback_service.dart';

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
    if (postList.isNotEmpty) {
      await fillMedia(postList);
      await fillFeedback(postList);
    }

    return postList;
  }

  static Future<List<Post>> getPostListRandom(
    int pageSize,
  ) async {
    var postList = await PostApi.getPostListRandom(pageSize);
    if (postList.isNotEmpty) {
      await fillMedia(postList);
      await fillFeedback(postList);
    }
    return postList;
  }

  static Future<List<Post>> getFolloweePostList(
    int sourceType,
    int pageIndex,
    int pageSize,
  ) async {
    var postList = await PostApi.getFolloweePostList(sourceType, pageIndex, pageSize);
    if (postList.isNotEmpty) {
      await fillMedia(postList);
      await fillFeedback(postList);
    }

    return postList;
  }

  static Future<void> fillFeedback(List<Post> postList) async {
    //如果没有登录就不需要填充
    if (Global.user.id == null) {
      return;
    }
    //获取媒体列表
    var map = await FeedbackService.getFeedbackMap(postList, SourceType.post);

    //填充
    for (var post in postList) {
      post.feedback = map[post.id] ?? Feedback();
    }
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
          case SourceType.article:
            articleIdList.add(post.sourceId!);
          case SourceType.video:
            videoIdList.add(post.sourceId!);
          case SourceType.audio:
            audioIdList.add(post.sourceId!);
          case SourceType.gallery:
            galleryIdList.add(post.sourceId!);
        }
      }
    }
    var (_, _, articleMap, audioMap, galleryMap, videoMap) = await SourceApi.getSourceMapByIdList(
      articleIdList: articleIdList,
      audioIdList: audioIdList,
      galleryIdList: galleryIdList,
      videoIdList: videoIdList,
    );

    //填充
    for (var post in postList) {
      if (post.hasMedia() && post.sourceId != null) {
        switch (post.sourceType) {
          case SourceType.article:
            post.media = articleMap[post.sourceId];
          case SourceType.video:
            post.media = videoMap[post.sourceId];
          case SourceType.audio:
            post.media = audioMap[post.sourceId];
          case SourceType.gallery:
            post.media = galleryMap[post.sourceId];
        }
      }
    }
  }

  static Future<List<Post>> searchPost(
    String content,
    int page,
    int pageSize,
  ) async {
    var postList = await PostApi.searchPost(content, page, pageSize);
    return postList;
  }
}

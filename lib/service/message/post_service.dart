import 'package:flutter/material.dart';
import 'package:post_client/config/global.dart';
import 'package:post_client/model/message/feed_feedback.dart';
import 'package:post_client/service/source_service.dart';

import '../../api/client/media/media_api.dart';
import '../../api/client/message/post_api.dart';
import '../../constant/feed.dart';
import '../../constant/post.dart';
import '../../model/message/post.dart';
import '../../model/user/user.dart';
import 'feed_service.dart';

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
    await fillFeedback(postList);
    return postList;
  }

  static Future<List<Post>> getPostListRandom(
    int pageSize,
  ) async {
    var postList = await PostApi.getPostListRandom(pageSize);
    await fillMedia(postList);
    await fillFeedback(postList);
    return postList;
  }

  static Future<List<Post>> getFolloweePostList(
    int sourceType,
    int pageIndex,
    int pageSize,
  ) async {
    var postList = await PostApi.getFolloweePostList(sourceType, pageIndex, pageSize);
    await fillMedia(postList);
    await fillFeedback(postList);
    return postList;
  }

  static Future<void> fillFeedback(List<Post> postList) async {
    //如果没有登录就不需要填充
    if (Global.user.id == null) {
      return;
    }
    //获取媒体列表
    var map = await FeedService.getFeedbackMap(postList, FeedType.post);

    //填充
    for (var post in postList) {
      post.feedback = map[post.id] ?? FeedFeedback();
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
    var (articleMap, audioMap, galleryMap, videoMap) = await MediaApi.getMediaMapByIdList(
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

  static Future<List<Post>> searchPost(
    String content,
    int page,
    int pageSize,
  ) async {
    var postList = await PostApi.searchPost(content, page, pageSize);
    return postList;
  }
}

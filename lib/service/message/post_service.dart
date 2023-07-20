import 'package:flutter/material.dart';
import 'package:post_client/model/message/feed_feedback.dart';
import 'package:post_client/service/source_service.dart';

import '../../api/client/message/post_api.dart';
import '../../constant/feed.dart';
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
    await SourceService.fillMedia(postList);
    return postList;
  }

  static Future<List<Post>> getPostListRandom(
    int pageSize,
  ) async {
    var postList = await PostApi.getPostListRandom(pageSize);
    await SourceService.fillMedia(postList);
    await fillFeedback(postList);
    return postList;
  }

  static Future<List<Post>> getFolloweePostList(
    int sourceType,
    int pageIndex,
    int pageSize,
  ) async {
    var postList = await PostApi.getFolloweePostList(sourceType, pageIndex, pageSize);
    await SourceService.fillMedia(postList);
    await fillFeedback(postList);
    return postList;
  }

  static Future<void> fillFeedback(List<Post> postList) async {
    //获取媒体列表
    var map = await FeedService.getFeedbackMap(postList, FeedType.post);

    //填充
    for (var post in postList) {
      post.feedback = map[post.id]??FeedFeedback();
    }
  }
}

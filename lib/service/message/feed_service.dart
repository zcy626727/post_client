import 'dart:math';

import 'package:post_client/api/client/message/feed_api.dart';
import 'package:post_client/api/client/message/feed_feedback_api.dart';
import 'package:post_client/model/message/comment.dart';
import 'package:post_client/model/message/feed_feedback.dart';
import 'package:post_client/model/message/post.dart';
import 'package:post_client/service/message/comment_service.dart';
import 'package:post_client/service/message/post_service.dart';

import '../../model/message/feed.dart';

class FeedService {
  static Future<Map<String, FeedFeedback>> getFeedbackMap(List<Feed> feedList, int feedType) async {
    List<String> feedIdList = <String>[];
    //获取媒体列表
    for (var feed in feedList) {
      if (feed.id != null) {
        feedIdList.add(feed.id!);
      }
    }
    return await FeedFeedbackApi.getFeedFeedbackMap(feedType, feedIdList);
  }

  static Future<(List<Post>, List<Comment>)> getFeedListByIdList({
    List<String>? postIdList,
    List<String>? commentIdList,
    int pageIndex = 0,
    int pageSize = 20,
  }) async {
    int startIndex = pageIndex * pageSize;
    int endIndex = startIndex + pageSize;

    //超过范围
    if (postIdList != null) {
      endIndex = min(endIndex, postIdList.length);
    }
    if (commentIdList != null) {
      endIndex = min(endIndex, commentIdList.length);
    }
    if (startIndex > endIndex) return (<Post>[], <Comment>[]);
    postIdList = postIdList?.sublist(startIndex, endIndex);
    commentIdList = commentIdList?.sublist(pageIndex * pageSize, endIndex);
    //如果没有数据直接返回
    if ((postIdList == null || postIdList.isEmpty) && (commentIdList == null || commentIdList.isEmpty)) return (<Post>[], <Comment>[]);

    var (postList, commentList) = await FeedApi.getFeedListByIdList(
      postIdList: postIdList,
      commentIdList: commentIdList,
    );

    if (postList.isNotEmpty) {
      await PostService.fillMedia(postList);
      await PostService.fillFeedback(postList);
    }

    if (commentList.isNotEmpty) {
      await CommentService.fillFeedback(commentList);
    }
    return (postList, commentList);
  }
}

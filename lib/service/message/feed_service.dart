import 'package:post_client/api/client/message/feed_api.dart';
import 'package:post_client/api/client/message/feed_feedback_api.dart';
import 'package:post_client/model/message/comment.dart';
import 'package:post_client/model/message/feed_feedback.dart';
import 'package:post_client/model/message/post.dart';
import 'package:post_client/service/message/comment_service.dart';
import 'package:post_client/service/message/post_service.dart';
import 'package:post_client/service/source_service.dart';

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
  }) async {
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

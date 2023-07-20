import 'package:post_client/api/client/message/feed_feedback_api.dart';
import 'package:post_client/model/message/feed_feedback.dart';

import '../../model/message/feed.dart';

class FeedService {
  static Future<Map<String, FeedFeedback>> getFeedbackMap(List<Feed> feedList,int feedType) async {
    List<String> feedIdList = <String>[];
    //获取媒体列表
    for (var feed in feedList) {
      if (feed.id != null) {
        feedIdList.add(feed.id!);
      }
    }
    return await FeedFeedbackApi.getFeedFeedbackMap(feedType, feedIdList);
  }

}
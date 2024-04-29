import 'package:post_client/model/post/source.dart';

import '../../api/client/post/feedback_api.dart';
import '../../config/global.dart';
import '../../model/post/feedback.dart';

class FeedbackService {
  static Future<Feedback> uploadFeedback({
    int like = 0,
    int dislike = 0,
    int favorites = 0,
    int share = 0,
    required int sourceType,
    required String sourceId,
  }) async {
    if (like == 0 && dislike == 0 && favorites == 0 && share == 0) {
      throw const FormatException("操作失败");
    }
    if(Global.user.id==null){
      return Feedback();
    }
    return await FeedbackApi.uploadFeedback(
      like: like,
      dislike: dislike,
      favorites: favorites,
      share: share,
      sourceType: sourceType,
      sourceId: sourceId,
    );
  }

  static Future<Feedback?> getFeedback(
    int mediaType,
    String mediaId,
  ) async {
    if (Global.user.id == null) {
      return null;
    }
    return await FeedbackApi.getFeedback(
          mediaType,
          mediaId,
        ) ??
        Feedback();
  }

  static Future<Map<String, Feedback>> getFeedbackMap(List<Source> feedList, int feedType) async {
    List<String> feedIdList = <String>[];
    //获取媒体列表
    for (var feed in feedList) {
      if (feed.id != null) {
        feedIdList.add(feed.id!);
      }
    }
    return await FeedbackApi.getFeedbackListMap(feedType, feedIdList);
  }
}

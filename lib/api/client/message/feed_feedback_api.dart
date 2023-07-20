import 'package:dio/dio.dart';
import 'package:post_client/api/client/message_http_config.dart';

import '../../../model/message/feed_feedback.dart';

class FeedFeedbackApi {
  static Future<FeedFeedback> uploadFeedFeedback({
    int like = 0,
    int dislike = 0,
    int favorites = 0,
    int share = 0,
    required int feedType,
    required String feedId,
  }) async {
    var r = await MessageHttpConfig.dio.post(
      "/feedFeedback/uploadFeedFeedback",
      data: {
        "like": like,
        "dislike": dislike,
        "favorites": favorites,
        "share": share,
        "feedType": feedType,
        "feedId": feedId,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    return FeedFeedback.fromJson(r.data['feedFeedback']);
  }

  static Future<Map<String, FeedFeedback>> getFeedFeedbackMap(
    int feedType,
    List<String> feedIdList,
  ) async {
    var r = await MessageHttpConfig.dio.get(
      "/feedFeedback/getFeedFeedbackList",
      queryParameters: {
        "feedType": feedType,
        "feedIdList": feedIdList,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    return _parseFeedFeedbackMap(r);
  }

  static Map<String, FeedFeedback> _parseFeedFeedbackMap(Response<dynamic> r) {
    if(r.data['feedFeedbackList']==null){
      return {};
    }
    Map<String, FeedFeedback> map = {};
    for (var feedFeedbackJson in r.data['feedFeedbackList']) {
      var feedFeedback = FeedFeedback.fromJson(feedFeedbackJson);
      map[feedFeedback.id ?? ""] = feedFeedback;
    }
    return map;
  }

  static List<FeedFeedback> _parseFeedFeedbackList(Response<dynamic> r) {
    List<FeedFeedback> list = [];
    for (var feedFeedbackJson in r.data['feedFeedbackList']) {
      var feedFeedback = FeedFeedback.fromJson(feedFeedbackJson);
      list.add(feedFeedback);
    }
    return list;
  }
}

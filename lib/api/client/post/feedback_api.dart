import 'package:dio/dio.dart';

import '../../../model/post/feedback.dart';
import '../post_http_config.dart';

class FeedbackApi {
  static Future<Feedback> uploadFeedback({
    int like = 0,
    int dislike = 0,
    int favorites = 0,
    int share = 0,
    required int sourceType,
    required String sourceId,
  }) async {
    var r = await PostHttpConfig.dio.post(
      "/feedback/uploadFeedback",
      data: {
        "like": like,
        "dislike": dislike,
        "favorites": favorites,
        "share": share,
        "sourceType": sourceType,
        "sourceId": sourceId,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    return Feedback.fromJson(r.data['feedback']);
  }

  static Future<Feedback?> getFeedback(
    int sourceType,
    String sourceId,
  ) async {
    var r = await PostHttpConfig.dio.get(
      "/feedback/getFeedback",
      queryParameters: {
        "sourceType": sourceType,
        "sourceId": sourceId,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    return Feedback.fromJson(r.data['feedback']);
  }

  static Future<Map<String, Feedback>> getFeedbackListMap(
    int sourceType,
    List<String> sourceIdList,
  ) async {
    var r = await PostHttpConfig.dio.get(
      "/feedback/getFeedbackListByIdList",
      queryParameters: {
        "sourceType": sourceType,
        "sourceIdList": sourceIdList,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    return _parseFeedbackMap(r);
  }

  static Map<String, Feedback> _parseFeedbackMap(Response<dynamic> r) {
    if (r.data['feedbackList'] == null) {
      return {};
    }
    Map<String, Feedback> map = {};
    for (var feedFeedbackJson in r.data['feedbackList']) {
      var feedFeedback = Feedback.fromJson(feedFeedbackJson);
      map[feedFeedback.sourceId ?? ""] = feedFeedback;
    }
    return map;
  }

  static List<Feedback> _parseFeedback(Response<dynamic> r) {
    List<Feedback> list = [];
    for (var feedbackJson in r.data['feedbackList']) {
      var feedback = Feedback.fromJson(feedbackJson);
      list.add(feedback);
    }
    return list;
  }
}

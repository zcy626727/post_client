import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:post_client/model/media_feedback.dart';

import '../media_http_config.dart';

class MediaFeedbackApi {
  static Future<MediaFeedback> uploadMediaFeedback({
    int like = 0,
    int dislike = 0,
    int favorites = 0,
    int share = 0,
    required int mediaType,
    required String mediaId,
  }) async {
    var r = await MediaHttpConfig.dio.post(
      "/mediaFeedback/uploadMediaFeedback",
      data: {
        "like": like,
        "dislike": dislike,
        "favorites": favorites,
        "share": share,
        "mediaType": mediaType,
        "mediaId": mediaId,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    return MediaFeedback.fromJson(r.data['mediaFeedback']);
  }

  static Future<MediaFeedback> getMediaFeedback(
    int mediaType,
    String mediaId,
  ) async {
    var r = await MediaHttpConfig.dio.get(
      "/mediaFeedback/getMediaFeedback",
      queryParameters: {
        "mediaType": mediaType,
        "mediaId": mediaId,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    return MediaFeedback.fromJson(r.data['mediaFeedback']);
  }

  static List<MediaFeedback> _parseMediaFeedback(Response<dynamic> r){
    List<MediaFeedback> list = [];
    for (var mediaFeedbackJson in r.data['mediaFeedbackList']) {
      var mediaFeedback = MediaFeedback.fromJson(mediaFeedbackJson);
      list.add(mediaFeedback);
    }
    return list;
  }
}

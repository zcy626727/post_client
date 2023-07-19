import 'package:dio/dio.dart';
import 'package:post_client/api/client/media/media_feedback_api.dart';
import 'package:post_client/model/media_feedback.dart';

class MediaFeedbackService {
  static Future<MediaFeedback> uploadMediaFeedback({
    int like = 0,
    int dislike = 0,
    int favorites = 0,
    int share = 0,
    required int mediaType,
    required String mediaId,
  }) async {
    if (like == 0 && dislike == 0 && favorites == 0 && share == 0) {
      throw const FormatException("操作失败");
    }
    return await MediaFeedbackApi.uploadMediaFeedback(
      like: like,
      dislike: dislike,
      favorites: favorites,
      share: share,
      mediaType: mediaType,
      mediaId: mediaId,
    );
  }

  static Future<MediaFeedback> getMediaFeedback(
    int mediaType,
    String mediaId,
  ) async {
    return await MediaFeedbackApi.getMediaFeedback(
      mediaType,
      mediaId,
    );
  }
}

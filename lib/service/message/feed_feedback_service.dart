
import '../../api/client/message/feed_feedback_api.dart';
import '../../model/message/feed_feedback.dart';

class FeedFeedbackService {
  static Future<FeedFeedback> uploadMediaFeedback({
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
    return await FeedFeedbackApi.uploadFeedFeedback(
      like: like,
      dislike: dislike,
      favorites: favorites,
      share: share,
      feedType: mediaType,
      feedId: mediaId,
    );
  }
}


import '../../api/client/message/feed_feedback_api.dart';
import '../../config/global.dart';
import '../../model/message/feed_feedback.dart';

class FeedFeedbackService {
  static Future<FeedFeedback?> uploadFeedFeedback({
    int like = 0,
    int favorites = 0,
    required int mediaType,
    required String mediaId,
  }) async {
    if (like == 0 &&  favorites == 0 ) {
      throw const FormatException("操作失败");
    }
    if(Global.user.id==null){
      return null;
    }
    return await FeedFeedbackApi.uploadFeedFeedback(
      like: like,
      favorites: favorites,
      feedType: mediaType,
      feedId: mediaId,
    );
  }
}

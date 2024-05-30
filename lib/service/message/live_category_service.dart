import 'package:post_client/api/client/message/live_category_api.dart';

import '../../model/message/live_category.dart';
import '../../model/message/live_topic.dart';

class LiveCategoryService {
  static Future<List<LiveCategory>> getCategoryListByTopic({
    required int topicId,
    int pageIndex = 0,
    int pageSize = 20,
  }) async {
    return await LiveCategoryApi.getLiveCategoryList(topicId: topicId, pageIndex: pageIndex, pageSize: pageSize);
  }

  static Future<(LiveCategory, LiveTopic)> getCategoryWithTopic({
    required int categoryId,
    int pageIndex = 0,
    int pageSize = 20,
  }) async {
    return await LiveCategoryApi.getCategoryWithTopic(categoryId: categoryId);
  }
}

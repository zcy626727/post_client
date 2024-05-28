import 'package:post_client/api/client/message/live_category_api.dart';

import '../../model/message/live_category.dart';

class LiveCategoryService {
  static Future<List<LiveCategory>> getCategoryListByTopic({
    required int topicId,
    int pageIndex = 0,
    int pageSize = 20,
  }) async {
    return await LiveCategoryApi.getLiveCategoryList(topicId: topicId, pageIndex: pageIndex, pageSize: pageSize);
  }
}

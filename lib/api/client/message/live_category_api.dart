import 'package:dio/dio.dart';

import '../../../model/message/live_category.dart';
import '../message_http_config.dart';

class LiveCategoryApi {
  static Future<LiveCategory> createLiveCategory({
    required int topicId,
    required String name,
    required String avatarUrl,
  }) async {
    var r = await MessageHttpConfig.dio.post(
      "/liveCategory/createLiveCategory",
      data: {"topicId": topicId, "name": name, "avatarUrl": avatarUrl},
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    return LiveCategory.fromJson(r.data['category']);
  }

  static Future<void> deleteLiveCategory() async {
    var r = await MessageHttpConfig.dio.delete(
      "/liveCategory/deleteLiveCategory",
      data: {},
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<LiveCategory> updateLiveCategory({
    required int topicId,
    required String name,
    required String avatarUrl,
  }) async {
    var r = await MessageHttpConfig.dio.put(
      "/liveCategory/updateLiveCategory",
      data: {"topicId": topicId, "name": name, "avatarUrl": avatarUrl},
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    return LiveCategory.fromJson(r.data['category']);
  }

  static Future<List<LiveCategory>> getLiveCategoryList({
    required int topicId,
    required int pageIndex,
    required int pageSize,
  }) async {
    var r = await MessageHttpConfig.dio.get(
      "/liveCategory/getLiveCategoryListByTopic",
      data: {
        "topicId": topicId,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    return _parseLiveCategoryList(r);
  }

  static List<LiveCategory> _parseLiveCategoryList(Response<dynamic> r) {
    List<LiveCategory> entityList = [];
    for (var json in r.data['categoryList']) {
      var entity = LiveCategory.fromJson(json);
      entityList.add(entity);
    }
    return entityList;
  }
}

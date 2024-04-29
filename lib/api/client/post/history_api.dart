import 'package:post_client/api/client/post_http_config.dart';
import 'package:post_client/model/post/history.dart';

class HistoryApi {
  static Future<History> createHistory(
    String mediaId,
    int mediaType,
    String? position,
  ) async {
    var r = await PostHttpConfig.dio.post(
      "/history/createHistory",
      data: {
        "mediaId": mediaId,
        "mediaType": mediaType,
        "position": position,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    //获取数据
    return History.fromJson(r.data['history']);
  }

  static Future<void> deleteUserHistoryById(
    String historyId,
  ) async {
    await PostHttpConfig.dio.post(
      "/history/deleteUserHistoryById",
      data: {
        "historyId": historyId,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<void> updateHistoryPosition(
    String historyId,
    String newPosition,
  ) async {
    await PostHttpConfig.dio.post(
      "/history/updateHistoryPosition",
      data: {
        "newPosition": newPosition,
        "historyId": historyId,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<History?> getHistoryByMedia(
    String mediaId,
    int mediaType,
    bool needCreate,
    bool needUpdateTime,
  ) async {
    var r = await PostHttpConfig.dio.get(
      "/history/getHistoryByMedia",
      queryParameters: {
        "mediaId": mediaId,
        "mediaType": mediaType,
        "needCreate": needCreate,
        "needUpdateTime": needUpdateTime,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    if (r.data['history'] == null) {
      return null;
    }
    return History.fromJson(r.data['history']);
  }

  static Future<List<History>> getUserHistoryList(
    int mediaType,
    int pageIndex,
    int pageSize,
  ) async {
    var r = await PostHttpConfig.dio.get(
      "/history/getUserHistoryList",
      queryParameters: {
        "mediaType": mediaType,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    List<History> historyList = [];
    if (r.data['historyList'] != null) {
      for (var historyJson in r.data['historyList']) {
        var history = History.fromJson(historyJson);
        historyList.add(history);
      }
    }
    return historyList;
  }
}

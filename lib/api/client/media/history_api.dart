import 'package:post_client/model/history.dart';

import '../message_http_config.dart';

class HistoryApi {
  static Future<History> createHistory(
    String mediaId,
    int mediaType,
    String position,
  ) async {
    var r = await MessageHttpConfig.dio.post(
      "/history/createHistory",
      data: {
        "mediaId": mediaId,
        "mediaType": mediaType,
        "position": position,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    //获取数据
    return History.fromJson(r.data['history']);
  }

  static Future<void> deleteHistoryById(
    String historyId,
  ) async {
    await MessageHttpConfig.dio.post(
      "/history/deleteHistoryById",
      data: {
        "historyId": historyId,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<void> updateHistoryPosition(
      String historyId,
      String newPosition,
  ) async {
    await MessageHttpConfig.dio.post(
      "/history/updateHistoryPosition",
      data: {
        "newPosition": newPosition,
        "historyId": historyId,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<History> getHistoryByMedia(
    String mediaId,
    String mediaType,
  ) async {
    var r = await MessageHttpConfig.dio.get(
      "/history/getHistoryByMedia",
      data: {
        "mediaType": mediaType,
        "commentId": mediaId,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    return History.fromJson(r.data['history']);
  }

  static Future<List<History>> getUserHistoryList(
      int mediaType,
      int pageIndex,
      int pageSize,
      ) async {
    var r = await MessageHttpConfig.dio.get(
      "/history/getUserHistoryList",
      data: {
        "mediaType": mediaType,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    List<History> historyList = [];
    for (var historyJson in r.data['historyList']) {
      var history = History.fromJson(historyJson);
      historyList.add(history);
    }
    return historyList;
  }
}

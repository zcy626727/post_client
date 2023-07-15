import 'package:post_client/api/client/media/history_api.dart';
import 'package:post_client/model/history.dart';

class HistoryService {
  static Future<History> createHistory(
    String mediaId,
    int mediaType,
    String position,
  ) async {
    var history = await HistoryApi.createHistory(mediaId, mediaType, position);
    return history;
  }

  static Future<void> deleteHistoryById(
    String historyId,
  ) async {
    await HistoryApi.deleteHistoryById(historyId);
  }

  static Future<void> updateHistoryPosition(
    String historyId,
    String newPosition,
  ) async {
    await HistoryApi.updateHistoryPosition(historyId, newPosition);
  }

  static Future<History> getHistoryByMedia(
    String mediaId,
    String mediaType,
  ) async {
    var history = await HistoryApi.getHistoryByMedia(mediaId, mediaType);
    return history;
  }

  static Future<List<History>> getUserHistoryList(
    int mediaType,
    int pageIndex,
    int pageSize,
  ) async {
    var historyList = await HistoryApi.getUserHistoryList(mediaType, pageIndex, pageSize);
    return historyList;
  }
}

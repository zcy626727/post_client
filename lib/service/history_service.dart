import 'package:post_client/api/client/media/history_api.dart';
import 'package:post_client/model/history.dart';

class HistoryService {
  static Future<History> createHistory(
    String sourceId,
    int sourceType,
    String position,
  ) async {
    var history = await HistoryApi.createHistory(sourceId, sourceType, position);
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

  static Future<History> getHistoryBySource(
    String sourceId,
    String sourceType,
  ) async {
    var history = await HistoryApi.getHistoryBySource(sourceId, sourceType);
    return history;
  }

  static Future<List<History>> getUserHistoryList(
    int sourceType,
    int pageIndex,
    int pageSize,
  ) async {
    var historyList = await HistoryApi.getUserHistoryList(sourceType, pageIndex, pageSize);
    return historyList;
  }
}

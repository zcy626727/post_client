import 'package:post_client/api/client/post/history_api.dart';
import 'package:post_client/model/post/history.dart';

import '../../api/client/post/source_api.dart';
import '../../constant/source.dart';

class HistoryService {
  static Future<History> createHistory(
    String sourceId,
    int sourceType,
    String position,
  ) async {
    var history = await HistoryApi.createHistory(sourceId, sourceType, position);
    return history;
  }

  static Future<void> deleteUserHistoryById(
    String historyId,
  ) async {
    await HistoryApi.deleteUserHistoryById(historyId);
  }

  static Future<void> updateHistoryPosition(
    String historyId,
    String newPosition,
  ) async {
    await HistoryApi.updateHistoryPosition(historyId, newPosition);
  }

  static Future<History> getOrCreateHistoryByMedia(
    String mediaId,
    int mediaType, {
    bool needCreate = true,
    bool needUpdateTime = true,
  }) async {
    var history = await HistoryApi.getHistoryByMedia(mediaId, mediaType, needCreate, needUpdateTime);
    return history ?? History();
  }

  static Future<List<History>> getUserHistoryList(
    int mediaType,
    int pageIndex,
    int pageSize,
  ) async {
    var historyList = await HistoryApi.getUserHistoryList(mediaType, pageIndex, pageSize);
    await fillMedia(historyList);
    return historyList;
  }

  static Future<void> fillMedia(List<History> historyList) async {
    List<String> articleIdList = <String>[];
    List<String> audioIdList = <String>[];
    List<String> galleryIdList = <String>[];
    List<String> videoIdList = <String>[];
    //获取媒体列表
    for (var history in historyList) {
      if (history.mediaId != null) {
        switch (history.mediaType) {
          case SourceType.article:
            articleIdList.add(history.mediaId!);
          case SourceType.video:
            videoIdList.add(history.mediaId!);
          case SourceType.audio:
            audioIdList.add(history.mediaId!);
          case SourceType.gallery:
            galleryIdList.add(history.mediaId!);
        }
      }
    }
    var (_, _, articleMap, audioMap, galleryMap, videoMap) = await SourceApi.getSourceMapByIdList(
      articleIdList: articleIdList,
      audioIdList: audioIdList,
      galleryIdList: galleryIdList,
      videoIdList: videoIdList,
    );

    //填充
    for (var history in historyList) {
      if (history.mediaId != null) {
        switch (history.mediaType) {
          case SourceType.article:
            history.media = articleMap[history.mediaId];
          case SourceType.video:
            history.media = videoMap[history.mediaId];
          case SourceType.audio:
            history.media = audioMap[history.mediaId];
          case SourceType.gallery:
            history.media = galleryMap[history.mediaId];
        }
      }
    }
  }
}

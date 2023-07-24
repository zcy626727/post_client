import 'package:post_client/api/client/media/history_api.dart';
import 'package:post_client/constant/media.dart';
import 'package:post_client/constant/source.dart';
import 'package:post_client/model/media/history.dart';

import '../../api/client/media/media_api.dart';

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
          case MediaType.article:
            articleIdList.add(history.mediaId!);
          case MediaType.video:
            videoIdList.add(history.mediaId!);
          case MediaType.audio:
            audioIdList.add(history.mediaId!);
          case MediaType.gallery:
            galleryIdList.add(history.mediaId!);
        }
      }
    }
    var (articleMap, audioMap, galleryMap, videoMap) = await MediaApi.getMediaMapByIdList(
      articleIdList: articleIdList,
      audioIdList: audioIdList,
      galleryIdList: galleryIdList,
      videoIdList: videoIdList,
    );

    //填充
    for (var history in historyList) {
      if (history.mediaId != null) {
        switch (history.mediaType) {
          case MediaType.article:
            history.media = articleMap[history.mediaId];
          case MediaType.video:
            history.media = videoMap[history.mediaId];
          case MediaType.audio:
            history.media = audioMap[history.mediaId];
          case MediaType.gallery:
            history.media = galleryMap[history.mediaId];
        }
      }
    }
  }
}

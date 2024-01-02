import 'package:dio/dio.dart';
import 'package:post_client/api/client/message_http_config.dart';
import 'package:post_client/model/favorites_source.dart';

import '../media_http_config.dart';

class FavoritesSourceApi {
  static Future<List<FavoritesSource>> getFavoritesSourceListBySourceId({
    required bool isMediaFavorites,
    required String sourceId,
  }) async {
    if (isMediaFavorites) {
      var r = await MediaHttpConfig.dio.get(
        "/favoritesSource/getFavoritesSourceListBySourceId",
        queryParameters: {
          "sourceId": sourceId,
        },
        options: MediaHttpConfig.options.copyWith(extra: {
          "noCache": false,
          "withToken": true,
        }),
      );
      return _parseFavoritesSourceList(r);
    } else {
      var r = await MessageHttpConfig.dio.get(
        "/favoritesSource/getFavoritesSourceListBySourceId",
        queryParameters: {
          "sourceId": sourceId,
        },
        options: MessageHttpConfig.options.copyWith(extra: {
          "noCache": false,
          "withToken": true,
        }),
      );
      return _parseFavoritesSourceList(r);
    }
  }

  static Future<List<FavoritesSource>> getFavoritesSourceListByFavoritesId({
    required bool isMediaFavorites,
    required int favoritesId,
    required int pageIndex,
    required int pageSize,
  }) async {
    if (isMediaFavorites) {
      var r = await MediaHttpConfig.dio.get(
        "/favoritesSource/getFavoritesSourceListByFavoritesId",
        queryParameters: {
          "favoritesId": favoritesId,
          "pageIndex": pageIndex,
          "pageSize": pageSize,
        },
        options: MediaHttpConfig.options.copyWith(extra: {
          "noCache": false,
          "withToken": true,
        }),
      );
      return _parseFavoritesSourceList(r);
    } else {
      var r = await MessageHttpConfig.dio.get(
        "/favoritesSource/getFavoritesSourceListByFavoritesId",
        queryParameters: {
          "favoritesId": favoritesId,
          "pageIndex": pageIndex,
          "pageSize": pageSize,
        },
        options: MessageHttpConfig.options.copyWith(extra: {
          "noCache": false,
          "withToken": true,
        }),
      );
      return _parseFavoritesSourceList(r);
    }
  }

  static List<FavoritesSource> _parseFavoritesSourceList(Response<dynamic> r) {
    List<FavoritesSource> albumList = [];
    for (var albumJson in r.data['favoritesSourceList']) {
      var album = FavoritesSource.fromJson(albumJson);
      albumList.add(album);
    }
    return albumList;
  }
}

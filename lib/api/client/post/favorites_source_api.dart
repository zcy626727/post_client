import 'package:dio/dio.dart';

import '../../../model/post/favorites_source.dart';
import '../post_http_config.dart';

class FavoritesSourceApi {
  static Future<List<FavoritesSource>> getFavoritesSourceListBySourceId({
    required bool isMediaFavorites,
    required String sourceId,
  }) async {
    if (isMediaFavorites) {
      var r = await PostHttpConfig.dio.get(
        "/favoritesSource/getFavoritesSourceListBySourceId",
        queryParameters: {
          "sourceId": sourceId,
        },
        options: PostHttpConfig.options.copyWith(extra: {
          "noCache": false,
          "withToken": true,
        }),
      );
      return _parseFavoritesSourceList(r);
    } else {
      var r = await PostHttpConfig.dio.get(
        "/favoritesSource/getFavoritesSourceListBySourceId",
        queryParameters: {
          "sourceId": sourceId,
        },
        options: PostHttpConfig.options.copyWith(extra: {
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
      var r = await PostHttpConfig.dio.get(
        "/favoritesSource/getFavoritesSourceListByFavoritesId",
        queryParameters: {
          "favoritesId": favoritesId,
          "pageIndex": pageIndex,
          "pageSize": pageSize,
        },
        options: PostHttpConfig.options.copyWith(extra: {
          "noCache": false,
          "withToken": true,
        }),
      );
      return _parseFavoritesSourceList(r);
    } else {
      var r = await PostHttpConfig.dio.get(
        "/favoritesSource/getFavoritesSourceListByFavoritesId",
        queryParameters: {
          "favoritesId": favoritesId,
          "pageIndex": pageIndex,
          "pageSize": pageSize,
        },
        options: PostHttpConfig.options.copyWith(extra: {
          "noCache": false,
          "withToken": true,
        }),
      );
      return _parseFavoritesSourceList(r);
    }
  }

  static List<FavoritesSource> _parseFavoritesSourceList(Response<dynamic> r) {
    List<FavoritesSource> albumList = [];
    if (r.data['favoritesSourceList'] != null) {
      for (var albumJson in r.data['favoritesSourceList']) {
        var album = FavoritesSource.fromJson(albumJson);
        albumList.add(album);
      }
    }

    return albumList;
  }
}

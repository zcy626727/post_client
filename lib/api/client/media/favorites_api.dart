import 'package:post_client/model/favorites.dart';

import '../media_http_config.dart';
import '../message_http_config.dart';

class FavoritesApi {
  static Future<Favorites> createFavorites(
    List<String> sourceIdList,
    int sourceType,
    String position,
  ) async {
    var r = await MediaHttpConfig.dio.post(
      "/favorites/createFavorites",
      data: {
        "sourceIdList": sourceIdList,
        "sourceType": sourceType,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    //获取数据
    return Favorites.fromJson(r.data['favorites']);
  }

  static Future<void> deleteUserFavoritesById(
    String favoritesId,
  ) async {
    await MediaHttpConfig.dio.post(
      "/favorites/deleteUserFavoritesById",
      data: {
        "favoritesId": favoritesId,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<void> addSourceToFavorites(
    String favoritesId,
    String sourceId,
    int sourceType,
  ) async {
    await MediaHttpConfig.dio.post(
      "/favorites/addSourceToFavorites",
      data: {
        "favoritesId": favoritesId,
        "sourceId": sourceId,
        "sourceType": sourceType,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<List<Favorites>> getUserFavoritesList(
      int sourceType,
      int pageIndex,
      int pageSize,
      ) async {
    var r = await MediaHttpConfig.dio.get(
      "/favorites/getUserFavoritesList",
      queryParameters: {
        "sourceType": sourceType,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": false,
      }),
    );

    List<Favorites> favoritesList = [];
    for (var favoritesJson in r.data['favoritesList']) {
      var favorites = Favorites.fromJson(favoritesJson);
      favoritesList.add(favorites);
    }
    return favoritesList;
  }
}

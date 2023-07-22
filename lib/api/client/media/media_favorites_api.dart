import '../../../model/favorites.dart';
import '../media_http_config.dart';

class MediaFavoritesApi {
  static Future<Favorites> createFavorites(
    String title,
    String introduction,
    String? coverUrl,
    int sourceType,
  ) async {
    var r = await MediaHttpConfig.dio.post(
      "/mediaFavorites/createFavorites",
      data: {
        "title": title,
        "introduction": introduction,
        "coverUrl": coverUrl,
        "sourceType": sourceType,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    //获取数据
    return Favorites.fromJson(r.data['favorites']);
  }

  static Future<void> deleteUserMediaFavoritesById(
    String favoritesId,
  ) async {
    await MediaHttpConfig.dio.post(
      "/mediaFavorites/deleteUserMediaFavoritesById",
      data: {
        "favoritesId": favoritesId,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<void> updateMediaInFavoritesList({
    required List<String> addFavoritesIdList,
    required List<String> removeFavoritesIdList,
    required String sourceId,
    required int sourceType,
  }) async {
    await MediaHttpConfig.dio.post(
      "/mediaFavorites/updateMediaInFavoritesList",
      data: {
        "addFavoritesIdList": addFavoritesIdList,
        "removeFavoritesIdList": removeFavoritesIdList,
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
      "/mediaFavorites/getUserFavoritesList",
      queryParameters: {
        "sourceType": sourceType,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": true,
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

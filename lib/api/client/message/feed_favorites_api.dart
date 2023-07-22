import '../../../model/favorites.dart';
import '../message_http_config.dart';

class FeedFavoritesApi {
  static Future<Favorites> createFavorites(
    String title,
    String introduction,
    String? coverUrl,
    int sourceType,
  ) async {
    var r = await MessageHttpConfig.dio.post(
      "/feedFavorites/createFavorites",
      data: {
        "title": title,
        "introduction": introduction,
        "coverUrl": coverUrl,
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
    await MessageHttpConfig.dio.post(
      "/feedFavorites/deleteUserFavoritesById",
      data: {
        "favoritesId": favoritesId,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<void> updateFeedInFavoritesList({
    required List<String> addFavoritesIdList,
    required List<String> removeFavoritesIdList,
    required String sourceId,
    required int sourceType,
  }) async {
    await MessageHttpConfig.dio.post(
      "/feedFavorites/updateFeedInFavoritesList",
      data: {
        "addFavoritesIdList": addFavoritesIdList,
        "removeFavoritesIdList": removeFavoritesIdList,
        "sourceId": sourceId,
        "sourceType": sourceType,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
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
    var r = await MessageHttpConfig.dio.get(
      "/feedFavorites/getUserFavoritesList",
      queryParameters: {
        "sourceType": sourceType,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": true,
      }),
    );

    List<Favorites> favoritesList = [];
    if(r.data['favoritesList']!=null){
      for (var favoritesJson in r.data['favoritesList']) {
        var favorites = Favorites.fromJson(favoritesJson);
        favoritesList.add(favorites);
      }
    }
    return favoritesList;
  }
}

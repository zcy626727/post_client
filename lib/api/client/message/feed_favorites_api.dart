import '../../../model/message/feed_favorites.dart';
import '../message_http_config.dart';

class FeedFavoritesApi {
  static Future<FeedFavorites> createFeedFavorites(
    String title,
    String introduction,
    String? coverUrl,
    int feedType,
  ) async {
    var r = await MessageHttpConfig.dio.post(
      "/feedFavorites/createFeedFavorites",
      data: {
        "title": title,
        "introduction": introduction,
        "coverUrl": coverUrl,
        "feedType": feedType,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    //获取数据
    return FeedFavorites.fromJson(r.data['feedFavorites']);
  }

  static Future<void> deleteUserFeedFavoritesById(
    String favoritesId,
  ) async {
    await MessageHttpConfig.dio.post(
      "/feedFavorites/deleteUserFeedFavoritesById",
      data: {
        "favoritesId": favoritesId,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<void> addFeedToFavorites(
    String favoritesId,
    String feedId,
    int feedType,
  ) async {
    await MessageHttpConfig.dio.post(
      "/feedFavorites/addFeedToFavorites",
      data: {
        "favoritesId": favoritesId,
        "feedId": feedId,
        "feedType": feedType,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<List<FeedFavorites>> getUserFeedFavoritesList(
    int feedType,
    int pageIndex,
    int pageSize,
  ) async {
    var r = await MessageHttpConfig.dio.get(
      "/feedFavorites/getUserFeedFavoritesList",
      queryParameters: {
        "feedType": feedType,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": true,
      }),
    );

    List<FeedFavorites> favoritesList = [];
    for (var favoritesJson in r.data['feedFavoritesList']) {
      var favorites = FeedFavorites.fromJson(favoritesJson);
      favoritesList.add(favorites);
    }
    return favoritesList;
  }
}

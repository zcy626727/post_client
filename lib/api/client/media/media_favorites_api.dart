
import '../../../model/media/media_favorites.dart';
import '../media_http_config.dart';
import '../message_http_config.dart';

class MediaFavoritesApi {
  static Future<MediaFavorites> createMediaFavorites(
    String title,
    String introduction,
    String? coverUrl,
    int mediaType,
  ) async {
    var r = await MediaHttpConfig.dio.post(
      "/mediaFavorites/createMediaFavorites",
      data: {
        "title": title,
        "introduction": introduction,
        "coverUrl": coverUrl,
        "mediaType": mediaType,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    //获取数据
    return MediaFavorites.fromJson(r.data['mediaFavorites']);
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

  static Future<void> addMediaToFavorites(
    String favoritesId,
    String mediaId,
    int mediaType,
  ) async {
    await MediaHttpConfig.dio.post(
      "/mediaFavorites/addMediaToFavorites",
      data: {
        "favoritesId": favoritesId,
        "mediaId": mediaId,
        "mediaType": mediaType,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<List<MediaFavorites>> getUserMediaFavoritesList(
    int mediaType,
    int pageIndex,
    int pageSize,
  ) async {
    var r = await MediaHttpConfig.dio.get(
      "/mediaFavorites/getUserMediaFavoritesList",
      queryParameters: {
        "mediaType": mediaType,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": true,
      }),
    );

    List<MediaFavorites> favoritesList = [];
    for (var favoritesJson in r.data['mediaFavoritesList']) {
      var favorites = MediaFavorites.fromJson(favoritesJson);
      favoritesList.add(favorites);
    }
    return favoritesList;
  }
}

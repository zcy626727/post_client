import 'package:dio/dio.dart';

import '../../../model/favorites.dart';
import '../../../model/media/article.dart';
import '../../../model/media/audio.dart';
import '../../../model/media/gallery.dart';
import '../../../model/media/video.dart';
import '../../../model/user/user.dart';
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

  static Future<void> updateFavoritesData(
    String favoritesId,
    String? title,
    String? introduction,
    String? coverUrl,
  ) async {
    if (title == null && introduction == null && coverUrl == null) {
      return;
    }
    var r = await MediaHttpConfig.dio.post(
      "/mediaFavorites/updateFavoritesData",
      data: {
        "favoritesId": favoritesId,
        "title": title,
        "introduction": introduction,
        "coverUrl": coverUrl,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<void> deleteUserFavoritesById(
    String favoritesId,
  ) async {
    await MediaHttpConfig.dio.post(
      "/mediaFavorites/deleteUserFavoritesById",
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

  static Future<(List<Article>, List<Audio>, List<Gallery>, List<Video>)> getSourceListByFavoritesId({
    required String favoritesId,
    bool withUser = true,
    required int pageIndex,
    required int pageSize,
  }) async {
    var r = await MediaHttpConfig.dio.get(
      "/mediaFavorites/getSourceListByFavoritesId",
      queryParameters: {
        "sourceType": favoritesId,
        "withUser": withUser,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": true,
      }),
    );
    return _parseMediaListWithUser(r);
  }

  static (List<Article>, List<Audio>, List<Gallery>, List<Video>) _parseMediaListWithUser(Response<dynamic> r) {
    Map<int, User> userMap = {};
    if (r.data['userList'] != null) {
      for (var userJson in r.data['userList']) {
        var user = User.fromJson(userJson);
        userMap[user.id!] = user;
      }
    }

    List<Article> articleList = [];
    if (r.data['articleList'] != null) {
      for (var articleJson in r.data['articleList']) {
        var article = Article.fromJson(articleJson);
        article.user = userMap[article.userId];
        articleList.add(article);
      }
    }

    List<Audio> audioList = [];
    if (r.data['audioList'] != null) {
      for (var audioJson in r.data['audioList']) {
        var audio = Audio.fromJson(audioJson);
        audio.user = userMap[audio.userId];
        audioList.add(audio);
      }
    }

    List<Gallery> galleryList = [];
    if (r.data['galleryList'] != null) {
      for (var galleryJson in r.data['galleryList']) {
        var gallery = Gallery.fromJson(galleryJson);
        gallery.user = userMap[gallery.userId];
        galleryList.add(gallery);
      }
    }

    List<Video> videoList = [];
    if (r.data['videoList'] != null) {
      for (var videoJson in r.data['videoList']) {
        var video = Video.fromJson(videoJson);
        video.user = userMap[video.userId];
        videoList.add(video);
      }
    }
    return (articleList, audioList, galleryList, videoList);
  }
}

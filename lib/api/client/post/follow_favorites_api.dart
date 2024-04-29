import 'package:dio/dio.dart';

import '../../../model/post/follow_favorites.dart';
import '../../../model/user/user.dart';
import '../post_http_config.dart';

class FollowFavoritesApi {
  static Future<FollowFavorites> followFavorites({
    required bool isMediaFavorites,
    required String favoritesId,
    required int sourceType,
  }) async {
    if (isMediaFavorites) {
      var r = await PostHttpConfig.dio.post(
        "/followFavorites/followFavorites",
        data: {
          "favoritesId": favoritesId,
          "sourceType": sourceType,
        },
        options: PostHttpConfig.options.copyWith(extra: {
          "noCache": true,
          "withToken": true,
        }),
      );

      return FollowFavorites.fromJson(r.data['followFavorites']);
    } else {
      var r = await PostHttpConfig.dio.post(
        "/followFavorites/followFavorites",
        data: {
          "favoritesId": favoritesId,
          "sourceType": sourceType,
        },
        options: PostHttpConfig.options.copyWith(extra: {
          "noCache": true,
          "withToken": true,
        }),
      );

      return FollowFavorites.fromJson(r.data['followFavorites']);
    }
  }

  static Future<void> unfollowFavorites({
    required bool isMediaFavorites,
    required String followFavoritesId,
  }) async {
    if (isMediaFavorites) {
      var r = await PostHttpConfig.dio.post(
        "/followFavorites/unfollowFavorites",
        data: {
          "followFavoritesId": followFavoritesId,
        },
        options: PostHttpConfig.options.copyWith(extra: {
          "noCache": true,
          "withToken": true,
        }),
      );
    } else {
      var r = await PostHttpConfig.dio.post(
        "/followFavorites/unfollowFavorites",
        data: {
          "followFavoritesId": followFavoritesId,
        },
        options: PostHttpConfig.options.copyWith(extra: {
          "noCache": true,
          "withToken": true,
        }),
      );
    }
  }

  static Future<FollowFavorites> getFollowFavorites({
    required bool isMediaFavorites,
    required String favoritesId,
  }) async {
    if (isMediaFavorites) {
      var r = await PostHttpConfig.dio.get(
        "/followFavorites/getFollowFavorites",
        queryParameters: {
          "favoritesId": favoritesId,
        },
        options: PostHttpConfig.options.copyWith(extra: {
          "noCache": true,
          "withToken": true,
        }),
      );
      return FollowFavorites.fromJson(r.data['followFavorites']);
    } else {
      var r = await PostHttpConfig.dio.get(
        "/followFavorites/getFollowFavorites",
        queryParameters: {
          "favoritesId": favoritesId,
        },
        options: PostHttpConfig.options.copyWith(extra: {
          "noCache": true,
          "withToken": true,
        }),
      );
      return FollowFavorites.fromJson(r.data['followFavorites']);
    }
  }

  static Future<List<FollowFavorites>> getUserFollowFavoritesList({
    required bool isMediaFavorites,
    int pageIndex = 0,
    int pageSize = 20,
    int? sourceType,
    required bool withUser,
  }) async {
    if (isMediaFavorites) {
      var r = await PostHttpConfig.dio.get(
        "/followFavorites/getUserFollowFavoritesList",
        queryParameters: {
          "pageIndex": pageIndex,
          "pageSize": pageSize,
          "withUser": withUser,
          "sourceType": sourceType,
        },
        options: PostHttpConfig.options.copyWith(extra: {
          "noCache": true,
          "withToken": true,
        }),
      );
      return _parseFollowFavoritesListWithUser(r);
    } else {
      var r = await PostHttpConfig.dio.get(
        "/followFavorites/getUserFollowFavoritesList",
        queryParameters: {
          "pageIndex": pageIndex,
          "pageSize": pageSize,
          "withUser": withUser,
          "sourceType": sourceType,
        },
        options: PostHttpConfig.options.copyWith(extra: {
          "noCache": true,
          "withToken": true,
        }),
      );
      return _parseFollowFavoritesListWithUser(r);
    }
  }

  static List<FollowFavorites> _parseFollowFavoritesListWithUser(Response<dynamic> r) {
    Map<int, User> userMap = {};
    if (r.data['userList'] != null) {
      for (var userJson in r.data['userList']) {
        var user = User.fromJson(userJson);
        userMap[user.id ?? 0] = user;
      }
    }
    List<FollowFavorites> favoritesList = [];
    if (r.data['followFavoritesList'] != null) {
      for (var followFavoritesJson in r.data['followFavoritesList']) {
        var followFavorites = FollowFavorites.fromJson(followFavoritesJson);

        followFavorites.user = userMap[followFavorites.userId];
        //专辑没有被删除
        if (followFavorites.favorites != null) {
          followFavorites.favorites!.user = userMap[followFavorites.userId];
        }
        favoritesList.add(followFavorites);
      }
    }
    return favoritesList;
  }

  static List<FollowFavorites> _parseFollowFavoritesList(Response<dynamic> r) {
    List<FollowFavorites> favoritesList = [];
    for (var favoritesJson in r.data['followFavoritesList']) {
      var favorites = FollowFavorites.fromJson(favoritesJson);
      favoritesList.add(favorites);
    }
    return favoritesList;
  }
}

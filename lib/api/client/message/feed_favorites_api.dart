import 'package:dio/dio.dart';

import '../../../model/favorites.dart';
import '../../../model/message/comment.dart';
import '../../../model/message/post.dart';
import '../../../model/user/user.dart';
import '../media_http_config.dart';
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

  static Future<void> updateFavoritesData(String favoritesId,
      String? title,
      String? introduction,
      String? coverUrl,) async {
    if (title == null && introduction == null && coverUrl == null) {
      return;
    }
    var r = await MessageHttpConfig.dio.post(
      "/feedFavorites/updateFavoritesData",
      data: {
        "favoritesId": favoritesId,
        "title": title,
        "introduction": introduction,
        "coverUrl": coverUrl,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<void> deleteUserFavoritesById(String favoritesId,) async {
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

  static Future<List<Favorites>> getUserFavoritesList(int sourceType,
      int pageIndex,
      int pageSize,) async {
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
    if (r.data['favoritesList'] != null) {
      for (var favoritesJson in r.data['favoritesList']) {
        var favorites = Favorites.fromJson(favoritesJson);
        favoritesList.add(favorites);
      }
    }
    return favoritesList;
  }

  static Future<(List<Post>, List<Comment>)> getSourceListByFavoritesId({
    required String favoritesId,
    required int pageIndex,
    required int pageSize,
  }) async {
    var r = await MediaHttpConfig.dio.get(
      "/mediaFavorites/getSourceListByFavoritesId",
      queryParameters: {
        "sourceType": favoritesId,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": true,
      }),
    );
    return _parseFeedList(r);
  }

  static (List<Post>, List<Comment>) _parseFeedList(Response<dynamic> r) {
    Map<int, User> userMap = {};
    if (r.data['userList'] != null) {
      for (var userJson in r.data['userList']) {
        var user = User.fromJson(userJson);
        userMap[user.id!] = user;
      }
    }

    List<Post> postList = [];
    if (r.data['postList'] != null) {
      for (var postJson in r.data['postList']) {
        var post = Post.fromJson(postJson);
        post.user = userMap[post.userId];
        postList.add(post);
      }
    }

    List<Comment> commentList = [];
    if (r.data['commentList'] != null) {
      for (var audioJson in r.data['commentList']) {
        var comment = Comment.fromJson(audioJson);
        comment.user = userMap[comment.userId];
        commentList.add(comment);
      }
    }
    return (postList, commentList);
  }
}

import 'package:dio/dio.dart';

import '../../../model/post/article.dart';
import '../../../model/post/audio.dart';
import '../../../model/post/comment.dart';
import '../../../model/post/favorites.dart';
import '../../../model/post/gallery.dart';
import '../../../model/post/post.dart';
import '../../../model/post/video.dart';
import '../../../model/user/user.dart';
import '../post_http_config.dart';

class FavoritesApi {
  static Future<Favorites> createFavorites(
    String title,
    String introduction,
    String? coverUrl,
    int sourceType,
  ) async {
    var r = await PostHttpConfig.dio.post(
      "/favorites/createFavorites",
      data: {
        "title": title,
        "introduction": introduction,
        "coverUrl": coverUrl,
        "sourceType": sourceType,
      },
      options: PostHttpConfig.options.copyWith(extra: {
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
    var r = await PostHttpConfig.dio.post(
      "/favorites/updateFavoritesData",
      data: {
        "favoritesId": favoritesId,
        "title": title,
        "introduction": introduction,
        "coverUrl": coverUrl,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<void> deleteUserFavoritesById(
    String favoritesId,
  ) async {
    await PostHttpConfig.dio.post(
      "/favorites/deleteUserFavoritesById",
      data: {
        "favoritesId": favoritesId,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<void> updateSourceInFavoritesList({
    required List<String> addFavoritesIdList,
    required List<String> removeFavoritesIdList,
    required String sourceId,
    required int sourceType,
  }) async {
    await PostHttpConfig.dio.post(
      "/favorites/updateSourceInFavoritesList",
      data: {
        "addFavoritesIdList": addFavoritesIdList,
        "removeFavoritesIdList": removeFavoritesIdList,
        "sourceId": sourceId,
        "sourceType": sourceType,
      },
      options: PostHttpConfig.options.copyWith(extra: {
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
    var r = await PostHttpConfig.dio.get(
      "/favorites/getUserFavoritesList",
      queryParameters: {
        "sourceType": sourceType,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: PostHttpConfig.options.copyWith(extra: {
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

  static Future<(List<Post>, List<Comment>, List<Article>, List<Audio>, List<Gallery>, List<Video>)> getSourceListByFavoritesId({
    required String favoritesId,
    bool withUser = true,
    required int pageIndex,
    required int pageSize,
  }) async {
    var r = await PostHttpConfig.dio.get(
      "/favorites/getSourceListByFavoritesId",
      queryParameters: {
        "favoritesId": favoritesId,
        "withUser": withUser,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": true,
      }),
    );
    return _parseSourceListWithUser(r);
  }

  static (List<Post>, List<Comment>, List<Article>, List<Audio>, List<Gallery>, List<Video>) _parseSourceListWithUser(Response<dynamic> r) {
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
    return (postList, commentList, articleList, audioList, galleryList, videoList);
  }
}

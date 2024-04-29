import 'package:dio/dio.dart';
import 'package:post_client/model/post/article.dart';
import 'package:post_client/model/user/user.dart';

import '../post_http_config.dart';

class ArticleApi {
  static Future<Article> createArticle({
    required String title,
    required String introduction,
    required String content,
    String? coverUrl,
    required bool withPost,
    String? albumId,
  }) async {
    var r = await PostHttpConfig.dio.post(
      "/article/createArticle",
      data: {
        "title": title,
        "introduction": introduction,
        "content": content,
        "coverUrl": coverUrl,
        "withPost": withPost,
        "albumId": albumId,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    return Article.fromJson(r.data['article']);
  }

  static Future<void> updateArticleData({
    required String articleId,
    String? title,
    String? introduction,
    String? content,
    String? coverUrl,
    String? albumId,
  }) async {
    var r = await PostHttpConfig.dio.post(
      "/article/updateArticleData",
      data: {
        "articleId": articleId,
        "title": title,
        "introduction": introduction,
        "content": content,
        "coverUrl": coverUrl,
        "albumId": albumId,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<void> deleteUserArticleById(
    String articleId,
  ) async {
    await PostHttpConfig.dio.post(
      "/article/deleteUserArticleById",
      data: {
        "articleId": articleId,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<Article> getArticleById(
    String articleId,
  ) async {
    var r = await PostHttpConfig.dio.get(
      "/article/getArticleById",
      queryParameters: {
        "articleId": articleId,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": false,
      }),
    );
    return Article.fromJson(r.data['article']);
  }

  static Future<List<Article>> getArticleListByUserId(
    int userId,
    int pageIndex,
    int pageSize,
  ) async {
    var r = await PostHttpConfig.dio.get(
      "/article/getArticleListByUserId",
      queryParameters: {
        "targetUserId": userId,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": false,
      }),
    );

    return _parseArticleList(r);
  }

  static Future<(List<Article>, User?)> getArticleListByAlbumId({
    required int albumUserId,
    required String albumId,
    required int pageIndex,
    required int pageSize,
  }) async {
    var r = await PostHttpConfig.dio.get(
      "/article/getArticleListByAlbumId",
      queryParameters: {
        "albumUserId": albumUserId,
        "albumId": albumId,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": false,
      }),
    );

    User? user;
    if (r.data['user'] != null) {
      user = User.fromJson(r.data['user']);
    }

    var articleList = _parseArticleList(r);

    return (articleList, user);
  }

  static Future<List<Article>> getArticleListRandom(
    int pageSize,
  ) async {
    var r = await PostHttpConfig.dio.get(
      "/article/getArticleListRandom",
      queryParameters: {
        "pageSize": pageSize,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": false,
      }),
    );
    return _parseArticleWithUser(r);
  }

  static Future<List<Article>> searchArticle(
    String title,
    int page,
    int pageSize,
  ) async {
    var r = await PostHttpConfig.dio.get(
      "/article/searchArticle",
      queryParameters: {
        "title": title,
        "page": page,
        "pageSize": pageSize,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": false,
      }),
    );

    return _parseArticleWithUser(r);
  }

  static List<Article> _parseArticleWithUser(Response<dynamic> r) {
    Map<int, User> userMap = {};
    if (r.data['userList'] != null) {
      for (var userJson in r.data['userList']) {
        var user = User.fromJson(userJson);
        userMap[user.id ?? 0] = user;
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

    return articleList;
  }

  static List<Article> _parseArticleList(Response<dynamic> r) {
    List<Article> articleList = [];
    if (r.data['articleList'] != null) {
      for (var articleJson in r.data['articleList']) {
        var article = Article.fromJson(articleJson);
        articleList.add(article);
      }
    }

    return articleList;
  }
}

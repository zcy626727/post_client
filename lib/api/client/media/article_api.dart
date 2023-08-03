import 'package:dio/dio.dart';
import 'package:post_client/model/media/article.dart';
import 'package:post_client/model/user/user.dart';

import '../media_http_config.dart';

class ArticleApi {
  static Future<Article> createArticle(
    String title,
    String introduction,
    String content,
    String? coverUrl,
    bool withPost,
  ) async {
    var r = await MediaHttpConfig.dio.post(
      "/article/createArticle",
      data: {
        "title": title,
        "introduction": introduction,
        "content": content,
        "coverUrl": coverUrl,
        "withPost": withPost,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    return Article.fromJson(r.data['article']);
  }

  static Future<void> updateArticleData(
    String mediaId,
    String? title,
    String? introduction,
    String? content,
    String? coverUrl,
  ) async {
    if (title == null && introduction == null && content == null && coverUrl == null) {
      return;
    }
    var r = await MediaHttpConfig.dio.post(
      "/article/updateArticleData",
      data: {
        "mediaId": mediaId,
        "title": title,
        "introduction": introduction,
        "content": content,
        "coverUrl": coverUrl,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<void> deleteUserArticleById(
    String articleId,
  ) async {
    await MediaHttpConfig.dio.post(
      "/article/deleteUserArticleById",
      data: {
        "articleId": articleId,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<Article> getArticleById(
    String articleId,
  ) async {
    var r = await MediaHttpConfig.dio.get(
      "/article/getArticleById",
      queryParameters: {
        "articleId": articleId,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
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
    var r = await MediaHttpConfig.dio.get(
      "/article/getArticleListByUserId",
      queryParameters: {
        "targetUserId": userId,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": false,
      }),
    );
    List<Article> articleList = [];
    for (var articleJson in r.data['articleList']) {
      var article = Article.fromJson(articleJson);
      articleList.add(article);
    }
    return articleList;
  }

  static Future<List<Article>> getArticleListRandom(
    int pageSize,
  ) async {
    var r = await MediaHttpConfig.dio.get(
      "/article/getArticleListRandom",
      queryParameters: {
        "pageSize": pageSize,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
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
    var r = await MediaHttpConfig.dio.get(
      "/article/searchArticle",
      queryParameters: {
        "title": title,
        "page": page,
        "pageSize": pageSize,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": false,
      }),
    );

    return _parseArticleWithUser(r);
  }

  static List<Article> _parseArticleWithUser(Response<dynamic> r) {
    Map<int, User> userMap = {};
    for (var userJson in r.data['userList']) {
      var user = User.fromJson(userJson);
      userMap[user.id ?? 0] = user;
    }
    List<Article> articleList = [];
    for (var articleJson in r.data['articleList']) {
      var article = Article.fromJson(articleJson);
      article.user = userMap[article.userId];
      articleList.add(article);
    }
    return articleList;
  }
}

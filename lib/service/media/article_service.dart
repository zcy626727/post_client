import 'package:post_client/model/media/article.dart';

import '../../api/client/media/article_api.dart';
import '../../model/user/user.dart';

class ArticleService {
  static Future<Article> createArticle({
    required String title,
    required String introduction,
    required String content,
    String? coverUrl,
    required bool withPost,
    String? albumId,
  }) async {
    var article = await ArticleApi.createArticle(
      title: title,
      introduction: introduction,
      content: content,
      coverUrl: coverUrl,
      withPost: withPost,
      albumId: albumId,
    );
    return article;
  }

  static Future<void> updateArticleData({
    required String mediaId,
    String? title,
    String? introduction,
    String? content,
    String? coverUrl,
    String? albumId,
  }) async {
    await ArticleApi.updateArticleData(
      mediaId: mediaId,
      title: title,
      introduction: introduction,
      content: content,
      coverUrl: coverUrl,
      albumId: albumId,
    );
  }

  static Future<void> deleteArticle(
    String? articleId,
  ) async {
    if (articleId == null) return;
    await ArticleApi.deleteUserArticleById(articleId);
  }

  static Future<Article> getArticleById(
    String articleId,
  ) async {
    var article = await ArticleApi.getArticleById(articleId);
    return article;
  }

  static Future<List<Article>> getArticleListByUserId(
    User user,
    int pageIndex,
    int pageSize,
  ) async {
    var articleList = await ArticleApi.getArticleListByUserId(user.id!, pageIndex, pageSize);
    for (var article in articleList) {
      article.user = user;
    }
    return articleList;
  }

  static Future<List<Article>> getArticleListByAlbumId({
    required int albumUserId,
    required String albumId,
    int pageIndex = 0,
    required int pageSize,
  }) async {
    var (articleList, user) = await ArticleApi.getArticleListByAlbumId(
      albumUserId: albumUserId,
      albumId: albumId,
      pageIndex: pageIndex,
      pageSize: pageSize,
    );
    for (var article in articleList) {
      article.user = user;
    }
    return articleList;
  }

  static Future<List<Article>> getArticleListRandom(
    int pageSize,
  ) async {
    var articleList = await ArticleApi.getArticleListRandom(pageSize);
    return articleList;
  }

  static Future<List<Article>> searchArticle(
    String title,
    int page,
    int pageSize,
  ) async {
    var articleList = await ArticleApi.searchArticle(title, page, pageSize);
    return articleList;
  }
}

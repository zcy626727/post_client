import 'package:post_client/model/media/article.dart';

import '../../api/client/media/article_api.dart';
import '../../model/user/user.dart';

class ArticleService {
  static Future<Article> createArticle(
    String title,
    String introduction,
    String content,
    String? coverUrl,
    bool withPost,
  ) async {
    var article = await ArticleApi.createArticle(title, introduction, content, coverUrl, withPost);
    return article;
  }

  static Future<void> updateArticleData(
    String mediaId,
    String? title,
    String? introduction,
    String? content,
    String? coverUrl,
  ) async {
    await ArticleApi.updateArticleData(mediaId, title, introduction, content, coverUrl);
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

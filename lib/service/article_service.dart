import '../api/client/media/article_api.dart';
import '../model/article.dart';
import '../model/user.dart';

class ArticleService {
  static Future<Article> createArticle(
      String title,
      String introduction,
      String content,
  ) async {
    var article = await ArticleApi.createArticle(title, introduction, content);
    return article;
  }

  static Future<void> deleteArticle(
    String articleId,
  ) async {
    await ArticleApi.deleteUserArticleById(articleId);
  }

  static Future<Article> getArticleById(
    String articleId,
  ) async {
    var article = await ArticleApi.getArticleById(articleId);
    return article;
  }

  static Future<List<Article>> getArticleListByUserId(
    int userId,
    int pageIndex,
    int pageSize,
    User user,
  ) async {
    var articleList = await ArticleApi.getArticleListByUserId(userId, pageIndex, pageSize);
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
}

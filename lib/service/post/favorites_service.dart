import 'package:post_client/constant/source.dart';
import 'package:post_client/model/post/comment.dart';
import 'package:post_client/model/post/post.dart';

import '../../api/client/post/favorites_api.dart';
import '../../model/post/article.dart';
import '../../model/post/audio.dart';
import '../../model/post/favorites.dart';
import '../../model/post/gallery.dart';
import '../../model/post/video.dart';
import 'comment_service.dart';
import 'post_service.dart';

class FavoritesService {
  static Future<Favorites> createFavorites(
    String title,
    String introduction,
    String? coverUrl,
    int sourceType,
  ) async {
    switch (sourceType) {
      case SourceType.post:
      case SourceType.comment:
        return await FavoritesApi.createFavorites(title, introduction, coverUrl, sourceType);
      default:
        return await FavoritesApi.createFavorites(title, introduction, coverUrl, sourceType);
    }
  }

  static Future<void> updateFavoritesData(
    String favoritesId,
    int sourceType,
    String? title,
    String? introduction,
    String? coverUrl,
  ) async {
    switch (sourceType) {
      case SourceType.post:
      case SourceType.comment:
      await FavoritesApi.updateFavoritesData(favoritesId, title, introduction, coverUrl);
      case SourceType.video:
      case SourceType.gallery:
      case SourceType.audio:
      case SourceType.article:
      await FavoritesApi.updateFavoritesData(favoritesId, title, introduction, coverUrl);
    }
  }

  static Future<void> deleteUserFavoritesById(
    String favoritesId,
    int sourceType,
  ) async {
    switch (sourceType) {
      case SourceType.post:
      case SourceType.comment:
      return await FavoritesApi.deleteUserFavoritesById(favoritesId);
      default:
        return await FavoritesApi.deleteUserFavoritesById(favoritesId);
    }
  }

  static Future<void> updateMediaInFavorites({
    required List<String> addFavoritesIdList,
    required List<String> removeFavoritesIdList,
    required String sourceId,
    required int sourceType,
  }) async {
    switch (sourceType) {
      case SourceType.post:
      case SourceType.comment:
      await FavoritesApi.updateSourceInFavoritesList(
          addFavoritesIdList: addFavoritesIdList,
          removeFavoritesIdList: removeFavoritesIdList,
          sourceId: sourceId,
          sourceType: sourceType,
        );
      default:
        await FavoritesApi.updateSourceInFavoritesList(
          addFavoritesIdList: addFavoritesIdList,
          removeFavoritesIdList: removeFavoritesIdList,
          sourceId: sourceId,
          sourceType: sourceType,
        );
    }
  }

  static Future<List<Favorites>> getUserFavoritesList(
    int sourceType,
    int pageIndex,
    int pageSize,
  ) async {
    switch (sourceType) {
      case SourceType.post:
      case SourceType.comment:
      return await FavoritesApi.getUserFavoritesList(sourceType, pageIndex, pageSize);
      default:
        return await FavoritesApi.getUserFavoritesList(sourceType, pageIndex, pageSize);
    }
  }

  static Future<(List<Post>, List<Comment>, List<Article>, List<Audio>, List<Gallery>, List<Video>)> getSourceListByFavoritesId({
    required String favoritesId,
    required int pageIndex,
    required int pageSize,
  }) async {
    var (postList, commentList, article, audio, gallery, video) = await FavoritesApi.getSourceListByFavoritesId(
      favoritesId: favoritesId,
      pageIndex: pageIndex,
      pageSize: pageSize,
    );
    if (postList.isNotEmpty) {
      await PostService.fillMedia(postList);
      await PostService.fillFeedback(postList);
    }

    if (commentList.isNotEmpty) {
      await CommentService.fillFeedback(commentList);
    }
    return (postList, commentList, article, audio, gallery, video);
  }
}

import 'package:post_client/api/client/message/feed_favorites_api.dart';
import 'package:post_client/constant/source.dart';
import 'package:post_client/model/message/comment.dart';
import 'package:post_client/model/message/post.dart';

import '../api/client/media/media_favorites_api.dart';
import '../model/favorites.dart';
import '../model/media/article.dart';
import '../model/media/audio.dart';
import '../model/media/gallery.dart';
import '../model/media/video.dart';
import 'message/comment_service.dart';
import 'message/post_service.dart';

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
        return await FeedFavoritesApi.createFavorites(title, introduction, coverUrl, sourceType);
      default:
        return await MediaFavoritesApi.createFavorites(title, introduction, coverUrl, sourceType);
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
        await FeedFavoritesApi.updateFavoritesData(favoritesId, title, introduction, coverUrl);
      case SourceType.video:
      case SourceType.gallery:
      case SourceType.audio:
      case SourceType.article:
        await MediaFavoritesApi.updateFavoritesData(favoritesId, title, introduction, coverUrl);
    }
  }

  static Future<void> deleteUserFavoritesById(
    String favoritesId,
    int sourceType,
  ) async {
    switch (sourceType) {
      case SourceType.post:
      case SourceType.comment:
        return await FeedFavoritesApi.deleteUserFavoritesById(favoritesId);
      default:
        return await MediaFavoritesApi.deleteUserFavoritesById(favoritesId);
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
        await FeedFavoritesApi.updateFeedInFavoritesList(
          addFavoritesIdList: addFavoritesIdList,
          removeFavoritesIdList: removeFavoritesIdList,
          sourceId: sourceId,
          sourceType: sourceType,
        );
      default:
        await MediaFavoritesApi.updateMediaInFavoritesList(
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
        return await FeedFavoritesApi.getUserFavoritesList(sourceType, pageIndex, pageSize);
      default:
        return await MediaFavoritesApi.getUserFavoritesList(sourceType, pageIndex, pageSize);
    }
  }

  static Future<(List<Article>, List<Audio>, List<Gallery>, List<Video>)> getMediaListByFavoritesId({
    required String favoritesId,
    required int pageIndex,
    required int pageSize,
  }) async {
    return await MediaFavoritesApi.getSourceListByFavoritesId(
      favoritesId: favoritesId,
      pageIndex: pageIndex,
      pageSize: pageSize,
    );
  }

  static Future<(List<Post>, List<Comment>)> getFeedListByFavoritesId({
    required String favoritesId,
    required int pageIndex,
    required int pageSize,
  }) async {
    var (postList, commentList) = await FeedFavoritesApi.getSourceListByFavoritesId(
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

    return (postList, commentList);
  }
}

import 'package:post_client/api/client/message/feed_favorites_api.dart';
import 'package:post_client/constant/source.dart';

import '../api/client/media/media_favorites_api.dart';
import '../model/favorites.dart';

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

  static Future<void> deleteUserFavoritesById(
    String favoritesId,
    int sourceType,
  ) async {
    switch (sourceType) {
      case SourceType.post:
      case SourceType.comment:
        return await MediaFavoritesApi.deleteUserMediaFavoritesById(favoritesId);
      default:
        return await FeedFavoritesApi.deleteUserFavoritesById(favoritesId);
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
}

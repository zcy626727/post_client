import '../../api/client/message/feed_favorites_api.dart';
import '../../model/favorites.dart';

class FeedFavoritesService {
  static Future<Favorites> createFavorites(
    String title,
    String introduction,
    String? coverUrl,
    int sourceType,
  ) async {
    var favorites = await FeedFavoritesApi.createFavorites(title, introduction, coverUrl, sourceType);
    return favorites;
  }

  static Future<void> deleteUserFavoritesById(
    String favoritesId,
  ) async {
    await FeedFavoritesApi.deleteUserFavoritesById(favoritesId);
  }

  static Future<void> addMediaToFavorites({
    required List<String> addFavoritesIdList,
    required List<String> removeFavoritesIdList,
    required String sourceId,
    required int sourceType,
  }) async {
    await FeedFavoritesApi.updateFeedInFavoritesList(
      addFavoritesIdList: addFavoritesIdList,
      removeFavoritesIdList: removeFavoritesIdList,
      sourceId: sourceId,
      sourceType: sourceType,
    );
  }

  static Future<List<Favorites>> getUserFavoritesList(
    int sourceType,
    int pageIndex,
    int pageSize,
  ) async {
    var favoritesList = await FeedFavoritesApi.getUserFavoritesList(sourceType, pageIndex, pageSize);
    return favoritesList;
  }
}

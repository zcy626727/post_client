import '../../api/client/message/feed_favorites_api.dart';
import '../../model/message/feed_favorites.dart';

class FeedFavoritesService {
  static Future<FeedFavorites> createFavorites(
      String title,
      String introduction,
      String? coverUrl,
      int feedType,
      ) async {
    var favorites = await FeedFavoritesApi.createFeedFavorites(title, introduction, coverUrl, feedType);
    return favorites;
  }

  static Future<void> deleteUserFavoritesById(
      String favoritesId,
      ) async {
    await FeedFavoritesApi.deleteUserFeedFavoritesById(favoritesId);
  }

  static Future<void> addMediaToFavorites(
      String favoritesId,
      String feedId,
      int feedType,
      ) async {
    await FeedFavoritesApi.addFeedToFavorites(favoritesId, feedId, feedType);
  }

  static Future<List<FeedFavorites>> getUserFavoritesList(
      int feedType,
      int pageIndex,
      int pageSize,
      ) async {
    var favoritesList = await FeedFavoritesApi.getUserFeedFavoritesList(feedType, pageIndex, pageSize);
    return favoritesList;
  }
}

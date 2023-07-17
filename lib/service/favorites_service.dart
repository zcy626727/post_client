import '../api/client/media/favorites_api.dart';
import '../model/favorites.dart';

class FavoritesService {
  static Future<Favorites> createFavorites(
    String title,
    String introduction,
    String? coverUrl,
    int sourceType,
  ) async {
    var history = await FavoritesApi.createFavorites(title, introduction, coverUrl, sourceType);
    return history;
  }

  static Future<void> deleteUserFavoritesById(
    String favoritesId,
  ) async {
    await FavoritesApi.deleteUserFavoritesById(favoritesId);
  }

  static Future<void> addSourceToFavorites(
    String favoritesId,
    String sourceId,
    int sourceType,
  ) async {
    await FavoritesApi.addSourceToFavorites(favoritesId, sourceId, sourceType);
  }

  static Future<List<Favorites>> getUserFavoritesList(
    int sourceType,
    int pageIndex,
    int pageSize,
  ) async {
    var historyList = await FavoritesApi.getUserFavoritesList(sourceType, pageIndex, pageSize);
    return historyList;
  }
}

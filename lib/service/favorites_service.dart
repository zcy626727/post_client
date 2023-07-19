import '../api/client/media/media_favorites_api.dart';
import '../model/media_favorites.dart';

class FavoritesService {
  static Future<MediaFavorites> createFavorites(
    String title,
    String introduction,
    String? coverUrl,
    int sourceType,
  ) async {
    var history = await MediaFavoritesApi.createFavorites(title, introduction, coverUrl, sourceType);
    return history;
  }

  static Future<void> deleteUserFavoritesById(
    String favoritesId,
  ) async {
    await MediaFavoritesApi.deleteUserFavoritesById(favoritesId);
  }

  static Future<void> addSourceToFavorites(
    String favoritesId,
    String sourceId,
    int sourceType,
  ) async {
    await MediaFavoritesApi.addSourceToFavorites(favoritesId, sourceId, sourceType);
  }

  static Future<List<MediaFavorites>> getUserFavoritesList(
    int sourceType,
    int pageIndex,
    int pageSize,
  ) async {
    var historyList = await MediaFavoritesApi.getUserFavoritesList(sourceType, pageIndex, pageSize);
    return historyList;
  }
}

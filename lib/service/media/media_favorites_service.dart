import '../../api/client/media/media_favorites_api.dart';
import '../../model/favorites.dart';

class MediaFavoritesService {
  static Future<Favorites> createFavorites(
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
    await MediaFavoritesApi.deleteUserMediaFavoritesById(favoritesId);
  }

  static Future<void> addMediaToFavoritesList({
    required List<String> addFavoritesIdList,
    required List<String> removeFavoritesIdList,
    required String sourceId,
    required int sourceType,
  }) async {
    await MediaFavoritesApi.updateMediaInFavoritesList(
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
    var favoritesList = await MediaFavoritesApi.getUserFavoritesList(sourceType, pageIndex, pageSize);
    return favoritesList;
  }
}

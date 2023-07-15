import '../api/client/media/favorites_api.dart';
import '../model/favorites.dart';

class FavoritesService {
  static Future<Favorites> createFavorites(
    List<String> mediaIdList,
    int mediaType,
    String position,
  ) async {
    var history = await FavoritesApi.createFavorites(mediaIdList, mediaType, position);
    return history;
  }

  static Future<void> deleteUserFavoritesById(
    String favoritesId,
  ) async {
    await FavoritesApi.deleteUserFavoritesById(favoritesId);
  }

  static Future<void> addMediaToFavorites(
    String favoritesId,
    String mediaId,
    int mediaType,
  ) async {
    await FavoritesApi.addMediaToFavorites(favoritesId, mediaId, mediaType);
  }


  static Future<List<Favorites>> getUserFavoritesList(
    int mediaType,
    int pageIndex,
    int pageSize,
  ) async {
    var historyList = await FavoritesApi.getUserFavoritesList(mediaType, pageIndex, pageSize);
    return historyList;
  }
}

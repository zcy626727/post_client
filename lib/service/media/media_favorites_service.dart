import '../../api/client/media/media_favorites_api.dart';
import '../../model/media/media_favorites.dart';

class MediaFavoritesService {
  static Future<MediaFavorites> createFavorites(
    String title,
    String introduction,
    String? coverUrl,
    int mediaType,
  ) async {
    var history = await MediaFavoritesApi.createMediaFavorites(title, introduction, coverUrl, mediaType);
    return history;
  }

  static Future<void> deleteUserFavoritesById(
    String favoritesId,
  ) async {
    await MediaFavoritesApi.deleteUserMediaFavoritesById(favoritesId);
  }

  static Future<void> addMediaToFavorites(
    String favoritesId,
    String mediaId,
    int mediaType,
  ) async {
    await MediaFavoritesApi.addMediaToFavorites(favoritesId, mediaId, mediaType);
  }

  static Future<List<MediaFavorites>> getUserFavoritesList(
    int mediaType,
    int pageIndex,
    int pageSize,
  ) async {
    var favoritesList = await MediaFavoritesApi.getUserMediaFavoritesList(mediaType, pageIndex, pageSize);
    return favoritesList;
  }
}

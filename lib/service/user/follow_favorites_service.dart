import 'package:post_client/constant/source.dart';
import 'package:post_client/model/follow_favorites.dart';

import '../../api/client/common/follow_favorites_api.dart';

class FollowFavoritesService {
  static Future<FollowFavorites> followFavorites({
    required String favoritesId,
    required int sourceType,
  }) async {
    return await FollowFavoritesApi.followFavorites(favoritesId: favoritesId, sourceType: sourceType, isMediaFavorites: isMediaFavorites(sourceType: sourceType));
  }

  static Future<void> unfollowFavorites({
    required String followFavoritesId,
    required int sourceType,
  }) async {
    await FollowFavoritesApi.unfollowFavorites(followFavoritesId: followFavoritesId, isMediaFavorites: isMediaFavorites(sourceType: sourceType));
    return;
  }

  static Future<FollowFavorites> getFollowFavorites({
    required String favoritesId,
    required int sourceType,
  }) async {
    var followAlbum = await FollowFavoritesApi.getFollowFavorites(favoritesId: favoritesId, isMediaFavorites: isMediaFavorites(sourceType: sourceType));
    return followAlbum;
  }

  static Future<List<FollowFavorites>> getUserFollowFavoritesList({
    int pageIndex = 0,
    int pageSize = 20,
    required int sourceType,
    required bool withUser,
  }) async {
    var followAlbumList = await FollowFavoritesApi.getUserFollowFavoritesList(
        pageIndex: pageIndex, pageSize: pageSize, withUser: withUser, sourceType: sourceType, isMediaFavorites: isMediaFavorites(sourceType: sourceType));
    return followAlbumList;
  }

  static bool isMediaFavorites({int? sourceType}) {
    switch (sourceType) {
      case SourceType.post:
      case SourceType.comment:
        return false;
      default:
        return true;
    }
  }
}

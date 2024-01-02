import 'package:post_client/constant/source.dart';

import '../../api/client/common/favorites_source_api.dart';
import '../../model/favorites_source.dart';

class FavoritesSourceService {
  static Future<List<FavoritesSource>> getFavoritesSourceListByFavoritesId({
    required bool isMediaFavorites,
    required int favoritesId,
    required int pageIndex,
    int pageSize = 20,
  }) async {
    var fsList = await FavoritesSourceApi.getFavoritesSourceListByFavoritesId(
      isMediaFavorites: isMediaFavorites,
      favoritesId: favoritesId,
      pageIndex: pageIndex,
      pageSize: pageSize,
    );
    return fsList;
  }

  static Future<List<FavoritesSource>> getFavoritesSourceListBySourceId({
    required String sourceId,
    required int sourceType,
  }) async {
    var isMediaFavorites = true;
    switch (sourceType) {
      case SourceType.comment:
      case SourceType.post:
        isMediaFavorites = false;
    }

    var fsList = await FavoritesSourceApi.getFavoritesSourceListBySourceId(
      isMediaFavorites: isMediaFavorites,
      sourceId: sourceId,
    );
    return fsList;
  }
}

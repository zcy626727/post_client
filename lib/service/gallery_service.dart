import 'package:post_client/model/gallery.dart';

import '../api/client/media/gallery_api.dart';
import '../model/user.dart';

class GalleryService {
  static Future<Gallery> createGallery(
    String title,
    String introduction,
    List<int> fileIdList,
    List<String> thumbnailUrlList,
    String coverUrl,
    bool withPost,
  ) async {
    var gallery = await GalleryApi.createGallery(title, introduction, fileIdList, thumbnailUrlList, coverUrl, withPost);
    return gallery;
  }

  static Future<void> deleteGallery(
    String galleryId,
  ) async {
    await GalleryApi.deleteUserGalleryById(galleryId);
  }

  static Future<Gallery> getGalleryById(
    String galleryId,
  ) async {
    var gallery = await GalleryApi.getGalleryById(galleryId);
    return gallery;
  }

  static Future<List<Gallery>> getGalleryListByUserId(
    User user,
    int pageIndex,
    int pageSize,
  ) async {
    var galleryList = await GalleryApi.getGalleryListByUserId(user.id!, pageIndex, pageSize);
    for (var gallery in galleryList) {
      gallery.user = user;
    }
    return galleryList;
  }

  static Future<List<Gallery>> getGalleryListRandom(
    int pageSize,
  ) async {
    var galleryList = await GalleryApi.getGalleryListRandom(pageSize);
    return galleryList;
  }
}

import 'package:post_client/model/media/gallery.dart';

import '../../api/client/media/gallery_api.dart';
import '../../model/user/user.dart';

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

  static Future<void> updateGalleryData({
    required String mediaId,
    String? title,
    String? introduction,
    List<int>? fileIdList,
    List<String>? thumbnailUrlList,
    String? coverUrl,
    String? albumId,
  }) async {
    await GalleryApi.updateGalleryData(
      thumbnailUrlList: thumbnailUrlList,
      coverUrl: coverUrl,
      mediaId: mediaId,
      title: title,
      introduction: introduction,
      fileIdList: fileIdList,
      albumId: albumId
    );
  }

  static Future<void> deleteGallery(
    String? galleryId,
  ) async {
    if (galleryId == null) return;
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

  static Future<List<Gallery>> getGalleryListByAlbumId({
    required int albumUserId,
    required String albumId,
    int pageIndex = 0,
    required int pageSize,
  }) async {
    var (galleryList, user) = await GalleryApi.getGalleryListByAlbumId(
      albumUserId: albumUserId,
      albumId: albumId,
      pageIndex: pageIndex,
      pageSize: pageSize,
    );
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

  static Future<List<Gallery>> searchGallery(
    String title,
    int page,
    int pageSize,
  ) async {
    var galleryList = await GalleryApi.searchGallery(title, page, pageSize);
    return galleryList;
  }
}

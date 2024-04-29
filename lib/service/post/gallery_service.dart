import 'package:post_client/model/post/gallery.dart';

import '../../api/client/post/gallery_api.dart';
import '../../model/user/user.dart';

class GalleryService {
  static Future<Gallery> createGallery({
    required String title,
    required String introduction,
    required List<int> fileIdList,
    required List<String> thumbnailUrlList,
    required String coverUrl,
    required bool withPost,
    String? albumId,
  }) async {
    var gallery = await GalleryApi.createGallery(
      title: title,
      introduction: introduction,
      fileIdList: fileIdList,
      thumbnailUrlList: thumbnailUrlList,
      coverUrl: coverUrl,
      withPost: withPost,
      albumId: albumId,
    );
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
    await GalleryApi.updateGalleryData(thumbnailUrlList: thumbnailUrlList, coverUrl: coverUrl, galleryId: mediaId, title: title, introduction: introduction, fileIdList: fileIdList, albumId: albumId);
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

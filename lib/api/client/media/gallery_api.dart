import 'package:dio/dio.dart';

import '../../../model/media/gallery.dart';
import '../../../model/user/user.dart';
import '../media_http_config.dart';

class GalleryApi {
  static Future<Gallery> createGallery(
      {required String title,
      required String introduction,
      required List<int> fileIdList,
      required List<String> thumbnailUrlList,
      required String coverUrl,
      required bool withPost,
      String? albumId}) async {
    var r = await MediaHttpConfig.dio.post(
      "/gallery/createGallery",
      data: {
        "title": title,
        "introduction": introduction,
        "fileIdList": fileIdList,
        "thumbnailUrlList": thumbnailUrlList,
        "coverUrl": coverUrl,
        "withPost": withPost,
        "albumId": albumId,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    return Gallery.fromJson(r.data['gallery']);
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
    var r = await MediaHttpConfig.dio.post(
      "/gallery/updateGalleryData",
      data: {
        "mediaId": mediaId,
        "title": title,
        "introduction": introduction,
        "fileIdList": fileIdList,
        "thumbnailUrlList": thumbnailUrlList,
        "coverUrl": coverUrl,
        "albumId": albumId,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<void> deleteUserGalleryById(
    String galleryId,
  ) async {
    await MediaHttpConfig.dio.post(
      "/gallery/deleteUserGalleryById",
      data: {
        "galleryId": galleryId,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<Gallery> getGalleryById(
    String galleryId,
  ) async {
    var r = await MediaHttpConfig.dio.get(
      "/gallery/getGalleryById",
      queryParameters: {
        "galleryId": galleryId,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": false,
      }),
    );
    return Gallery.fromJson(r.data['gallery']);
  }

  static Future<List<Gallery>> getGalleryListByUserId(
    int userId,
    int pageIndex,
    int pageSize,
  ) async {
    var r = await MediaHttpConfig.dio.get(
      "/gallery/getGalleryListByUserId",
      queryParameters: {
        "targetUserId": userId,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": false,
      }),
    );

    return _parseGalleryList(r);
  }

  static Future<(List<Gallery>, User?)> getGalleryListByAlbumId({
    required int albumUserId,
    required String albumId,
    required int pageIndex,
    required int pageSize,
  }) async {
    var r = await MediaHttpConfig.dio.get(
      "/gallery/getGalleryListByAlbumId",
      queryParameters: {
        "albumUserId": albumUserId,
        "albumId": albumId,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": false,
      }),
    );

    User? user;
    if (r.data['user'] != null) {
      user = User.fromJson(r.data['user']);
    }

    var galleryList = _parseGalleryList(r);

    return (galleryList, user);
  }

  static Future<List<Gallery>> getGalleryListRandom(
    int pageSize,
  ) async {
    var r = await MediaHttpConfig.dio.get(
      "/gallery/getGalleryListRandom",
      queryParameters: {
        "pageSize": pageSize,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": false,
      }),
    );
    return _parseGalleryListWithUser(r);
  }

  static Future<List<Gallery>> searchGallery(
    String title,
    int page,
    int pageSize,
  ) async {
    var r = await MediaHttpConfig.dio.get(
      "/gallery/searchGallery",
      queryParameters: {
        "title": title,
        "page": page,
        "pageSize": pageSize,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": false,
      }),
    );

    return _parseGalleryListWithUser(r);
  }

  static List<Gallery> _parseGalleryListWithUser(Response<dynamic> r) {
    Map<int, User> userMap = {};
    if (r.data['userList'] != null) {
      for (var userJson in r.data['userList']) {
        var user = User.fromJson(userJson);
        userMap[user.id ?? 0] = user;
      }
    }
    List<Gallery> galleryList = [];
    if (r.data['galleryList'] != null) {
      for (var galleryJson in r.data['galleryList']) {
        var gallery = Gallery.fromJson(galleryJson);
        gallery.user = userMap[gallery.userId];
        galleryList.add(gallery);
      }
    }
    return galleryList;
  }

  static List<Gallery> _parseGalleryList(Response<dynamic> r) {
    List<Gallery> galleryList = [];
    if (r.data['galleryList'] != null) {
      for (var galleryJson in r.data['galleryList']) {
        var gallery = Gallery.fromJson(galleryJson);
        galleryList.add(gallery);
      }
    }

    return galleryList;
  }
}

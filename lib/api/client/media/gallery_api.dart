import 'package:dio/dio.dart';

import '../../../model/gallery.dart';
import '../../../model/user.dart';
import '../media_http_config.dart';

class GalleryApi {
  static Future<Gallery> createGallery(
    String title,
    String introduction,
    List<int> fileIdList,
    List<String> thumbnailUrlList,
    String coverUrl,
      bool withPost,

      ) async {
    var r = await MediaHttpConfig.dio.post(
      "/gallery/createGallery",
      data: {
        "title": title,
        "introduction": introduction,
        "fileIdList": fileIdList,
        "thumbnailUrlList": thumbnailUrlList,
        "coverUrl": coverUrl,
        "withPost": withPost,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    return Gallery.fromJson(r.data['gallery']);
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

    return _parseGallery(r);
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
    return _parseGalleryWithUser(r);
  }

  static List<Gallery> _parseGalleryWithUser(Response<dynamic> r) {
    Map<int, User> userMap = {};
    for (var userJson in r.data['userList']) {
      var user = User.fromJson(userJson);
      userMap[user.id ?? 0] = user;
    }
    List<Gallery> galleryList = [];
    for (var galleryJson in r.data['galleryList']) {
      var gallery = Gallery.fromJson(galleryJson);
      gallery.user = userMap[gallery.userId];
      galleryList.add(gallery);
    }
    return galleryList;
  }

  static List<Gallery> _parseGallery(Response<dynamic> r) {
    List<Gallery> galleryList = [];
    for (var galleryJson in r.data['galleryList']) {
      var gallery = Gallery.fromJson(galleryJson);
      galleryList.add(gallery);
    }
    return galleryList;
  }
}

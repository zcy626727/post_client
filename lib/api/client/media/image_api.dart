import 'package:dio/dio.dart';

import '../../../model/image.dart';
import '../../../model/user.dart';
import '../media_http_config.dart';

class ImageApi {
  static Future<Image> createImage(
    String title,
    String introduction,
    String md5,
    String thumbnailUrl,
  ) async {
    var r = await MediaHttpConfig.dio.post(
      "/image/createImage",
      data: {
        "title": title,
        "introduction": introduction,
        "md5": md5,
        "thumbnailUrl": thumbnailUrl,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    return Image.fromJson(r.data['image']);
  }

  static Future<void> deleteUserImageById(
    String imageId,
  ) async {
    await MediaHttpConfig.dio.post(
      "/image/deleteUserImageById",
      data: {
        "imageId": imageId,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<Image> getImageById(
    String imageId,
  ) async {
    var r = await MediaHttpConfig.dio.get(
      "/image/getImageById",
      queryParameters: {
        "imageId": imageId,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": false,
      }),
    );
    return Image.fromJson(r.data['image']);
  }

  static Future<List<Image>> getImageListByUserId(
    int userId,
    int pageIndex,
    int pageSize,
  ) async {
    var r = await MediaHttpConfig.dio.get(
      "/image/getImageListByUserId",
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

    return _parseImage(r);
  }

  static Future<List<Image>> getImageListRandom(
    int pageSize,
  ) async {
    var r = await MediaHttpConfig.dio.get(
      "/image/getImageListRandom",
      queryParameters: {
        "pageSize": pageSize,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": false,
      }),
    );
    return _parseImageWithUser(r);
  }

  static List<Image> _parseImageWithUser(Response<dynamic> r) {
    Map<int, User> userMap = {};
    for (var userJson in r.data['userList']) {
      var user = User.fromJson(userJson);
      userMap[user.id ?? 0] = user;
    }
    List<Image> imageList = [];
    for (var imageJson in r.data['imageList']) {
      var image = Image.fromJson(imageJson);
      image.user = userMap[image.userId];
      imageList.add(image);
    }
    return imageList;
  }

  static List<Image> _parseImage(Response<dynamic> r) {
    List<Image> imageList = [];
    for (var imageJson in r.data['imageList']) {
      var image = Image.fromJson(imageJson);
      imageList.add(image);
    }
    return imageList;
  }
}

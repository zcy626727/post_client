import 'package:post_client/model/image.dart';

import '../api/client/media/image_api.dart';
import '../model/user.dart';

class ImageService {
  static Future<Image> createImage(
    String title,
    String introduction,
    String md5,
    String thumbnailUrl,
  ) async {
    var image = await ImageApi.createImage(title, introduction, md5, thumbnailUrl);
    return image;
  }

  static Future<void> deleteImage(
    String imageId,
  ) async {
    await ImageApi.deleteUserImageById(imageId);
  }

  static Future<Image> getImageById(
    String imageId,
  ) async {
    var image = await ImageApi.getImageById(imageId);
    return image;
  }

  static Future<List<Image>> getImageListByUserId(
    int userId,
    int pageIndex,
    int pageSize,
    User user,
  ) async {
    var imageList = await ImageApi.getImageListByUserId(userId, pageIndex, pageSize);
    for (var image in imageList) {
      image.user = user;
    }
    return imageList;
  }

  static Future<List<Image>> getImageListRandom(
    int pageSize,
  ) async {
    var imageList = await ImageApi.getImageListRandom(pageSize);
    return imageList;
  }
}

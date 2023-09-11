import 'dart:typed_data';

import '../media_http_config.dart';

class FileApi {
  //获取putUrl，小文件上传
  static Future<(String, int)> genPutFileUrl(
    String md5,
    bool private,
    List<int> magicNumber,
  ) async {
    var r = await MediaHttpConfig.dio.post(
      "/file/genPutFileUrl",
      data: {
        "md5": md5,
        "private": private,
        "magicNumber": magicNumber,
      },
      options: MediaHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );

    String putFileUrl = r.data["putFileUrl"];
    int fileId = r.data["fileId"];
    //获取数据
    return (putFileUrl, fileId);
  }

  //获取getUrl，文件下载
  static Future<void> completePutFile(int fileId) async {
    var r = await MediaHttpConfig.dio.post(
      "/file/completePutFile",
      data: {
        "fileId": fileId,
      },
      options: MediaHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );

    //获取数据
    return;
  }

  //获取getUrl，文件下载
  static Future<(String, String)> genGetFileUrl(int fileId) async {
    var r = await MediaHttpConfig.dio.post(
      "/file/genGetFileUrl",
      data: {
        "fileId": fileId,
      },
      options: MediaHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );

    //获取数据
    return (r.data["getFileUrl"] as String, r.data["staticUrl"] as String);
  }
}

import 'dart:io';
import 'dart:typed_data';

import 'package:post_client/domain/multipart_info.dart';

import '../media_http_config.dart';

class MultipartApi {
  //初始化上传任务
  static Future<MultipartInfo> initMultipartUpload(
    String md5,
    bool private,
    int fileSize,
    List<int> magicNumber,
  ) async {
    var r = await MediaHttpConfig.dio.post(
      "/multipart/initMultipartUpload",
      data: {
        "md5": md5,
        "fileSize": fileSize,
        "private": private,
        "magicNumber": magicNumber,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    //获取数据
    MultipartInfo multipartInfo = MultipartInfo.fromJson(r.data["multipartUploadInfo"]);
    return multipartInfo;
  }

  //获取上传url
  static Future<(MultipartInfo, List<String>)> getUploadUrl(String md5, int urlCount, int uploadedPartCount) async {
    var r = await MediaHttpConfig.dio.post(
      "/multipart/getUploadUrl",
      data: {
        "md5": md5,
        "urlCount": urlCount,
        "uploadedPartNum": uploadedPartCount,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    //获取数据
    MultipartInfo multipartInfo = MultipartInfo.fromJson(r.data["multipartUploadInfo"]);
    var list = r.data["urlList"];
    List<String> urlList = [];
    if (r.data["urlList"] != null) {
      for (var u in list) {
        urlList.add(u.toString());
      }
    }
    return (multipartInfo, urlList);
  }

  //完成上传
  static Future<void> completeMultipartUpload(String md5) async {
    var r = await MediaHttpConfig.dio.post(
      "/multipart/completeMultipartUpload",
      data: {
        "md5": md5,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }
}

import 'package:dio/dio.dart';
import 'package:post_client/domain/multipart_info.dart';

import '../../config/global.dart';
import '../../config/net_config.dart';

class MediaHttpConfig {
  static Options options = Options();

  static Dio dio = Dio(BaseOptions(
    baseUrl: NetConfig.mediaApiUrl,
  ));

  static void init() {
    // 添加拦截器
    dio.interceptors.add(Global.netCacheInterceptor);
    dio.interceptors.add(Global.netCommonInterceptor);
  }
}

class MultipartApi {
  //初始化上传任务
  static Future<MultipartInfo> initMultipartUpload(
    String md5,
    bool private,
    int fileSize,
  ) async {
    var r = await MediaHttpConfig.dio.post(
      "/multipart/initMultipartUpload",
      queryParameters: {
        "md5": md5,
        "fileSize": fileSize,
        "private": private,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    //获取数据
    MultipartInfo multipartInfo = MultipartInfo.fromJson(r.data["multipartInfo"]);
    return multipartInfo;
  }

  //获取上传url
  static Future<(MultipartInfo, List<String>)> getUploadUrl(String md5, int urlCount, int uploadedPartCount) async {
    var r = await MediaHttpConfig.dio.get(
      "/multipart/getUploadUrl",
      queryParameters: {
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
    MultipartInfo multipartInfo = MultipartInfo.fromJson(r.data["multipartInfo"]);
    var list = r.data["urlList"];
    List<String> urlList = [];
    for (var u in list) {
      urlList.add(u.toString());
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

class FileApi {
  //获取putUrl，小文件上传
  static Future<String> genPutFileUrl(String md5, bool private) async {
    var r = await MediaHttpConfig.dio.post(
      "/file/genPutFileUrl",
      data: {
        "md5": md5,
        "private": private,
      },
      options: MediaHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );

    //获取数据
    return r.data["putFileUrl"];
  }

  //获取getUrl，文件下载
  static Future<(String,String)> genGetFileUrl(String md5,bool staticLink) async {
    var r = await MediaHttpConfig.dio.post(
      "/file/genGetFileUrl",
      data: {
        "md5": md5,
        "staticLink": staticLink,
      },
      options: MediaHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );

    //获取数据
    return (r.data["getFileUrl"] as String,r.data["staticUrl"] as String);
  }
}


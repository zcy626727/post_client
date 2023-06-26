import '../media_http_config.dart';

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
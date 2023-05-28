import 'package:dio/dio.dart';

import '../../config/global.dart';
import '../../config/net_config.dart';
import '../../model/user_folder.dart';

class PostHttpConfig {
  static Options options = Options();

  static Dio dio = Dio(BaseOptions(
    baseUrl: NetConfig.postApiUrl,
  ));

  static void init() {
    // 添加拦截器
    dio.interceptors.add(Global.netCacheInterceptor);
    dio.interceptors.add(Global.netCommonInterceptor);
  }
}

class UserFolderApi {
  //新建文件夹
  static Future<UserFolder> createFolder(
      int parentId, String folderName) async {
    var r = await PostHttpConfig.dio.post(
      "/folder/createFolder",
      queryParameters: {
        "parentId": parentId,
        "folderName": folderName,
      },
      options: PostHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );

    return UserFolder.fromJson(r.data["folder"]);
  }

  //删除文件夹
  static Future<void> deleteFolder(int folderId) async {
    var _ = await PostHttpConfig.dio.post(
      "/folder/deleteFolder",
      queryParameters: {
        "folderId": folderId,
      },
      options: PostHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
  }

  //重命名文件夹
  static Future<void> renameFolder(
    int folderId,
    String newFolderName,
    String oldFolderName,
  ) async {
    var _ = await PostHttpConfig.dio.post(
      "/folder/renameFolder",
      queryParameters: {
        "folderId": folderId,
        "newFolderName": newFolderName,
        "oldFolderName": oldFolderName,
      },
      options: PostHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
  }

  //移动文件夹
  static Future<void> moveFolder(
    int folderId,
    int oldParentId,
    int newParentId,
  ) async {
    var _ = await PostHttpConfig.dio.post(
      "/folder/moveFolder",
      queryParameters: {
        "folderId": folderId,
        "newParentId": newParentId,
        "oldParentId": oldParentId,
      },
      options: PostHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
  }

  static Future<List<UserFolder>> getFolderList(
    int parentId,
    List<int> statusList,
  ) async {
    var r = await PostHttpConfig.dio.get(
      "/folder/getFolderList",
      queryParameters: {
        "parentId": parentId,
        "statusList": statusList,
      },
      options: PostHttpConfig.options.copyWith(
        extra: {
          "noCache": false,
          "withToken": true,
        },
      ),
    );

    List<UserFolder> userFolderList = [];
    for (var map in r.data["folderList"]) {
      userFolderList.add(UserFolder.fromJson(map));
    }
    return userFolderList;
  }
}


import 'dart:io';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:post_client/config/global.dart';
import 'package:post_client/domain/task/single_upload_task.dart';
import 'package:post_client/util/file_util.dart';

import '../../api/client/media/file_api.dart';
import '../../enums/upload_task.dart';

// var (getUrl, staticUrl) = await FileApi.genGetFileUrl(task.fileId!);
// task.getUrl = getUrl;
// task.staticUrl = staticUrl;
// sendPort.send([1, task.toJson()]);

class FileUrlService {

  static Future<(String, String)> genGetFileUrl(int fileId) async {
    var t = await FileApi.genGetFileUrl(fileId);
    return t;
  }

  static Future<(String, int)> genPutFileUrl(
    String md5,
    bool isPrivate,
    List<int> magicNumber,
  ) async {
    return await FileApi.genPutFileUrl(md5, isPrivate, magicNumber);
  }
}

import 'dart:io';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:post_client/api/client/media_http_config.dart';
import 'package:post_client/config/global.dart';
import 'package:post_client/domain/task/upload_media_task.dart';
import 'package:post_client/util/file_util.dart';

import '../api/client/media/file_api.dart';

class FileService {
  static Future<void> startUploadIsolate(SendPort sendPort) async {
    var receivePort = ReceivePort();
    //发送sendPort
    sendPort.send(receivePort.sendPort);
    //任务
    late UploadMediaTask task;
    //交换数据，初始化
    await for (var msg in receivePort) {
      if (msg == null) {
        //退出
        break;
      } else if (msg is List) {
        switch (msg[0]) {
          case 1: //获取状态，用于之后修改状态和发送最新状态
            task = UploadMediaTask.fromJson(msg[1]);
            break;
          case 2: //复制主线程环境：数据库、用户信息
            Global.copyEnv(msg[1], msg[2]);
            break;
          case 3:
          //调用数据库等操作必须初始化
            BackgroundIsolateBinaryMessenger.ensureInitialized(msg[1]);
        }
      }
    }

    //读取文件
    final file = File(task.srcPath!);

    task.status = UploadTaskStatus.init.index;

    //计算md5
    var md5 = await FileUtil.getFileChecksum(file);
    if (md5 == null) {
      return;
    }
    task.md5 = md5;
    sendPort.send([1, task.toJson()]);

    //获取文件上传链接
    var putUrl = await FileApi.genPutFileUrl(md5, task.private,task.magicNumber!);
    if(putUrl.isNotEmpty){
      var data = await file.readAsBytes();
      //上传文件
      await FileUtil.uploadFile(putUrl, data);
    }

    var (getUrl,staticUrl) = await FileApi.genGetFileUrl(task.md5!, true);
    task.link = staticUrl;
    sendPort.send([1, task.toJson()]);
    sendPort.send(true);

  }
}

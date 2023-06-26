import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/services.dart';

import '../api/client/media/multipart_api.dart';
import '../api/client/media_http_config.dart';
import '../config/file_config.dart';
import '../config/global.dart';
import '../domain/task/upload_media_task.dart';
import '../util/file_util.dart';

class MultipartService {
  //用于组合初始化、上传、完成上传方法和初始化isolate环境
  //其他队列->上传队列（uploading）->传入方法->初始化->上传->完成上传->结束方法->完成队列
  //该方法内不应该存在更改status的情况，因为status的更改会伴随着状态的改变
  // 接收消息格式
  // 1:task
  // 2:user、db
  // 3:rootIsolateToken
  // true:结束
  // 发送消息格式
  // sendPort，通过类型识别即可
  // 1:task
  static Future<void> startUploadIsolate(SendPort sendPort) async {
    try {
      var receivePort = ReceivePort();
      //发送sendPort
      sendPort.send(receivePort.sendPort);

      log("上传线程开始执行...");
      //任务
      late UploadMediaTask task;
      //等待主isolate发送消息并根据消息设置当前isolate环境，配置环境是必须的，所以这里采用阻塞的方式
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
      log("环境配置完成");
      //队列转换
      //文件上传时通过task发送任务信息，用于更新任务信息
      //初始化，确保文件计算好md5、后台初创建了上传任务
      log("初始化...");
      await initMultipartUpload(task, sendPort, task.private);
      log("初始化完成");
      //进行上传
      //上传分片过程中要将任务持久化到数据库
      log("上传中...");
      await doMultipartUpload(task, sendPort);
      log("上传完成");
      //完成上传
      log("合并中...");
      await completeMultipartUpload(task, sendPort);
      log("合并完成");
      sendPort.send(true);
    } catch (e) {
      if (e is FormatException) {
        sendPort.send(e);
      } else {
        sendPort.send(const FormatException("请重新上传"));
      }
    } finally {
      //清理资源
      // Global.close();
    }
  }

  static Future<void> initMultipartUpload(UploadMediaTask task, SendPort sendPort, bool private) async {
    final file = File(task.srcPath!);
    var fileStat = await file.stat();
    task.status = UploadTaskStatus.init.index;

    //验证文件
    if (fileStat.size >= FileConfig.maxUploadFileSize) throw const FormatException("文件大小超出限制");

    if (task.md5 != null) {
      //已经解析过文件了，不需要再计算md5
      //初始化阶段
      task.statusMessage = "恢复上传";
      sendPort.send([1, task.toJson()]);
    } else {
      //初始化阶段
      task.statusMessage = "解析文件";
      sendPort.send([1, task.toJson()]);

      var md5 = await FileUtil.getFileChecksum(file);
      if (md5 == null) {
        return;
      }
      task.md5 = md5;
      sendPort.send([1, task.toJson()]);
    }

    //初始化上传
    var multipartInfo = await MultipartApi.initMultipartUpload(task.md5!, private, fileStat.size);

    task.fileName = multipartInfo.fileName;
    task.uploadedSize = multipartInfo.uploadedPartNum! * multipartInfo.partSize!;
    sendPort.send([1, task.toJson()]);
  }

  static Future<void> doMultipartUpload(UploadMediaTask task, SendPort sendPort) async {
    task.statusMessage = "上传中";
    task.status = UploadTaskStatus.uploading.index;
    sendPort.send([1, task.toJson()]);

    RandomAccessFile? access;
    try {
      //打开文件
      final file = File(task.srcPath!);
      access = await file.open();
      //获取上传url和上传任务状态
      var (multipartInfo, urlList) = await MultipartApi.getUploadUrl(task.md5!, Global.urlCount, 0);
      //已上传的大小
      int uploadedPartNum = multipartInfo.uploadedPartNum!;
      //缓冲区
      List<int> buffer = List<int>.filled(multipartInfo.partSize!, 0);
      //开始上传
      while (uploadedPartNum < multipartInfo.totalPartNum!) {
        //设置起始位置，第一个分片起始位置为0，第二个为partSize，依此类推
        access.setPositionSync(multipartInfo.uploadedPartNum! * multipartInfo.partSize!);
        for (var url in urlList) {
          //读取数据
          var len = await access.readInto(buffer);
          //上传
          if (len < buffer.length) {
            //读取到最后一个
            await FileUtil.uploadFile(url, buffer.sublist(0, len));
          } else {
            await FileUtil.uploadFile(url, buffer);
          }
          //用于通知已上传分片数
          uploadedPartNum++;
          //每次上传一个分片后发送task状态
          task.uploadedSize = task.uploadedSize! + len;
          sendPort.send([1, task.toJson()]);
        }
        //获取url和上传任务状态
        (multipartInfo, urlList) = await MultipartApi.getUploadUrl(task.md5!, Global.urlCount, uploadedPartNum);
        //更新已上传分片数
        uploadedPartNum = multipartInfo.uploadedPartNum!;
      }
    } catch (e) {
      rethrow;
    } finally {
      if (access != null) {
        access.close();
      }
    }
  }

  static Future<void> completeMultipartUpload(UploadMediaTask task, SendPort sendPort) async {
    task.statusMessage = "整合中";
    sendPort.send([1, task.toJson()]);

    await MultipartApi.completeMultipartUpload(task.md5!);

    task.statusMessage = "上传完毕";
    task.status = UploadTaskStatus.finished.index;
    sendPort.send([1, task.toJson()]);
  }

  static Future<void> testUpload(SendPort sendPort) async {}
}

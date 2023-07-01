import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:post_client/config/global.dart';
import 'package:post_client/domain/task/upload_media_task.dart';
import 'package:post_client/service/file_service.dart';

class ImageUploadCard extends StatefulWidget {
  const ImageUploadCard({required super.key, required this.task});

  final UploadMediaTask task;

  @override
  State<ImageUploadCard> createState() => _ImageUploadCardState();
}

class _ImageUploadCardState extends State<ImageUploadCard> {
  final double imagePadding = 5.0;
  final double imageWidth = 100;

  @override
  void initState() {
    print('开启上传图片任务：${widget.task.srcPath}');
    super.initState();
    uploadImage(widget.task);
  }

  @override
  Widget build(BuildContext context) {
    var file = File(widget.task.srcPath!);
    return GestureDetector(
      onTap: () {
        // 点击图片的操作（预览、删除）
      },
      child: Container(
        //上传成功前填充前景色为灰
        foregroundDecoration: widget.task.status == UploadTaskStatus.finished.index ? null : BoxDecoration(color: Colors.grey.withAlpha(100)),
        margin: EdgeInsets.only(right: imagePadding),
        width: imageWidth,
        height: imageWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          image: DecorationImage(
            image: FileImage(file),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void uploadImage(UploadMediaTask task) async {
    //消息接收器
    var receivePort = ReceivePort();
    RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
    receivePort.listen(
      (msg) async {
        if (msg is SendPort) {
          msg.send([1, task.toJson()]);
          msg.send([2, Global.user, Global.database!]);
          msg.send([3, rootIsolateToken]);
          //表示结束
          msg.send(null);
          //获取发送器
        } else if (msg is List) {
          //过程消息
          switch (msg[0]) {
            case 1: //task
              task.copy(UploadMediaTask.fromJson(msg[1]));
              break;
          }
        } else if (msg is FormatException) {
          //上传出现异常
          task.status = UploadTaskStatus.error.index;
          task.statusMessage = msg.message;
        } else if (msg == true) {
          //上传结束
          task.status = UploadTaskStatus.finished.index;
          setState(() {});
        }
      },
    );

    //todo 删除功能：从列表删除图片的功能应该将isolate设置为外部变量，点击删除后这个组件中删除，然后调用外部回调更新外部页面
    var isolate = await Isolate.spawn(FileService.startUploadIsolate, receivePort.sendPort);
    isolate.addOnExitListener(receivePort.sendPort);
  }


}

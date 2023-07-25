import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:post_client/config/global.dart';
import 'package:post_client/domain/task/upload_media_task.dart';
import 'package:post_client/service/media/file_service.dart';
import 'package:image/image.dart' as img;

import '../../../../constant/media.dart';
import '../../../widget/dialog/confirm_alert_dialog.dart';
import '../../show/show_snack_bar.dart';

class ImageUploadCard extends StatefulWidget {
  const ImageUploadCard({required super.key, required this.task, this.onDeleteImage});

  final UploadMediaTask task;
  final Function(UploadMediaTask)? onDeleteImage;

  @override
  State<ImageUploadCard> createState() => _ImageUploadCardState();
}

class _ImageUploadCardState extends State<ImageUploadCard> {
  final double imagePadding = 5.0;
  final double imageWidth = 100;
  Isolate? isolate;
  late UploadMediaTask task;

  @override
  void initState() {
    task = widget.task;
    super.initState();
    //如果正在上传中
    if (task.status == UploadTaskStatus.uploading.index) {
      uploadImage(task);
    }
  }

  @override
  Widget build(BuildContext context) {
    DecorationImage? decorationImage;
    if (widget.task.srcPath != null) {
      decorationImage = DecorationImage(
        image: FileImage(File(widget.task.srcPath!)),
        fit: BoxFit.cover,
      );
    } else if (widget.task.staticUrl != null && widget.task.staticUrl!.isNotEmpty) {
      decorationImage = DecorationImage(
        image: NetworkImage(widget.task.staticUrl!),
        fit: BoxFit.cover,
      );
    }

    return GestureDetector(
      onTap: () async {
        //打开file picker
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
        );
        if (result != null) {
          RandomAccessFile? read;
          try {
            var file = result.files.single;
            read = await File(result.files.single.path!).open();
            var data = await read.read(16);
            //消息接收器
            widget.task.srcPath = file.path;
            widget.task.totalSize = file.size;
            widget.task.status = UploadTaskStatus.uploading.index;
            widget.task.mediaType = MediaType.gallery;
            widget.task.magicNumber = data;
            uploadImage(task);
          } catch (e) {
            widget.task.clear();
          } finally {
            read?.close();
          }
          setState(() {});
        } else {
          // User canceled the picker
        }
      },
      onLongPress: () async {
        await deleteImage();
      },
      child: Container(
        //上传成功前填充前景色为灰
        foregroundDecoration: widget.task.status == UploadTaskStatus.finished.index ? null : BoxDecoration(color: Colors.grey.withAlpha(100)),
        width: imageWidth,
        height: imageWidth,
        decoration: decorationImage == null
            ? null
            : BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: decorationImage,
              ),
        child: decorationImage == null ? const Icon(Icons.cloud_upload) : null,
      ),
    );
  }

  void uploadThumb(UploadMediaTask task) async {}

  void uploadImage(UploadMediaTask task) async {
    print('开启上传图片任务：${widget.task.srcPath}');
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

    isolate = await Isolate.spawn(FileService.startUploadIsolate, receivePort.sendPort);
    isolate!.addOnExitListener(receivePort.sendPort);
  }

  Future<void> deleteImage() async {
    //展示弹出框，选择是否删除
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmAlertDialog(
          text: "是否确定删除？",
          onConfirm: () async {
            try {
              if (widget.onDeleteImage != null) {
                await widget.onDeleteImage!(widget.task);
              }
            } on DioException catch (e) {
              ShowSnackBar.exception(context: context, e: e, defaultValue: "删除失败");
            } finally {
              Navigator.pop(context);
            }
            if (isolate != null) {
              isolate!.kill();
            }
          },
          onCancel: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }
}

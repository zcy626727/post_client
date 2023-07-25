import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:post_client/util/unit.dart';

import '../../../../api/client/media/file_api.dart';
import '../../../../config/global.dart';
import '../../../../constant/media.dart';
import '../../../../domain/task/upload_media_task.dart';
import '../../../../service/media/file_service.dart';
import '../../../../service/media/multipart_service.dart';
import '../../../widget/button/common_action_one_button.dart';
import '../../../widget/player/common_video_player.dart';

class VideoUploadCard extends StatefulWidget {
  const VideoUploadCard({required super.key, required this.task});

  final UploadMediaTask task;

  @override
  State<VideoUploadCard> createState() => _VideoUploadCardState();
}

class _VideoUploadCardState extends State<VideoUploadCard> {
  Isolate? isolate;

  late Future _futureBuilderFuture;
  String? videoUrl;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
  }

  Future getData() async {
    return Future.wait([getVideoUrl()]);
  }

  Future<void> getVideoUrl() async {
    try {
      if (widget.task.fileId != null) {
        var (url, _) = await FileService.genGetFileUrl(widget.task.fileId!);
        widget.task.getUrl = url;
      }
    } on DioException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          return Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            color: colorScheme.surface,
            child: Column(
              children: [
                if (widget.task.status == UploadTaskStatus.uploading.index) //正在上传
                  SizedBox(
                    height: 130,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.task.srcPath!,
                          maxLines: 1,
                        ),
                        //上传进度
                        LinearProgressIndicator(
                          value: widget.task.uploadedSize / widget.task.totalSize!,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("上传中......"),
                            Text("${UnitUtil.convertByteUnits(widget.task.uploadedSize)}/${UnitUtil.convertByteUnits(widget.task.totalSize)}"),
                          ],
                        ),
                        //取消上传
                        const SizedBox(
                          width: 100,
                          child: CommonActionOneButton(
                            title: "取消上传",
                          ),
                        )
                      ],
                    ),
                  ),
                if (widget.task.getUrl != null)
                  AspectRatio(
                    aspectRatio: 1.8,
                    child: Container(
                      color: colorScheme.background,
                      child: CommonVideoPlayer(videoUrl: widget.task.getUrl!),
                    ),
                  ),
                if (widget.task.status != UploadTaskStatus.uploading.index)
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    color: colorScheme.primaryContainer,
                    width: double.infinity,
                    height: 45,
                    child: TextButton(
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.video,
                        );
                        if (result != null) {
                          RandomAccessFile? read;
                          try {
                            var file = result.files.single;
                            read = await File(result.files.single.path!).open();
                            var data = await read.read(16);
                            //消息接收器
                            widget.task.clear();
                            widget.task.srcPath = file.path;
                            widget.task.totalSize = file.size;
                            widget.task.status = UploadTaskStatus.init.index;
                            widget.task.mediaType = MediaType.audio;
                            widget.task.magicNumber = data;
                            uploadVideo(widget.task);
                          } finally {
                            read?.close();
                          }
                          setState(() {});
                        }
                      },
                      child: Text(widget.task.fileId == null ? "选择视频" : "切换视频"),
                    ),
                  )
              ],
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          );
        }
      },
    );
  }

  void uploadVideo(UploadMediaTask task) async {
    print('开启上传音频任务：${widget.task.srcPath}');

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
              setState(() {});
              break;
          }
        } else if (msg is FormatException) {
          //上传出现异常
          task.status = UploadTaskStatus.error.index;
          task.statusMessage = msg.message;
        } else if (msg == true) {
          //上传结束
          task.status = UploadTaskStatus.finished.index;
          var (link, staticUrl) = await FileApi.genGetFileUrl(task.fileId!);
          task.getUrl = link;
          task.staticUrl = staticUrl;
          setState(() {});
        }
      },
    );

    isolate = await Isolate.spawn(MultipartService.startUploadIsolate, receivePort.sendPort);
    isolate!.addOnExitListener(receivePort.sendPort);
  }
}

import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:post_client/util/unit.dart';

import '../../../../domain/task/multipart_upload_task.dart';
import '../../../../enums/upload_task.dart';
import '../../../../service/media/file_service.dart';
import '../../../../service/media/multipart_service.dart';
import '../../../widget/button/common_action_one_button.dart';
import '../../../widget/player/common_video_player.dart';

class VideoUploadCard extends StatefulWidget {
  const VideoUploadCard({required super.key, required this.task});

  final MultipartUploadTask task;

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
        videoUrl = url;
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
                if (widget.task.status == UploadTaskStatus.uploading) //正在上传
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
                if (videoUrl != null)
                  AspectRatio(
                    aspectRatio: 1.8,
                    child: Container(
                      color: colorScheme.background,
                      child: CommonVideoPlayer(videoUrl: videoUrl!),
                    ),
                  ),
                if (widget.task.status != UploadTaskStatus.uploading)
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
                            widget.task.status = UploadTaskStatus.init;
                            var task = widget.task;
                            MultipartService.doUploadFile(
                              task: task,
                              onError: (task) {},
                              onSuccess: (task) async {
                                var (link, _) = await FileService.genGetFileUrl(task.fileId!);
                                videoUrl = link;
                                setState(() {});
                              },
                              onUpload: (task) {},
                              onAfterStart: (task) {},
                            );
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
}

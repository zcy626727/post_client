import 'dart:developer';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:post_client/util/unit.dart';

import '../../../../domain/task/multipart_upload_task.dart';
import '../../../../enums/upload_task.dart';
import '../../../../service/media/file_url_service.dart';
import '../../../../service/media/upload_service.dart';
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
  late MultipartUploadTask task;

  //用于过滤上一个上传任务的残留数据
  int updateIndex = 0;

  @override
  void initState() {
    super.initState();
    task = widget.task;
    _futureBuilderFuture = getData();
  }

  @override
  void dispose() {
    super.dispose();
    isolate?.kill();
  }

  Future getData() async {
    return Future.wait([getVideoUrl()]);
  }

  Future<void> getVideoUrl() async {
    try {
      if (task.fileId != null) {
        var (url, _) = await FileUrlService.genGetFileUrl(task.fileId!);
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
                if (task.status != UploadTaskStatus.uploading && task.status != UploadTaskStatus.init)
                  Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    color: colorScheme.primaryContainer,
                    width: double.infinity,
                    height: 45,
                    child: TextButton(
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.video,
                        );
                        if (result != null) {
                          try {
                            var file = result.files.single;
                            videoUrl = null;
                            //消息接收器
                            task.clear();
                            task.srcPath = file.path;
                            task.totalSize = file.size;
                            task.status = UploadTaskStatus.init;
                            var currentFileIndex = updateIndex;

                            MultipartUploadService.doUploadFile(
                              task: task,
                              onError: (task) {},
                              onSuccess: (task) async {
                                var (link, _) = await FileUrlService.genGetFileUrl(task.fileId!);
                                videoUrl = link;
                                setState(() {});
                              },
                              onUpload: (newTask) {
                                if (currentFileIndex != updateIndex) {
                                  print('残留');
                                  return;
                                } else {
                                  print('更新');
                                  task.copy(newTask);
                                  setState(() {});
                                }
                              },
                              onAfterStart: (taskIsolate) {
                                isolate = taskIsolate;
                              },
                            );
                          } finally {}
                          setState(() {});
                        }
                      },
                      child: Text(task.status == UploadTaskStatus.finished ? "切换视频" : "选择视频"),
                    ),
                  ),
                if (task.status == UploadTaskStatus.uploading || task.status == UploadTaskStatus.init) //正在上传
                  SizedBox(
                    height: 130,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          task.srcPath!,
                          maxLines: 1,
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                        //上传进度
                        LinearProgressIndicator(
                          value: task.uploadedSize / task.totalSize!,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(task.statusMessage ?? "读取文件", style: TextStyle(color: colorScheme.onSurface)),
                            Text(
                              "${UnitUtil.convertByteUnits(task.uploadedSize)}/${UnitUtil.convertByteUnits(task.totalSize)}",
                              style: TextStyle(color: colorScheme.onSurface),
                            ),
                          ],
                        ),
                        //取消上传
                        SizedBox(
                          width: 100,
                          child: CommonActionOneButton(
                            title: "取消上传",
                            onTap: () {
                              //关闭上传线程
                              isolate?.kill();
                              task.clear();
                              videoUrl = null;
                              updateIndex++;
                              setState(() {});
                            },
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

import 'dart:developer';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:post_client/domain/task/multipart_upload_task.dart';
import 'package:post_client/service/media/file_url_service.dart';
import 'package:post_client/service/media/upload_service.dart';

import '../../../../enums/upload_task.dart';
import '../../../../util/unit.dart';
import '../../../widget/player/audio/common_audio_player_mini.dart';

class AudioUploadCard extends StatefulWidget {
  const AudioUploadCard({required super.key, required this.task});

  final MultipartUploadTask task;

  @override
  State<AudioUploadCard> createState() => _AudioUploadCardState();
}

class _AudioUploadCardState extends State<AudioUploadCard> {
  Isolate? isolate;

  late Future _futureBuilderFuture;
  late MultipartUploadTask task;
  String? audioUrl;
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
    return Future.wait([getAudioUrl()]);
  }

  Future<void> getAudioUrl() async {
    try {
      if (task.fileId != null) {
        var (url, _) = await FileUrlService.genGetFileUrl(task.fileId!);
        audioUrl = url;
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
                if (task.status == UploadTaskStatus.uploading || task.status == UploadTaskStatus.init) //正在上传
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                  Text("正在上传", style: TextStyle(color: colorScheme.onSurface)),
                                  Text(
                                    "${UnitUtil.convertByteUnits(task.uploadedSize)}/${UnitUtil.convertByteUnits(task.totalSize)}",
                                    style: TextStyle(color: colorScheme.onSurface),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        //取消上传
                        Container(
                          margin: const EdgeInsets.only(left: 3),
                          child: IconButton(
                            onPressed: () {
                              //关闭上传线程
                              isolate?.kill();
                              task.clear();
                              audioUrl = null;
                              updateIndex++;
                              setState(() {});
                            },
                            icon: Icon(
                              Icons.stop,
                              color: colorScheme.onSurface,
                            ),
                            splashRadius: 25,
                          ),
                        )
                      ],
                    ),
                  ),
                //上传完成
                if (audioUrl != null) CommonAudioPlayerMini(audioUrl: audioUrl!),
                //选择音频或更换音频
                if (task.status != UploadTaskStatus.uploading && task.status != UploadTaskStatus.init)
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    color: colorScheme.primaryContainer,
                    width: double.infinity,
                    height: 45,
                    child: TextButton(
                      onPressed: () async {
                        //打开file picker
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['mp3'],
                        );

                        if (result != null) {
                          try {
                            var file = result.files.single;

                            task.clear();
                            //消息接收器
                            audioUrl = null;
                            task.srcPath = file.path;
                            task.totalSize = file.size;
                            var currentFileIndex = updateIndex;

                            MultipartUploadService.doUploadFile(
                              task: task,
                              onError: (task) {},
                              onSuccess: (task) async {
                                var (link, _) = await FileUrlService.genGetFileUrl(task.fileId!);
                                audioUrl = link;
                                setState(() {});
                              },
                              onUpload: (task) {
                                if (currentFileIndex != updateIndex) {
                                  print('残留');
                                  return;
                                } else {
                                  task.copy(task);
                                  setState(() {});
                                }
                              },
                              onAfterStart: (task) {},
                            );
                          } finally {}
                          setState(() {});
                        }
                      },
                      child: Text(task.fileId == null ? "选择音频" : "切换音频"),
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

import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:post_client/api/client/media/file_api.dart';
import 'package:post_client/service/media/file_service.dart';
import 'package:post_client/service/media/multipart_service.dart';
import 'package:post_client/util/file_util.dart';

import '../../../../config/global.dart';
import '../../../../constant/media.dart';
import '../../../../domain/task/upload_media_task.dart';
import '../../../widget/player/audio/common_audio_player_mini.dart';

class AudioUploadCard extends StatefulWidget {
  const AudioUploadCard({required super.key, required this.task});

  final UploadMediaTask task;

  @override
  State<AudioUploadCard> createState() => _AudioUploadCardState();
}

class _AudioUploadCardState extends State<AudioUploadCard> {
  Isolate? isolate;

  late Future _futureBuilderFuture;
  String? audioUrl;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
  }

  Future getData() async {
    return Future.wait([getAudioUrl()]);
  }

  Future<void> getAudioUrl() async {
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
                                  const Text("正在上传"),
                                  Text("${widget.task.uploadedSize}/${widget.task.totalSize!}"),
                                ],
                              ),
                            ],
                          ),
                        ),
                        //取消上传
                        Container(
                          margin: const EdgeInsets.only(left: 3),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.stop),
                            splashRadius: 25,
                          ),
                        )
                      ],
                    ),
                  ),
                //上传完成
                if (widget.task.getUrl != null) CommonAudioPlayerMini(audioUrl: widget.task.getUrl!),
                //选择音频或更换音频
                if (widget.task.status != UploadTaskStatus.uploading.index)
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
                          RandomAccessFile? read;
                          try {
                            var file = result.files.single;
                            read = await File(result.files.single.path!).open();
                            var data = await read.read(16);
                            //消息接收器
                            widget.task.clear();
                            widget.task.srcPath = file.path;
                            widget.task.totalSize = file.size;
                            widget.task.status = UploadTaskStatus.uploading.index;
                            widget.task.mediaType = MediaType.audio;
                            widget.task.magicNumber = data;
                            uploadAudio(widget.task);
                          } finally {
                            read?.close();
                          }
                          setState(() {});
                        }
                      },
                      child: Text(widget.task.fileId == null ? "选择音频" : "切换音频"),
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

  void uploadAudio(UploadMediaTask task) async {
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

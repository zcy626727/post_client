import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../api/client/media/file_api.dart';
import '../../../../config/global.dart';
import '../../../../domain/task/upload_media_task.dart';
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

  @override
  void initState() {
    print('开启上传音频任务：${widget.task.srcPath}');
    super.initState();
    uploadVideo(widget.task);
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      height: 200,
      color: colorScheme.surface,
      child: widget.task.getUrl == null
          ? Center(
              child: SizedBox(
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
                        Text("预计不知道多少秒"),
                        Text("${widget.task.uploadedSize}/${widget.task.totalSize!}"),
                      ],
                    ),
                    //取消上传
                    SizedBox(
                      width: 100,
                      child: CommonActionOneButton(
                        title: "取消上传",
                      ),
                    )
                  ],
                ),
              ),
            )
          : CommonVideoPlayer(videoUrl: widget.task.getUrl!),
    );
  }

  void uploadVideo(UploadMediaTask task) async {
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

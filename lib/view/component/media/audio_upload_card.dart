import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:post_client/api/client/media/file_api.dart';
import 'package:post_client/service/file_service.dart';
import 'package:post_client/service/multipart_service.dart';
import 'package:post_client/util/file_util.dart';

import '../../../config/global.dart';
import '../../../domain/task/upload_media_task.dart';
import '../../widget/player/audio/common_audio_player_mini.dart';

class AudioUploadCard extends StatefulWidget {
  const AudioUploadCard({required super.key, required this.task});

  final UploadMediaTask task;

  @override
  State<AudioUploadCard> createState() => _AudioUploadCardState();
}

class _AudioUploadCardState extends State<AudioUploadCard> {

  Isolate? isolate;
  @override
  void initState() {
    print('开启上传音频任务：${widget.task.srcPath}');
    super.initState();
    uploadAudio(widget.task);
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      height: 70,
      color: colorScheme.surface,
      child: widget.task.getUrl == null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(widget.task.srcPath!,maxLines: 1,),
                        //上传进度
                        LinearProgressIndicator(
                          value: widget.task.uploadedSize/widget.task.totalSize!,
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
            )
          :  CommonAudioPlayerMini(audioUrl: widget.task.getUrl!),
    );
  }

  void uploadAudio(UploadMediaTask task) async {
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
          var (link,_) = await FileApi.genGetFileUrl(task.fileId!);
          print(link);
          task.getUrl = link;
          setState(() {});
        }
      },
    );

    isolate = await Isolate.spawn(MultipartService.startUploadIsolate, receivePort.sendPort);
    isolate!.addOnExitListener(receivePort.sendPort);
  }
}

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:post_client/service/audio_service.dart';
import 'package:post_client/view/component/media/upload/audio_upload_card.dart';
import 'package:post_client/view/component/media/upload/media_info_card.dart';
import 'package:post_client/view/widget/player/audio/common_audio_player_mini.dart';

import '../../../domain/task/upload_media_task.dart';
import '../../component/media/upload/image_upload_card.dart';
import '../../component/show/show_snack_bar.dart';
import '../../widget/button/common_action_one_button.dart';

class AudioEditPage extends StatefulWidget {
  const AudioEditPage({super.key});

  @override
  State<AudioEditPage> createState() => _AudioEditPageState();
}

class _AudioEditPageState extends State<AudioEditPage> {
  UploadMediaTask? audioUploadTask;
  UploadMediaTask coverUploadImage = UploadMediaTask();
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final introductionController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        leading: IconButton(
          splashRadius: 20,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: colorScheme.onBackground,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 5),
            height: 30,
            width: 70,
            child: Center(
              child: CommonActionOneButton(
                title: "发布",
                height: 30,
                onTap: () async {
                  formKey.currentState?.save();
                  if (audioUploadTask == null) {
                    ShowSnackBar.error(context: context, message: "还未上传视频");
                    return;
                  }
                  if (audioUploadTask!.status != UploadTaskStatus.finished.index) {
                    ShowSnackBar.error(context: context, message: "视频未上传完成，请稍后");
                    return;
                  }
                  String? coverUrl;
                  if (coverUploadImage.status != UploadTaskStatus.finished.index) {
                    ShowSnackBar.error(context: context, message: "封面未上传完成，请稍后");
                    return;
                  } else {
                    coverUrl = coverUploadImage.staticUrl!;
                  }
                  //执行验证
                  if (formKey.currentState!.validate()) {
                    try {
                      var video = await AudioService.createAudio(
                        titleController.value.text,
                        introductionController.value.text??"",
                        audioUploadTask!.fileId!,
                        coverUrl,
                      );
                    } on Exception catch (e) {
                      ShowSnackBar.exception(context: context, e: e, defaultValue: "创建文件失败");
                    } finally {
                      Navigator.pop(context);
                    }
                    //加载
                    setState(() {});
                  }
                },
                backgroundColor: colorScheme.primary,
                textColor: colorScheme.onPrimary,
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              audioUploadTask == null
                  ? Container(
                      height: 45,
                      color: colorScheme.primaryContainer,
                      child: TextButton(
                          onPressed: () async {
                            //选择文件
                            //打开file picker
                            FilePickerResult? result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['mp3', 'aac', 'ogg', 'mp4', 'wav', 'flac'],
                            );

                            if (result != null) {
                              RandomAccessFile? read;
                              try {
                                var file = result.files.single;
                                read = await File(result.files.single.path!).open();
                                var data = await read.read(16);
                                //消息接收器
                                audioUploadTask = UploadMediaTask.all(srcPath: file.path, totalSize: file.size, status: UploadTaskStatus.init.index, mediaType: MediaType.audio, magicNumber: data);
                              } finally {
                                read?.close();
                              }
                              setState(() {});
                            }
                          },
                          child: const Text("选择音频")),
                    )
                  : AudioUploadCard(key: ValueKey(audioUploadTask!.srcPath), task: audioUploadTask!),
              MediaInfoCard(
                coverUploadImage: coverUploadImage,
                titleController: titleController,
                introductionController: introductionController,
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:post_client/model/media/audio.dart';
import 'package:post_client/view/component/media/upload/audio_upload_card.dart';
import 'package:post_client/view/component/input/common_info_card.dart';

import '../../../constant/media.dart';
import '../../../domain/task/multipart_upload_task.dart';
import '../../../domain/task/single_upload_task.dart';
import '../../../enums/upload_task.dart';
import '../../../service/media/audio_service.dart';
import '../../../service/media/file_url_service.dart';
import '../../component/show/show_snack_bar.dart';
import '../../widget/button/common_action_one_button.dart';

class AudioEditPage extends StatefulWidget {
  const AudioEditPage({super.key, this.audio, this.onUpdateMedia});

  final Audio? audio;
  final Function(Audio)? onUpdateMedia;

  @override
  State<AudioEditPage> createState() => _AudioEditPageState();
}

class _AudioEditPageState extends State<AudioEditPage> {
  MultipartUploadTask audioUploadTask = MultipartUploadTask();
  SingleUploadTask coverUploadImage = SingleUploadTask();
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final introductionController = TextEditingController(text: "");
  bool _withPost = true;

  @override
  void initState() {
    super.initState();
    if (widget.audio != null && widget.audio!.id != null) {
      coverUploadImage.status = UploadTaskStatus.finished;
      coverUploadImage.mediaType = MediaType.gallery;
      coverUploadImage.coverUrl = widget.audio!.coverUrl;
      audioUploadTask.fileId = widget.audio!.fileId;
      audioUploadTask.status = UploadTaskStatus.finished;
      titleController.text = widget.audio!.title ?? "";
      introductionController.text = widget.audio!.introduction ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
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
        title: Text(
          "编辑音频",
          style: TextStyle(color: colorScheme.onSurface),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 5),
            height: 30,
            width: 70,
            child: Center(
              child: CommonActionOneButton(
                title: widget.audio != null ? "保存" : "发布",
                height: 30,
                onTap: () async {
                  formKey.currentState?.save();
                  if (audioUploadTask.fileId == null) {
                    ShowSnackBar.error(context: context, message: "还未上传音频");
                    return;
                  }
                  if (audioUploadTask.status != UploadTaskStatus.finished) {
                    ShowSnackBar.error(context: context, message: "音频未上传完成，请稍后");
                    return;
                  }
                  if (coverUploadImage.status != UploadTaskStatus.finished) {
                    ShowSnackBar.error(context: context, message: "封面未上传完成，请稍后");
                    return;
                  }

                  //执行验证
                  if (formKey.currentState!.validate()) {
                    try {
                      if (widget.audio != null) {
                        //保存
                        String? newTitle;
                        String? newIntroduction;
                        String? newCoverUrl;
                        int? newFileId;

                        Audio media = widget.audio!;

                        if (titleController.value.text != widget.audio!.title) {
                          newTitle = titleController.value.text;
                          media.title = newTitle;
                        }
                        if (introductionController.value.text != widget.audio!.introduction) {
                          newIntroduction = introductionController.value.text;
                          media.introduction = newIntroduction;
                        }
                        if (audioUploadTask.fileId! != widget.audio!.fileId) {
                          newFileId = audioUploadTask.fileId!;
                          media.fileId = newFileId;
                        }
                        if (coverUploadImage.coverUrl != widget.audio!.coverUrl) {
                          newCoverUrl = coverUploadImage.coverUrl;
                          media.coverUrl = newCoverUrl;
                        }
                        if (newTitle == null && newIntroduction == null && newCoverUrl == null && newFileId == null) throw const FormatException("未做修改");

                        await AudioService.updateAudioData(
                          mediaId: widget.audio!.id!,
                          title: newTitle,
                          introduction: newIntroduction,
                          fileId: newFileId,
                          coverUrl: newCoverUrl,
                        );
                        if (widget.onUpdateMedia != null) {
                          await widget.onUpdateMedia!(media);
                        }
                      } else {
                        //新建
                        var audio = await AudioService.createAudio(
                          titleController.value.text,
                          introductionController.value.text,
                          audioUploadTask.fileId!,
                          coverUploadImage.coverUrl,
                          _withPost,
                        );
                      }

                      if (mounted) Navigator.pop(context);
                    } on Exception catch (e) {
                      ShowSnackBar.exception(context: context, e: e, defaultValue: "创建文件失败");
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
              AudioUploadCard(key: ValueKey(audioUploadTask.srcPath), task: audioUploadTask),
              CommonInfoCard(
                coverUploadImage: coverUploadImage,
                titleController: titleController,
                introductionController: introductionController,
              ),
              if (widget.audio == null)
                Container(
                  color: colorScheme.surface,
                  child: ListTile(
                    leading: Text(
                      '同时发布动态',
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                    trailing: Checkbox(
                      fillColor: MaterialStateProperty.all(_withPost ? colorScheme.primary : colorScheme.onSurface),
                      value: _withPost,
                      onChanged: (bool? value) {
                        setState(() {
                          _withPost = value!;
                        });
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

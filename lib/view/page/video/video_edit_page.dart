import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:post_client/domain/task/single_upload_task.dart';
import 'package:post_client/model/media/video.dart';
import 'package:post_client/service/media/video_service.dart';
import 'package:post_client/view/component/input/common_info_card.dart';
import 'package:post_client/view/component/media/upload/video_upload_card.dart';

import '../../../constant/media.dart';
import '../../../domain/task/multipart_upload_task.dart';
import '../../../enums/upload_task.dart';
import '../../../service/media/file_url_service.dart';
import '../../component/media/upload/image_upload_card.dart';
import '../../component/show/show_snack_bar.dart';
import '../../widget/button/common_action_one_button.dart';

class VideoEditPage extends StatefulWidget {
  const VideoEditPage({super.key, this.video, this.onUpdateMedia});

  final Video? video;
  final Function(Video)? onUpdateMedia;

  @override
  State<VideoEditPage> createState() => _VideoEditPageState();
}

class _VideoEditPageState extends State<VideoEditPage> {
  MultipartUploadTask videoUploadTask = MultipartUploadTask();
  SingleUploadTask coverUploadImage = SingleUploadTask();
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final introductionController = TextEditingController(text: "");
  bool _withPost = true;
  bool isSave = false;

  @override
  void initState() {
    super.initState();
    if (widget.video != null && widget.video!.id != null) {
      isSave = true;
      titleController.text = widget.video!.title ?? "";
      introductionController.text = widget.video!.introduction ?? "";
      coverUploadImage.status = UploadTaskStatus.finished;
      coverUploadImage.mediaType = MediaType.gallery;
      coverUploadImage.coverUrl = widget.video!.coverUrl;
      videoUploadTask.fileId = widget.video!.fileId;
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
          "编辑视频",
          style: TextStyle(color: colorScheme.onSurface),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 5),
            height: 30,
            width: 70,
            child: Center(
              child: CommonActionOneButton(
                title: isSave ? "保存" : "发布",
                height: 30,
                onTap: () async {
                  formKey.currentState?.save();
                  //执行验证
                  if (formKey.currentState!.validate()) {
                    try {
                      if (videoUploadTask.fileId == null) {
                        ShowSnackBar.error(context: context, message: "还未上传视频");
                        return;
                      }
                      if (videoUploadTask.status != UploadTaskStatus.finished) {
                        ShowSnackBar.error(context: context, message: "视频未上传完成，请稍后");
                        return;
                      }
                      if (coverUploadImage.status != UploadTaskStatus.finished) {
                        ShowSnackBar.error(context: context, message: "封面未上传完成，请稍后");
                        return;
                      }

                      String? coverUrl;
                      if (coverUploadImage.fileId != null) {
                        var (_, staticUrl) = await FileUrlService.genGetFileUrl(coverUploadImage.fileId!);
                        coverUrl = staticUrl;
                      }

                      if (isSave) {
                        //保存
                        String? newTitle;
                        String? newIntroduction;
                        String? newCoverUrl;
                        int? newFileId;

                        Video media = widget.video!;

                        if (titleController.value.text != widget.video!.title) {
                          newTitle = titleController.value.text;
                          media.title = newTitle;
                        }
                        if (introductionController.value.text != widget.video!.introduction) {
                          newIntroduction = introductionController.value.text;
                          media.introduction = newIntroduction;
                        }
                        if (coverUrl != widget.video!.coverUrl) {
                          newCoverUrl = coverUrl;
                          media.coverUrl = newCoverUrl;
                        }
                        if (videoUploadTask.fileId! != widget.video!.fileId) {
                          newFileId = videoUploadTask.fileId!;
                          media.fileId = newFileId;
                        }
                        await VideoService.updateVideoData(mediaId: widget.video!.id!, title: newTitle, introduction: newIntroduction, fileId: newFileId, coverUrl: coverUrl);
                        if (widget.onUpdateMedia != null) {
                          widget.onUpdateMedia!(media);
                        }
                      } else {
                        //新建
                        var video = await VideoService.createVideo(
                          titleController.value.text,
                          introductionController.value.text,
                          videoUploadTask.fileId!,
                          coverUrl,
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
              VideoUploadCard(key: ValueKey(videoUploadTask.srcPath), task: videoUploadTask),
              CommonInfoCard(
                coverUploadImage: coverUploadImage,
                titleController: titleController,
                introductionController: introductionController,
              ),
              if (!isSave)
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

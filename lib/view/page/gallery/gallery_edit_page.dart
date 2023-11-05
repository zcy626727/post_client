import 'package:flutter/material.dart';
import 'package:post_client/config/media_config.dart';
import 'package:post_client/model/media/gallery.dart';
import 'package:post_client/service/media/gallery_service.dart';
import 'package:post_client/view/component/input/common_info_card.dart';

import '../../../constant/media.dart';
import '../../../domain/task/single_upload_task.dart';
import '../../../enums/upload_task.dart';
import '../../../service/media/file_url_service.dart';
import '../../component/media/upload/image_upload_list.dart';
import '../../component/show/show_snack_bar.dart';
import '../../widget/button/common_action_one_button.dart';

class GalleryEditPage extends StatefulWidget {
  const GalleryEditPage({super.key, this.gallery, this.onUpdateMedia});

  final Gallery? gallery;
  final Function(Gallery)? onUpdateMedia;

  @override
  State<GalleryEditPage> createState() => _GalleryEditPageState();
}

class _GalleryEditPageState extends State<GalleryEditPage> {
  var imageUploadTaskList = <SingleUploadTask>[];
  SingleUploadTask coverUploadImage = SingleUploadTask();
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final introductionController = TextEditingController(text: "");
  final double imagePadding = 5.0;
  final double imageWidth = 100;
  bool _withPost = true;

  @override
  void initState() {
    super.initState();
    if (widget.gallery != null && widget.gallery!.id != null) {
      titleController.text = widget.gallery!.title ?? "";
      introductionController.text = widget.gallery!.introduction ?? "";
      coverUploadImage.status = UploadTaskStatus.finished;
      coverUploadImage.mediaType = MediaType.gallery;
      coverUploadImage.coverUrl = widget.gallery!.coverUrl;
      if (widget.gallery!.thumbnailUrlList != null) {
        var len = widget.gallery!.thumbnailUrlList!.length;
        for (int i = 0; i < len; i++) {
          var t = SingleUploadTask();
          t.status = UploadTaskStatus.finished;
          t.fileId = widget.gallery!.fileIdList![i];
          t.coverUrl = widget.gallery!.thumbnailUrlList![i];
          imageUploadTaskList.add(t);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      resizeToAvoidBottomInset: true,
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
          "编辑图片",
          style: TextStyle(color: colorScheme.onSurface),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 5),
            height: 30,
            width: 70,
            child: Center(
              child: CommonActionOneButton(
                title: widget.gallery != null ? "保存" : "发布",
                height: 30,
                onTap: () async {
                  formKey.currentState?.save();
                  if (imageUploadTaskList.isEmpty) {
                    ShowSnackBar.error(context: context, message: "还未上传图片");
                    return;
                  }
                  //执行验证
                  if (formKey.currentState!.validate()) {
                    try {
                      var fileIdList = <int>[];
                      var thumbnailUrlList = <String>[];

                      for (var task in imageUploadTaskList) {
                        fileIdList.add(task.fileId!);
                        thumbnailUrlList.add(task.coverUrl!);
                      }

                      if (coverUploadImage.coverUrl == null) {
                        //未选择封面，填充封面
                        coverUploadImage.coverUrl = thumbnailUrlList[0];
                        coverUploadImage.status = UploadTaskStatus.finished;
                      }

                      if (widget.gallery != null) {
                        String? newTitle;
                        String? newIntroduction;
                        String? newCoverUrl;
                        List<int>? newFileIdList;
                        List<String>? newThumbnailUrlList;

                        Gallery media = widget.gallery!;

                        if (titleController.value.text != widget.gallery!.title) {
                          newTitle = titleController.value.text;
                          media.title = newTitle;
                        }
                        if (introductionController.value.text != widget.gallery!.introduction) {
                          newIntroduction = introductionController.value.text;
                          media.introduction = newIntroduction;
                        }
                        if (coverUploadImage.coverUrl != widget.gallery!.coverUrl) {
                          newCoverUrl = coverUploadImage.coverUrl;
                          media.coverUrl = newCoverUrl;
                        }
                        if (fileIdList != widget.gallery!.fileIdList) {
                          newFileIdList = fileIdList;
                          media.fileIdList = newFileIdList;
                        }
                        if (thumbnailUrlList != widget.gallery!.thumbnailUrlList) {
                          newThumbnailUrlList = thumbnailUrlList;
                          media.thumbnailUrlList = newThumbnailUrlList;
                        }
                        if (newTitle == null && newIntroduction == null && fileIdList == null && newCoverUrl == null && newFileIdList == null && newThumbnailUrlList == null) {
                          throw const FormatException("未做修改");
                        }

                        await GalleryService.updateGalleryData(
                          mediaId: widget.gallery!.id!,
                          title: newTitle,
                          introduction: newIntroduction,
                          fileIdList: newFileIdList,
                          thumbnailUrlList: newThumbnailUrlList,
                          coverUrl: newCoverUrl,
                        );
                        if (widget.onUpdateMedia != null) {
                          widget.onUpdateMedia!(media);
                        }
                      } else {
                        //新建
                        var gallery = await GalleryService.createGallery(
                          titleController.value.text,
                          introductionController.value.text,
                          fileIdList,
                          thumbnailUrlList,
                          coverUploadImage.coverUrl!,
                          _withPost,
                        );
                      }

                      if (mounted) Navigator.pop(context);
                    } on Exception catch (e) {
                      if (mounted) ShowSnackBar.exception(context: context, e: e, defaultValue: "创建文件失败");
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
              Container(
                margin: const EdgeInsets.only(top: 1),
                color: colorScheme.surface,
                child: ImageUploadList(
                  imageUploadTaskList: imageUploadTaskList,
                  maxUploadNum: MediaConfig.maxGalleryUploadImageNum,
                  onDeleteImage: (SingleUploadTask task) {
                    imageUploadTaskList.remove(task);
                  },
                ),
              ),
              CommonInfoCard(
                coverUploadImage: coverUploadImage,
                titleController: titleController,
                introductionController: introductionController,
                onRefresh: () {
                  setState(() {});
                },
              ),
              if (widget.gallery == null)
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

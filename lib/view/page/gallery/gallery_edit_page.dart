import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:post_client/config/constants.dart';
import 'package:post_client/config/media_config.dart';
import 'package:post_client/service/gallery_service.dart';
import 'package:post_client/view/component/media/media_info_card.dart';

import '../../../config/post_config.dart';
import '../../../domain/task/upload_media_task.dart';
import '../../component/media/image_upload_card.dart';
import '../../component/media/image_upload_list.dart';
import '../../component/show/show_snack_bar.dart';
import '../../widget/button/common_action_one_button.dart';

class GalleryEditPage extends StatefulWidget {
  const GalleryEditPage({super.key});

  @override
  State<GalleryEditPage> createState() => _GalleryEditPageState();
}

class _GalleryEditPageState extends State<GalleryEditPage> {
  var imageUploadTaskList = <UploadMediaTask>[];
  UploadMediaTask coverUploadImage = UploadMediaTask();
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final introductionController = TextEditingController(text: "");
  final double imagePadding = 5.0;
  final double imageWidth = 100;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
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
                        thumbnailUrlList.add(task.staticUrl!);
                      }
                      var coverUrl = thumbnailUrlList[0];
                      if (coverUploadImage.staticUrl != null) {
                        coverUrl = coverUploadImage.staticUrl!;
                      }
                      var gallery = await GalleryService.createGallery(
                        titleController.value.text,
                        introductionController.value.text,
                        fileIdList,
                        thumbnailUrlList,
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
              Container(
                margin: const EdgeInsets.only(top: 1),
                color: colorScheme.surface,
                child: ImageUploadList(imageUploadTaskList: imageUploadTaskList, maxUploadNum: MediaConfig.maxGalleryUploadImageNum),
              ),
              MediaInfoCard(
                coverUploadImage: coverUploadImage,
                titleController: titleController,
                introductionController: introductionController,
                onRefresh: (){
                  setState(() {});
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

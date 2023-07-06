import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:post_client/config/post_config.dart';
import 'package:post_client/domain/task/upload_media_task.dart';
import 'package:post_client/service/post_service.dart';
import 'package:post_client/view/component/media/upload/image_upload_card.dart';
import 'package:post_client/view/component/quill/quill_tool_bar.dart';
import 'package:post_client/view/component/show/show_snack_bar.dart';
import 'package:post_client/view/widget/button/common_action_one_button.dart';

import '../../component/quill/quill_editor.dart';

class PostEditPage extends StatefulWidget {
  const PostEditPage({Key? key}) : super(key: key);

  @override
  State<PostEditPage> createState() => _PostEditPageState();
}

class _PostEditPageState extends State<PostEditPage> {
  final QuillController _controller = QuillController.basic();
  final FocusNode focusNode = FocusNode();
  var imageUploadTaskList = <UploadMediaTask>[];

  final double imagePadding = 5.0;
  final double imageWidth = 100;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    if (MediaQuery.of(context).viewInsets.bottom == 0) focusNode.unfocus();

    return Scaffold(
      backgroundColor: colorScheme.surface,
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
                  try {
                    var content = jsonEncode(_controller.document.toDelta().toJson());
                    var pictureUrlList = <String>[];
                    bool enablePush = false;
                    var delta = _controller.document.toDelta().toList();
                    for (var d in delta) {
                      var data = d.data;
                      if (data is Map<String, dynamic>) {
                        //只要有map类型的就应该不是空的
                        enablePush = true;
                        //获取@的人
                        var data2 = data['at'];
                        if (data2 != null) {
                          print("找到一个：$data2");
                        }
                      } else if (data is String) {
                        //检查是否可以发布
                        if (!enablePush) {
                          var newString = data.replaceAll(RegExp(r'[ \r\n\t]+'), "");
                          if (newString.isNotEmpty) {
                            enablePush = true;
                          }
                        }
                      }
                    }
                    for (var task in imageUploadTaskList) {
                      if (!enablePush) {
                        enablePush = true;
                      }
                      if (task.status != UploadTaskStatus.finished.index) {
                        ShowSnackBar.error(context: context, message: "图片没有上传完毕");
                        return;
                      }
                      pictureUrlList.add(task.staticUrl!);
                    }
                    if (!enablePush) {
                      ShowSnackBar.error(context: context, message: "没有内容啊");
                      return;
                    }
                    var post = await PostService.createPost(null, null, content, pictureUrlList);
                    Navigator.pop(context);

                  } on Exception catch (e) {
                    ShowSnackBar.exception(context: context, e: e, defaultValue: "创建文件失败");
                  } finally {
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
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: buildImageList(),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: PostQuillEditor(
                  controller: _controller,
                  focusNode: focusNode,
                ),
              ),
            ),
            PostQuillToolBar(controller: _controller),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  Widget buildImageList() {
    var colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Container(
        height: imageWidth,
        width: double.infinity,
        margin: EdgeInsets.all(imagePadding),
        child: ListView.builder(
          itemCount: imageUploadTaskList.length + 1,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          // physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            if (index >= imageUploadTaskList.length) {
              return GestureDetector(
                onTap: () async {
                  if (index >= PostConfig.maxUploadImageNum) {
                    ShowSnackBar.error(context: context, message: "图片最多上传${PostConfig.maxUploadImageNum}个");
                    return;
                  }
                  //打开file picker
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.image,
                  );

                  if (result != null) {
                    RandomAccessFile? read;
                    try {
                      var file = result.files.single;

                      read = await File(file.path!).open();
                      var data = await read.read(16);
                      //消息接收器
                      var task = UploadMediaTask.all(
                        srcPath: file.path,
                        totalSize: file.size,
                        status: UploadTaskStatus.uploading.index,
                        mediaType: MediaType.image,
                        magicNumber: data,
                      );
                      imageUploadTaskList.add(task);
                    } finally {
                      read?.close();
                    }
                    setState(() {});
                  } else {
                    // User canceled the picker
                  }
                },
                child: Container(
                  width: imageWidth,
                  height: imageWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: colorScheme.background,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: colorScheme.onBackground,
                    ),
                  ),
                ),
              );
            } else {
              return ImageUploadCard(key: ValueKey(imageUploadTaskList[index].srcPath), task: imageUploadTaskList[index]);
            }
          },
        ),
      ),
    );
  }
}

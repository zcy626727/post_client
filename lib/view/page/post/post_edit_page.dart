import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:post_client/config/post_config.dart';
import 'package:post_client/domain/task/single_upload_task.dart';
import 'package:post_client/view/component/media/upload/image_upload_card.dart';
import 'package:post_client/view/component/quill/quill_tool_bar.dart';
import 'package:post_client/view/component/show/show_snack_bar.dart';
import 'package:post_client/view/widget/button/common_action_one_button.dart';

import '../../../constant/file/upload.dart';
import '../../../model/user/user.dart';
import '../../../service/post/file_url_service.dart';
import '../../../service/post/post_service.dart';
import '../../component/quill/quill_editor.dart';

class PostEditPage extends StatefulWidget {
  const PostEditPage({Key? key}) : super(key: key);

  @override
  State<PostEditPage> createState() => _PostEditPageState();
}

class _PostEditPageState extends State<PostEditPage> {
  final QuillController _controller = QuillController.basic();
  final FocusNode focusNode = FocusNode();
  var imageUploadTaskList = <SingleUploadTask>[];

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
                height: 40,
                onTap: () async {
                  try {
                    var content = jsonEncode(_controller.document.toDelta().toJson());
                    var pictureUrlList = <String>[];
                    bool enablePush = false;
                    var delta = _controller.document.toDelta().toList();
                    List<int> targetUserIdList = <int>[];

                    for (var d in delta) {
                      var data = d.data;
                      if (data is Map<String, dynamic>) {
                        //只要有map类型的就应该不是空的
                        enablePush = true;
                        //获取@的人
                        var user = User.fromJson(json.decode(data['at']));
                        targetUserIdList.add(user.id!);
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
                      if (task.status != UploadTaskStatus.finished) {
                        ShowSnackBar.error(context: context, message: "图片没有上传完毕");
                        return;
                      }
                      var (_, staticUrl) = await FileUrlService.genGetFileUrl(task.fileId!);
                      pictureUrlList.add(staticUrl);
                    }
                    if (!enablePush) {
                      if (mounted) ShowSnackBar.error(context: context, message: "没有内容啊");
                      return;
                    }
                    var post = await PostService.createPost(null, null, content, pictureUrlList, targetUserIdList);
                    if (mounted) Navigator.pop(context);
                  } on Exception catch (e) {
                    ShowSnackBar.exception(context: context, e: e, defaultValue: "创建文件失败");
                  } finally {}
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
                child: CommonQuillEditor(
                  controller: _controller,
                  focusNode: focusNode,
                ),
              ),
            ),
            CommonQuillToolBar(controller: _controller),
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
                      var task = SingleUploadTask.file(
                        srcPath: file.path,
                        private: false,
                        status: UploadTaskStatus.uploading,
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

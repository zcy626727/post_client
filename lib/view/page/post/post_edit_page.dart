import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:post_client/config/post_config.dart';
import 'package:post_client/view/component/quill/quill_widget.dart';
import 'package:post_client/view/component/show/show_snack_bar.dart';
import 'package:post_client/view/widget/button/common_action_one_button.dart';

class PostEditPage extends StatefulWidget {
  const PostEditPage({Key? key}) : super(key: key);

  @override
  State<PostEditPage> createState() => _PostEditPageState();
}

class _PostEditPageState extends State<PostEditPage> {
  var imageList = <File>[];

  final QuillController _controller = QuillController.basic();

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      bottomSheet: PostQuillToolBar(controller: _controller),
      bottomNavigationBar: buildImageList(),
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
                  await Future.delayed(const Duration(seconds: 1));
                },
                backgroundColor: colorScheme.primary,
                textColor: colorScheme.onPrimary,
              ),
            ),
          )
        ],
      ),
      body: Container(
        color: colorScheme.surface,
        child: Column(
          children: [
            Expanded(
              child: //输入框
                  Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.only(bottom: 110),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: CommonQuillEditor(controller: _controller),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImageList() {
    var colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Container(
        height: 135,
        color: colorScheme.surface,
        padding: const EdgeInsets.all(5),
        child: GridView.builder(
          itemCount: imageList.length + 1,
          shrinkWrap: true,
          // physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
          ),
          itemBuilder: (BuildContext context, int index) {
            if (index == imageList.length) {
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
                    File file = File(result.files.single.path!);
                    imageList.add(file);
                    setState(() {});
                  } else {
                    // User canceled the picker
                  }
                },
                child: Container(
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
              return GestureDetector(
                onTap: () {
                  // 点击图片的操作（预览、删除）
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: FileImage(imageList[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:post_client/config/post_config.dart';
import 'package:post_client/view/component/show/show_snack_bar.dart';
import 'package:post_client/view/widget/button/common_action_one_button.dart';

import '../../../config/component.dart';
import '../../../util/responsive.dart';

class PostEditPage extends StatefulWidget {
  const PostEditPage({Key? key}) : super(key: key);

  @override
  State<PostEditPage> createState() => _PostEditPageState();
}

class _PostEditPageState extends State<PostEditPage> {
  var imageList = <File>[];

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
          "编辑动态",
          style: TextStyle(color: colorScheme.onSurface),
        ),
      ),
      body: ListView(
        children: [
          //输入框
          buildInputField(),

          //图片上传
          buildImageList(),
          buildOptionList(),

          buildButton(),
        ],
      ),
    );
  }

  Widget buildInputField() {
    var colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.surface,
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
      child: TextField(
        maxLines: 4,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              //添加边框
              borderRadius: BorderRadius.circular(5.0),
            ),
            counterStyle: TextStyle(color: colorScheme.onSurface)),
        style: TextStyle(color: colorScheme.onSurface),
        maxLength: 200,
        onChanged: (value) {
          log(value);
        },
      ),
    );
  }

  Widget buildImageList() {
    var colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.surface,
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: GridView.builder(
        itemCount: imageList.length + 1,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
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
    );
  }

  Widget buildOptionList() {
    var colorScheme = Theme.of(context).colorScheme;
    double fontSize = Responsive.isSmall(context) ? 16 : 15;
    return Container(
      color: colorScheme.surface,
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          //年龄限制，可见
          Card(
            color: colorScheme.surface,
            elevation: 0,
            margin: EdgeInsets.zero,
            shape: allCircleShape,
            child: ListTile(
              title: Text(
                "吧啦吧啦",
                style: TextStyle(color: colorScheme.onSurface, fontSize: fontSize),
              ),
              trailing: SizedBox(
                width: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text("name", overflow: TextOverflow.ellipsis, style: TextStyle(color: colorScheme.onSurface, fontSize: fontSize)),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      width: 30,
                      child: Icon(Icons.hive, color: colorScheme.onSurface),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildButton() {
    var colorScheme = Theme.of(context).colorScheme;

    return CommonActionOneButton(
      title: "发布",
      onTap: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      backgroundColor: colorScheme.primary,
      textColor: colorScheme.onPrimary,
    );
  }
}

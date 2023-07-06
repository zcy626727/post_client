import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:post_client/view/widget/button/common_action_one_button.dart';
import 'package:post_client/view/widget/button/common_action_two_button.dart';

//媒体选择器
class MyMediaSelector extends StatefulWidget {
  const MyMediaSelector({Key? key, required this.mediaType}) : super(key: key);

  final FileType mediaType;

  @override
  State<MyMediaSelector> createState() => _MyMediaSelectorState();
}

class _MyMediaSelectorState extends State<MyMediaSelector> {
  String? _link;

  @override
  Widget build(BuildContext context) {
    String typeName = switch (widget.mediaType) { FileType.audio => "音频", FileType.video => "视频", FileType.image => "图片", _ => "文件" };
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 190,
      width: 200,
      margin: const EdgeInsets.only(top: 10),
      color: colorScheme.surface,
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 40,
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  //启动文件选择器，然后选择文件
                  FilePickerResult? result = await FilePicker.platform.pickFiles(type: widget.mediaType);
                  log(result.toString());
                  if (mounted) Navigator.pop(context, "上传后的连接");
                },
                child: Text("本机$typeName"),
              ),
            ),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  //开启一个文件对话框输入地址
                  String? s = await _showLinkDialog(typeName);
                  log("输入链接为：$s");
                  if (mounted) Navigator.pop(context, s);
                },
                child: Text("网络$typeName"),
              ),
            ),
            CommonActionOneButton(
              onTap: () {
                if (mounted) Navigator.pop(context, null);
              },
            )
          ],
        ),
      ),
    );
  }

  Future<String?> _showLinkDialog(String title) async {
    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          content: SizedBox(
            height: 110,
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 50,
                  child: TextField(
                    onChanged: (value) {
                      _link = value;
                    },
                    keyboardType: TextInputType.text,
                    style: const TextStyle(fontSize: 17),
                    decoration:  InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                      labelText: "$title链接",
                      labelStyle:
                      TextStyle(color: Theme.of(context).colorScheme.onBackground),
                      border: OutlineInputBorder(
                        //添加边框
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon: Icon(
                        Icons.link,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 37,
                  child: CommonActionTwoButton(
                    onRightTap: () {
                      Navigator.pop(context, _link);
                      return false;
                    },
                    onLeftTap: () {
                      Navigator.pop(context, null);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

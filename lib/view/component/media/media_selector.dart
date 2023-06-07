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
    String typeName = switch (widget.mediaType) {
      FileType.audio => "音频",
      FileType.video => "视频",
      FileType.image => "图片",
      _ => "文件"
    };
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 190,
      color: colorScheme.background,
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
                  FilePickerResult? result = await FilePicker.platform
                      .pickFiles(type: widget.mediaType);
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
                  String? s = await _showLinkDialog();
                  log("输入链接为：$s");
                  if (mounted) Navigator.pop(context, s);
                },
                child: Text("网络$typeName"),
              ),
            ),
            const CommonActionOneButton()
          ],
        ),
      ),
    );
  }

  Future<String?> _showLinkDialog() async {
    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          content: SizedBox(
            height: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 40,
                  child: TextField(
                    onChanged: (value) {
                      _link = value;
                    },
                    style: const TextStyle(fontSize: 17),
                    textAlignVertical: const TextAlignVertical(y: -0.6),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
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
                    onLeftTap: () {},
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

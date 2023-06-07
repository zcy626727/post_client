import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:post_client/util/responsive.dart';
import 'package:post_client/view/component/media/media_selector.dart';
import 'package:post_client/view/widget/player/common_audio_player.dart';


//嵌入块样式
class MyAudioEmbedBuilder implements EmbedBuilder {
  MyAudioEmbedBuilder();

  @override
  String get key => MyAudioBlockEmbed.embedType;

  @override
  Widget build(
      BuildContext context,
      QuillController controller,
      node,
      bool readOnly,
      bool inline,
      TextStyle textStyle,
  ) {
    final audioUrl = node.value.data;

    return CommonAudioPlayerMini(audioUrl: audioUrl);
  }

  @override
  WidgetSpan buildWidgetSpan(Widget widget) {
    return WidgetSpan(child: widget);
  }

  @override
  bool get expanded => true;
}

//连接嵌入块和按钮
class MyAudioBlockEmbed extends CustomBlockEmbed {
  MyAudioBlockEmbed(String value) : super(embedType, value);

  static const String embedType = "audio";

  //根据document生成VideoBlockEmbed
  static MyAudioBlockEmbed fromDocument(Document document) =>
      MyAudioBlockEmbed(jsonEncode(document.toDelta().toJson()));

  Document get document => Document.fromJson(jsonDecode(data));
}

//嵌入块触发按钮
class MyAudioEmbedButton extends StatelessWidget {
  const MyAudioEmbedButton({
    required this.controller,
    this.iconSize = kDefaultIconSize,
    this.iconTheme,
    this.dialogTheme,
    Key? key,
  }) : super(key: key);

  final double iconSize;

  final QuillController controller;

  final QuillIconTheme? iconTheme;

  final QuillDialogTheme? dialogTheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = iconTheme?.iconUnselectedColor ?? theme.iconTheme.color;
    final iconFillColor =
        iconTheme?.iconUnselectedFillColor ?? theme.canvasColor;
    return QuillIconButton(
      icon: Icon(Icons.audiotrack, size: iconSize, color: iconColor),
      highlightElevation: 0,
      hoverElevation: 0,
      size: iconSize * 1.77,
      fillColor: iconFillColor,
      borderRadius: iconTheme?.borderRadius ?? 2,
      onPressed: () => _onPressedHandler(context),
    );
  }

  Future<void> _onPressedHandler(BuildContext context) async {
    //底部弹出框（选文件/填链接）
    //文件：上传文件，然后返回链接
    //链接：返回链接
    //调用submitted()方法
    String? link;
    if (Responsive.isSmall(context)) {
      link = await showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return const MyMediaSelector(mediaType: FileType.audio);
          });
    } else {
      link = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.background,
            contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
            content: const SizedBox(
              height: 150,
              child: MyMediaSelector(mediaType: FileType.audio),
            ),
          );
        },
      );
    }

    _submitted(link);
  }

  //将连接替换进去
  void _submitted(String? link) {
    if (link != null) {
      final index = controller.selection.baseOffset;
      final length = controller.selection.extentOffset - index;

      controller.replaceText(index, length, MyAudioBlockEmbed(link), null);
    }
  }
}

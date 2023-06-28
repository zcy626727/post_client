import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:post_client/view/widget/player/common_video_player.dart';

import '../../../../util/responsive.dart';
import '../../media/media_selector.dart';

class MyVideoEmbedBuilder implements EmbedBuilder {
  MyVideoEmbedBuilder();

  @override
  String get key => MyVideoBlockEmbed.embedType;

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    final videoUrl = node.value.data;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 3,vertical: 3),
      elevation: 0,
      child: AspectRatio(
        aspectRatio: 3 / 2,
        child: CommonVideoPlayer(videoUrl: videoUrl),
      ),
    );
  }

  @override
  WidgetSpan buildWidgetSpan(Widget widget) {
    return WidgetSpan(child: widget,alignment: PlaceholderAlignment.middle);
  }

  @override
  bool get expanded => true;

  @override
  String toPlainText(Embed node) {
    throw node.toPlainText();
  }
}

class MyVideoBlockEmbed extends CustomBlockEmbed {
  MyVideoBlockEmbed(String value) : super(embedType, value);

  static const String embedType = "video";

  //根据document生成VideoBlockEmbed
  static MyVideoBlockEmbed fromDocument(Document document) => MyVideoBlockEmbed(jsonEncode(document.toDelta().toJson()));

  Document get document => Document.fromJson(jsonDecode(data));
}

class MyVideoEmbedButton extends StatelessWidget {
  const MyVideoEmbedButton({
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
    final iconFillColor = iconTheme?.iconUnselectedFillColor ?? theme.canvasColor;
    return QuillIconButton(
      icon: Icon(Icons.movie_creation, size: iconSize, color: iconColor),
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
            return const MyMediaSelector(mediaType: FileType.video);
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
              child: MyMediaSelector(mediaType: FileType.video),
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

      var block = MyVideoBlockEmbed(link);
      //添加at
      controller.replaceText(index, 0, block, null);
      //移动光标
      controller.moveCursorToPosition(index + 1);
    }
  }
}

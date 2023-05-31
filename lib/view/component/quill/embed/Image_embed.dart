import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:post_client/util/responsive.dart';
import 'package:post_client/view/component/quill/media_bottom_selector.dart';

//暂时使用提供的imageBlock，有需要再自定义
// class ImageEmbedBuilder implements EmbedBuilder {
//   ImageEmbedBuilder();
//
//   @override
//   String get key => ImageBlockEmbed.embedType;
//
//   @override
//   Widget build(
//     BuildContext context,
//     QuillController controller,
//     Embed node,
//     bool readOnly,
//   ) {
//     final imageUrl = node.value.data;
//
//     return Container(
//       color: Colors.transparent,
//       child: Image(image: NetworkImage(imageUrl)),
//     );
//   }
// }

// class ImageBlockEmbed extends CustomBlockEmbed {
//   ImageBlockEmbed(String value) : super(embedType, value);
//
//   static const String embedType = "image";
//
//   //根据document生成ImageBlockEmbed
//   static ImageBlockEmbed fromDocument(Document document) =>
//       ImageBlockEmbed(jsonEncode(document.toDelta().toJson()));
//
//   Document get document => Document.fromJson(jsonDecode(data));
// }

class MyImageEmbedButton extends StatelessWidget {
  const MyImageEmbedButton({
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
      icon: Icon(Icons.image, size: iconSize, color: iconColor),
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
            return const MyMediaSelector(mediaType: FileType.image);
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
              child: MyMediaSelector(mediaType: FileType.image),
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

      //自定义的
      // controller.replaceText(index, length, ImageBlockEmbed(link), null);

      controller.replaceText(index, length, BlockEmbed.image(link), null);
    }
  }
}

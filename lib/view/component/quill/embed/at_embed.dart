import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_svg/svg.dart';
import 'package:post_client/model/user.dart';
import 'package:post_client/util/responsive.dart';
import 'package:post_client/view/page/user/user_selector_page.dart';

//嵌入块样式
class MyAtEmbedBuilder implements EmbedBuilder {
  MyAtEmbedBuilder();

  @override
  String get key => MyAtBlockEmbed.embedType;

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    User user = User.fromJson(json.decode(node.value.data));

    var colorScheme = Theme.of(context).colorScheme;
    // return Container(
    //   color: colorScheme.primaryContainer,
    //   padding: const EdgeInsets.only(left: 10),
    //   child: Text(
    //     user.name ?? "dog",
    //     style: TextStyle(color: colorScheme.onPrimaryContainer),
    //   ),
    // );
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 1,right: 3,left: 3),
      color: colorScheme.primaryContainer,
      child: Container(
        padding: const EdgeInsets.only(left: 5,right: 5,bottom: 1),
        child: Text(
          "@${user.name??"路由器"}",
          style: TextStyle(color: colorScheme.onPrimaryContainer,fontSize: 13),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  @override
  WidgetSpan buildWidgetSpan(Widget widget) {
    return WidgetSpan(child: widget,alignment: PlaceholderAlignment.middle);
  }

  @override
  bool get expanded => false;
}

//连接嵌入块和按钮
class MyAtBlockEmbed extends CustomBlockEmbed {
  MyAtBlockEmbed(String value) : super(embedType, value);

  static const String embedType = "at";

  //根据document生成BlockEmbed
  static MyAtBlockEmbed fromDocument(Document document) => MyAtBlockEmbed(jsonEncode(document.toDelta().toJson()));

  Document get document => Document.fromJson(jsonDecode(data));
}

//嵌入块触发按钮
class MyAtEmbedButton extends StatelessWidget {
  const MyAtEmbedButton({
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
      icon: SvgPicture.asset(
        "assets/icons/aite.svg",
        height: 20,
        width: 20,
        colorFilter: ColorFilter.mode(iconColor!, BlendMode.srcIn),
      ),
      highlightElevation: 0,
      hoverElevation: 0,
      size: iconSize * 1.77,
      fillColor: iconFillColor,
      borderRadius: iconTheme?.borderRadius ?? 2,
      onPressed: () => _onPressedHandler(context),
    );
  }

  Future<void> _onPressedHandler(BuildContext context) async {
    //调用submitted()方法
    String? userJson;
    if (Responsive.isSmall(context)) {
      userJson = await showModalBottomSheet<String>(
          context: context,
          builder: (BuildContext context) {
            return const UserSelectorPage();
          });
    } else {
      userJson = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.background,
            contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
            content: const SizedBox(
              height: 150,
              child: UserSelectorPage(),
            ),
          );
        },
      );
    }

    _submitted(userJson);
  }

  //将连接替换进去
  void _submitted(String? userJson) {
    if (userJson != null) {
      final index = controller.selection.baseOffset;
      final end = controller.selection.extentOffset;

      var block = MyAtBlockEmbed(userJson);
      //添加at
      controller.replaceText(index, 0, block, null);
      //移动光标
      controller.moveCursorToPosition(index+1);
    }
  }
}

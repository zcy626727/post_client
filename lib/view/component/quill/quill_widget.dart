import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:post_client/state/user_state.dart';
import 'package:provider/provider.dart';

class PostQuillToolBar extends StatelessWidget {
  const PostQuillToolBar({Key? key, required this.controller}) : super(key: key);

  final QuillController controller;

  @override
  Widget build(BuildContext context) {
    controller.formatText(0, 10000, ColorAttribute("white"));
    var colorScheme = Theme.of(context).colorScheme;
    return QuillToolbar.basic(
      showColorButton: false,
      controller: controller,
      showFontFamily: false,
      showFontSize: false,
      showSearchButton: false,
      iconTheme: QuillIconTheme(
        //选中字体颜色
        iconSelectedColor: colorScheme.onPrimary,
        //选中容器颜色
        iconSelectedFillColor: colorScheme.primary,
        //选中字体颜色
        iconUnselectedColor: colorScheme.onPrimaryContainer,
        //未选中容器颜色
        iconUnselectedFillColor: colorScheme.primaryContainer,
        //不可用字体颜色
        disabledIconColor: Colors.grey,
        //不可用容器颜色
        disabledIconFillColor: colorScheme.primaryContainer,
      ),
      dialogTheme: QuillDialogTheme(
        labelTextStyle: TextStyle(color: colorScheme.onSurface),
        dialogBackgroundColor: colorScheme.surface,
        inputTextStyle: TextStyle(color: colorScheme.onSurface),
      ),
      toolbarSectionSpacing: 6,
      // embedButtons: FlutterQuillEmbeds.buttons(),
      // embedButtons: MyMediaQuillEmbeds.buttons(showImageButton: false),
    );
  }
}

class ArticleQuillToolBar extends StatelessWidget {
  const ArticleQuillToolBar({Key? key, required this.controller}) : super(key: key);

  final QuillController controller;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return QuillToolbar.basic(
      showColorButton: false,
      controller: controller,
      showFontFamily: false,
      showFontSize: false,
      showSearchButton: false,
      iconTheme: QuillIconTheme(
        //选中字体颜色
        iconSelectedColor: colorScheme.onPrimary,
        //选中容器颜色
        iconSelectedFillColor: colorScheme.primary,
        //选中字体颜色
        iconUnselectedColor: colorScheme.onPrimaryContainer,
        //未选中容器颜色
        iconUnselectedFillColor: colorScheme.primaryContainer,
        //不可用字体颜色
        disabledIconColor: Colors.grey,
        //不可用容器颜色
        disabledIconFillColor: colorScheme.primaryContainer,
      ),
      dialogTheme: QuillDialogTheme(
        labelTextStyle: TextStyle(color: colorScheme.onSurface),
        dialogBackgroundColor: colorScheme.surface,
        inputTextStyle: TextStyle(color: colorScheme.onSurface),
      ),
      toolbarSectionSpacing: 6,
      // embedButtons: FlutterQuillEmbeds.buttons(),
      // embedButtons: MyMediaQuillEmbeds.buttons(),
    );
  }
}

class CommentQuillToolBar extends StatelessWidget {
  const CommentQuillToolBar({Key? key, required this.controller}) : super(key: key);

  final QuillController controller;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return QuillToolbar.basic(
      showColorButton: false,
      controller: controller,
      showFontFamily: false,
      showFontSize: false,
      showSearchButton: false,
      showIndent: false,
      showBackgroundColorButton: false,
      showClearFormat: false,
      showHeaderStyle: false,
      showDividers: false,
      iconTheme: QuillIconTheme(
        //选中字体颜色
        iconSelectedColor: colorScheme.onPrimary,
        //选中容器颜色
        iconSelectedFillColor: colorScheme.primary,
        //选中字体颜色
        iconUnselectedColor: colorScheme.onPrimaryContainer,
        //未选中容器颜色
        iconUnselectedFillColor: colorScheme.primaryContainer,
        //不可用字体颜色
        disabledIconColor: Colors.grey,
        //不可用容器颜色
        disabledIconFillColor: colorScheme.primaryContainer,
      ),
      dialogTheme: QuillDialogTheme(
        labelTextStyle: TextStyle(color: colorScheme.onSurface),
        dialogBackgroundColor: colorScheme.surface,
        inputTextStyle: TextStyle(color: colorScheme.onSurface),
      ),
      toolbarSectionSpacing: 6,
      // embedButtons: FlutterQuillEmbeds.buttons(),
      // embedButtons: MyMediaQuillEmbeds.buttons(),
    );
  }
}

class CommonQuillEditor extends StatelessWidget {
  const CommonQuillEditor({Key? key, required this.controller, this.placeholder}) : super(key: key);

  final QuillController controller;

  final String? placeholder;

  @override
  Widget build(BuildContext context) {

    var colorScheme = Theme.of(context).colorScheme;

    // 设置DefaultTextStyle，调整亮暗模式
    return DefaultTextStyle(style: TextStyle(color: colorScheme.onSurface), child: QuillEditor(
      controller: controller,
      focusNode: FocusNode(),
      scrollController: ScrollController(),
      scrollable: true,
      padding: EdgeInsets.zero,
      showCursor: true,
      autoFocus: false,
      readOnly: false,
      expands: true,
      placeholder: placeholder,
      customStyles: DefaultStyles(),
      // embedBuilders: FlutterQuillEmbeds.builders(),
      // embedBuilders: MyMediaQuillEmbeds.builders(),
    ));
  }
}

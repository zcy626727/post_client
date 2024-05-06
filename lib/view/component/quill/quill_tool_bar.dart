import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:flutter_svg/svg.dart';

import '../../../util/responsive.dart';
import '../../page/mention/mention_selector_page.dart';
import 'embed/mention_embed.dart';

class CommonQuillToolBar extends StatelessWidget {
  const CommonQuillToolBar({Key? key, required this.controller}) : super(key: key);

  final QuillController controller;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return QuillToolbar.simple(
      configurations: QuillSimpleToolbarConfigurations(
          color: colorScheme.surface,
          controller: controller,
          showFontFamily: false,
          showFontSize: false,
          showSearchButton: false,
          showLink: false,
          showHeaderStyle: false,
          dialogTheme: QuillDialogTheme(
            labelTextStyle: TextStyle(color: colorScheme.onSurface),
            dialogBackgroundColor: colorScheme.surface,
            inputTextStyle: TextStyle(color: colorScheme.onSurface),
          ),
          multiRowsDisplay: false,
          // embedButtons: FlutterQuillEmbeds.toolbarButtons(),
          sharedConfigurations: const QuillSharedConfigurations(
            locale: Locale('en'),
          ),
          customButtons: [
            QuillToolbarCustomButtonOptions(
                icon: SvgPicture.asset(
                  "assets/icons/aite.svg",
                  height: 20,
                  width: 20,
                ),
                onPressed: () async {
                  //调用submitted()方法
                  await _mentionHandler(context);
                })
          ]),
    );
  }

  Future<void> _mentionHandler(BuildContext context) async {
    String? userJson;
    if (Responsive.isSmall(context)) {
      userJson = await showModalBottomSheet<String>(
          context: context,
          builder: (BuildContext context) {
            return const MentionSelectorPage();
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
              child: MentionSelectorPage(),
            ),
          );
        },
      );
    }
    if (userJson != null) {
      final index = controller.selection.baseOffset;
      final end = controller.selection.extentOffset;

      var block = MyAtBlockEmbed(userJson);
      //添加at
      controller.replaceText(index, 0, block, null);
      //移动光标
      controller.moveCursorToPosition(index + 1);
    }
  }
}

class PostQuillToolBar extends StatelessWidget {
  const PostQuillToolBar({Key? key, required this.controller}) : super(key: key);

  final QuillController controller;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return QuillToolbar.simple(
      configurations: QuillSimpleToolbarConfigurations(
          color: colorScheme.surface,
          controller: controller,
          showFontFamily: false,
          showFontSize: false,
          showSearchButton: false,
          showLink: false,
          showHeaderStyle: false,
          dialogTheme: QuillDialogTheme(
            labelTextStyle: TextStyle(color: colorScheme.onSurface),
            dialogBackgroundColor: colorScheme.surface,
            inputTextStyle: TextStyle(color: colorScheme.onSurface),
          ),
          multiRowsDisplay: false,
          embedButtons: FlutterQuillEmbeds.toolbarButtons(),
          sharedConfigurations: const QuillSharedConfigurations(
            locale: Locale('en'),
          ),
          customButtons: [
            QuillToolbarCustomButtonOptions(
                icon: SvgPicture.asset(
                  "assets/icons/aite.svg",
                  height: 20,
                  width: 20,
                ),
                onPressed: () async {
                  //调用submitted()方法
                  String? userJson;
                  if (Responsive.isSmall(context)) {
                    userJson = await showModalBottomSheet<String>(
                        context: context,
                        builder: (BuildContext context) {
                          return const MentionSelectorPage();
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
                            child: MentionSelectorPage(),
                          ),
                        );
                      },
                    );
                  }
                  if (userJson != null) {
                    final index = controller.selection.baseOffset;
                    final end = controller.selection.extentOffset;

                    var block = MyAtBlockEmbed(userJson);
                    //添加at
                    controller.replaceText(index, 0, block, null);
                    //移动光标
                    controller.moveCursorToPosition(index + 1);
                  }
                })
          ]),
      // toolbarSectionSpacing: 5,
      // toolbarIconAlignment: WrapAlignment.start,
      // toolbarIconCrossAlignment: WrapCrossAlignment.center,
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
    return QuillToolbar.simple(
      configurations: QuillSimpleToolbarConfigurations(
        color: colorScheme.surface,
        showColorButton: false,
        controller: controller,
        showFontFamily: false,
        showFontSize: false,
        showSearchButton: false,
        // iconTheme: QuillIconTheme(
        //   //选中字体颜色
        //   iconSelectedColor: colorScheme.onPrimary,
        //   //选中容器颜色
        //   iconSelectedFillColor: colorScheme.primary,
        //   //选中字体颜色
        //   iconUnselectedColor: colorScheme.onPrimaryContainer,
        //   //未选中容器颜色
        //   iconUnselectedFillColor: colorScheme.primaryContainer,
        //   //不可用字体颜色
        //   disabledIconColor: Colors.grey,
        //   //不可用容器颜色
        //   disabledIconFillColor: colorScheme.primaryContainer,
        // ),
        dialogTheme: QuillDialogTheme(
          labelTextStyle: TextStyle(color: colorScheme.onSurface),
          dialogBackgroundColor: colorScheme.surface,
          inputTextStyle: TextStyle(color: colorScheme.onSurface),
        ),
        multiRowsDisplay: false,
        toolbarSectionSpacing: 6,
        // embedButtons: ArticleQuillEmbeds.buttons(),
        sharedConfigurations: const QuillSharedConfigurations(
          locale: Locale('en'),
        ),
      ),

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
    return QuillToolbar.simple(
      configurations: QuillSimpleToolbarConfigurations(
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
        // iconTheme: QuillIconTheme(
        //   //选中字体颜色
        //   iconSelectedColor: colorScheme.onPrimary,
        //   //选中容器颜色
        //   iconSelectedFillColor: colorScheme.primary,
        //   //选中字体颜色
        //   iconUnselectedColor: colorScheme.onPrimaryContainer,
        //   //未选中容器颜色
        //   iconUnselectedFillColor: colorScheme.primaryContainer,
        //   //不可用字体颜色
        //   disabledIconColor: Colors.grey,
        //   //不可用容器颜色
        //   disabledIconFillColor: colorScheme.primaryContainer,
        // ),
        dialogTheme: QuillDialogTheme(
          labelTextStyle: TextStyle(color: colorScheme.onSurface),
          dialogBackgroundColor: colorScheme.surface,
          inputTextStyle: TextStyle(color: colorScheme.onSurface),
        ),
        toolbarSectionSpacing: 6,
        // embedButtons: FlutterQuillEmbeds.buttons(),
        // embedButtons: MyMediaQuillEmbeds.buttons(),
      ),
    );
  }
}

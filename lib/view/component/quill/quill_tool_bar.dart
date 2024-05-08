import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
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
          // embedButtons: FlutterQuillEmbeds.toolbarButtons(),
          // 自定义按钮
          customButtons: [
            // @ 按钮
            QuillToolbarCustomButtonOptions(
              icon: SvgPicture.asset("assets/icons/aite.svg", height: 25, width: 25),
              onPressed: () async {
                await _mentionHandler(context);
              },
            ),
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
      controller.document.insert(
        controller.selection.extentOffset,
        MyAtBlockEmbed(userJson),
      );

      controller.updateSelection(
        TextSelection.collapsed(
          offset: controller.selection.extentOffset + 1,
        ),
        ChangeSource.local,
      );
    }
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';

import '../../state/user_state.dart';

class QuillText extends StatelessWidget {
  const QuillText({Key? key, required this.quillController}) : super(key: key);

  final QuillController quillController;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Selector<UserState, UserState>(
      selector: (context, userState) => userState,
      builder: (context, userState, index) {
        if (userState.currentMode == ThemeMode.dark) {
          quillController.formatText(1, 3, const ColorAttribute("white"));
        } else {
          quillController.formatText(1, 3, const ColorAttribute("black"));
        }
        quillController.readOnly = true;
        return Column(
          children: [
            DefaultTextStyle(
              style: TextStyle(
                color: colorScheme.onSurface,
              ),
              child: QuillEditor(
                focusNode: FocusNode(),
                scrollController: ScrollController(),
                configurations: QuillEditorConfigurations(
                  scrollable: true,
                  padding: EdgeInsets.zero,
                  autoFocus: false,
                  showCursor: false,
                  expands: false,
                  // embedBuilders: ArticleQuillEmbeds.builders(),
                  controller: quillController,
                  // customStyles:
                  //     DefaultStyles(small: const TextStyle(color: )),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

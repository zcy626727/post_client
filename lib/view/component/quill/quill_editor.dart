import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class CommonQuillEditor extends StatelessWidget {
  const CommonQuillEditor({
    super.key,
    required this.controller,
    this.maxHeight,
    this.minHeight,
    this.placeholder,
    required this.focusNode,
    this.autoFocus = false,
    this.onTap,
  });

  final QuillController controller;
  final double? maxHeight;
  final double? minHeight;
  final String? placeholder;
  final FocusNode focusNode;
  final Function? onTap;
  final bool autoFocus;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return DefaultTextStyle(
      style: TextStyle(color: colorScheme.onSurface),
      child: QuillEditor(
        configurations: QuillEditorConfigurations(
          maxHeight: maxHeight,
          minHeight: minHeight,
          detectWordBoundary: false,
          controller: controller,
          scrollable: !controller.readOnly,
          padding: EdgeInsets.zero,
          showCursor: !controller.readOnly,
          autoFocus: autoFocus,
          onTapDown: (TapDownDetails details, position) {
            if (onTap != null) {
              onTap!();
            }
            return false;
          },
          expands: false,
          placeholder: placeholder,
          // embedBuilders: [...(kIsWeb ? FlutterQuillEmbeds.editorWebBuilders() : FlutterQuillEmbeds.editorBuilders()), MyMentionEmbedBuilder()],
          sharedConfigurations: const QuillSharedConfigurations(
            locale: Locale('en'),
          ),
        ),
        focusNode: focusNode,
        scrollController: ScrollController(),
      ),
    );
  }
}

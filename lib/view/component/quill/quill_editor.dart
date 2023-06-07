import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import 'media_quill_embeds.dart';

class PostQuillEditor extends StatelessWidget {
  const PostQuillEditor({Key? key, required this.controller, this.placeholder}) : super(key: key);

  final QuillController controller;

  final String? placeholder;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    // 设置DefaultTextStyle，调整亮暗模式
    return DefaultTextStyle(
      style: TextStyle(color: colorScheme.onSurface),
      child: QuillEditor(
        enableUnfocusOnTapOutside: false,
        detectWordBoundary: false,
        controller: controller,
        focusNode: FocusNode(),
        scrollController: ScrollController(),
        scrollable: true,
        padding: EdgeInsets.zero,
        showCursor: true,
        autoFocus: false,
        readOnly: false,
        expands: false,
        placeholder: placeholder,
        embedBuilders: PostQuillEmbeds.builders(),
        // embedBuilders: MyMediaQuillEmbeds.builders(),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

import 'media_quill_embeds.dart';

class PostQuillEditor extends StatelessWidget {
  const PostQuillEditor({
    Key? key,
    required this.controller,
    this.placeholder,
    this.maxHeight,
    this.minHeight,
    required this.focusNode,
    this.readMode = false,
  }) : super(key: key);

  final QuillController controller;
  final double? maxHeight;
  final double? minHeight;

  final String? placeholder;

  final FocusNode focusNode;
  final bool readMode;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    // 设置DefaultTextStyle，调整亮暗模式
    return DefaultTextStyle(
      style: TextStyle(color: colorScheme.onSurface),
      child: QuillEditor(
        locale: const Locale('en'),
        maxHeight: maxHeight,
        minHeight: minHeight,
        enableUnfocusOnTapOutside: false,
        detectWordBoundary: false,
        controller: controller,
        focusNode: focusNode,
        scrollController: ScrollController(),
        scrollable: !readMode,
        padding: EdgeInsets.zero,
        showCursor: !readMode,
        autoFocus: !readMode,
        readOnly: readMode,
        expands: false,
        placeholder: placeholder,
        embedBuilders: PostQuillEmbeds.builders(),
      ),
    );
  }
}

class ArticleQuillEditor extends StatelessWidget {
  const ArticleQuillEditor({Key? key, required this.controller, this.placeholder, this.maxHeight, this.minHeight, required this.focusNode}) : super(key: key);

  final QuillController controller;
  final double? maxHeight;
  final double? minHeight;

  final String? placeholder;

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    // 设置DefaultTextStyle，调整亮暗模式
    return DefaultTextStyle(
      style: TextStyle(color: colorScheme.onSurface),
      child: QuillEditor(
        locale: const Locale('en'),
        maxHeight: maxHeight,
        minHeight: minHeight,
        enableUnfocusOnTapOutside: false,
        detectWordBoundary: false,
        controller: controller,
        focusNode: focusNode,
        scrollController: ScrollController(),
        scrollable: true,
        padding: EdgeInsets.zero,
        showCursor: true,
        autoFocus: false,
        readOnly: false,
        expands: false,
        placeholder: placeholder,
        embedBuilders: ArticleQuillEmbeds.builders(),
      ),
    );
  }
}

class CommentQuillEditor extends StatelessWidget {
  const CommentQuillEditor({
    Key? key,
    required this.controller,
    this.placeholder,
    this.maxHeight,
    this.minHeight,
    required this.focusNode,
    this.readOnly = false,
    this.onTap, required this.autoFocus,
  }) : super(key: key);

  final Function? onTap;
  final QuillController controller;
  final double? maxHeight;
  final double? minHeight;

  final String? placeholder;

  final FocusNode focusNode;
  final bool readOnly;
  final bool autoFocus;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    // 设置DefaultTextStyle，调整亮暗模式
    return DefaultTextStyle(
      style: TextStyle(color: colorScheme.onSurface),
      child: QuillEditor(
        locale: const Locale('en'),
        maxHeight: maxHeight,
        minHeight: minHeight,
        enableUnfocusOnTapOutside: false,
        detectWordBoundary: false,
        controller: controller,
        focusNode: focusNode,
        scrollController: ScrollController(),
        scrollable: !readOnly,
        padding: EdgeInsets.zero,
        showCursor: !readOnly,
        autoFocus: autoFocus,
        readOnly: readOnly,
        expands: false,
        onTapDown: (TapDownDetails details, position) {
          if(onTap!=null){
            onTap!();
          }
          return false;
        },
        placeholder: placeholder,
        embedBuilders: PostQuillEmbeds.builders(),
      ),
    );
  }
}

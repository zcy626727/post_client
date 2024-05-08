import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_embeds.dart';
import 'package:post_client/view/component/quill/embed/mention_embed.dart';

class CommonQuillEditor extends StatelessWidget {
  const CommonQuillEditor({
    super.key,
    required this.controller,
    this.maxHeight,
    this.minHeight,
    this.placeholder,
    required this.focusNode,
    required this.autoFocus,
  });

  final QuillController controller;
  final double? maxHeight;
  final double? minHeight;
  final String? placeholder;
  final FocusNode focusNode;
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
          expands: false,
          placeholder: placeholder,
          embedBuilders: [...(kIsWeb ? FlutterQuillEmbeds.editorWebBuilders() : FlutterQuillEmbeds.editorBuilders()), MyMentionEmbedBuilder()],
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

class PostQuillEditor extends StatelessWidget {
  const PostQuillEditor({
    Key? key,
    required this.controller,
    this.placeholder,
    this.maxHeight,
    this.minHeight,
    required this.focusNode,
    this.autoFocus = false,
  }) : super(key: key);

  final QuillController controller;
  final double? maxHeight;
  final double? minHeight;

  final String? placeholder;

  final FocusNode focusNode;
  final bool autoFocus;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    // 设置DefaultTextStyle，调整亮暗模式
    // var builders = PostQuillEmbeds.builders();
    // builders.addAll(FlutterQuillEmbeds.editorWebBuilders());
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
          expands: false,
          placeholder: placeholder,
          // embedBuilders: PostQuillEmbeds.builders(),
          // embedBuilders: kIsWeb ? FlutterQuillEmbeds.editorWebBuilders() : FlutterQuillEmbeds.editorBuilders(),
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

class ArticleQuillEditor extends StatelessWidget {
  const ArticleQuillEditor({
    Key? key,
    required this.controller,
    this.placeholder,
    this.maxHeight,
    this.minHeight,
    required this.focusNode,
  }) : super(key: key);

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
        configurations: QuillEditorConfigurations(
          maxHeight: maxHeight,
          minHeight: minHeight,
          detectWordBoundary: false,
          controller: controller,
          scrollable: true,
          padding: EdgeInsets.zero,
          showCursor: !controller.readOnly,
          autoFocus: false,
          expands: false,
          placeholder: placeholder,
          // embedBuilders: ArticleQuillEmbeds.builders(),
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

class CommentQuillEditor extends StatelessWidget {
  const CommentQuillEditor({
    Key? key,
    required this.controller,
    this.placeholder,
    this.maxHeight,
    this.minHeight,
    required this.focusNode,
    this.onTap,
    required this.autoFocus,
  }) : super(key: key);

  final Function? onTap;
  final QuillController controller;
  final double? maxHeight;
  final double? minHeight;

  final String? placeholder;

  final FocusNode focusNode;
  final bool autoFocus;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    // 设置DefaultTextStyle，调整亮暗模式
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
          expands: false,
          onTapDown: (TapDownDetails details, position) {
            if (onTap != null) {
              onTap!();
            }
            return false;
          },
          placeholder: placeholder,
          // embedBuilders: PostQuillEmbeds.builders(),
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

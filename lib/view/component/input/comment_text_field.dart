import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:post_client/view/component/quill/quill_editor.dart';

class CommentTextField extends StatefulWidget {
  const CommentTextField({Key? key, required this.controller, required this.focusNode, required this.onSubmit}) : super(key: key);
  final QuillController controller;
  final FocusNode focusNode;
  final Function onSubmit;

  @override
  State<CommentTextField> createState() => _CommentTextFieldState();
}

class _CommentTextFieldState extends State<CommentTextField> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
      color: colorScheme.surface,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 5),
              margin: const EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                color: colorScheme.background,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              child: CommonQuillEditor(
                controller: widget.controller,
                focusNode: widget.focusNode,
                maxHeight: 150,
                autoFocus: false,
              ),
            ),
          ),
          SizedBox(
            width: 80,
            height: 30,
            child: ElevatedButton(
              onPressed: () {
                widget.onSubmit();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(colorScheme.primary),
              ),
              child: Text(
                "发布",
                style: TextStyle(color: colorScheme.onPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

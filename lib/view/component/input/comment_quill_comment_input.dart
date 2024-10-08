import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:post_client/view/component/quill/quill_editor.dart';

class CommentQuillCommentInput extends StatefulWidget {
  const CommentQuillCommentInput({Key? key, required this.controller, required this.focusNode, required this.onSubmit}) : super(key: key);
  final QuillController controller;
  final FocusNode focusNode;
  final Function onSubmit;

  @override
  State<CommentQuillCommentInput> createState() => _CommentQuillCommentInputState();
}

class _CommentQuillCommentInputState extends State<CommentQuillCommentInput> {
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
            child: MaterialButton(
              onPressed: () {
                widget.onSubmit();
              },
              color: colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
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

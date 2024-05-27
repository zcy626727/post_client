import 'package:flutter/material.dart';

class CommentTextCommentInput extends StatefulWidget {
  const CommentTextCommentInput({
    Key? key,
    required this.controller,
    required this.focusNode,
    this.onSubmit,
  }) : super(key: key);
  final TextEditingController controller;
  final Function? onSubmit;
  final FocusNode focusNode;

  @override
  State<CommentTextCommentInput> createState() => _CommentQuillCommentInputState();
}

class _CommentQuillCommentInputState extends State<CommentTextCommentInput> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 40,
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
      color: colorScheme.surface,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                color: colorScheme.background,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              child: TextField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                onSubmitted: (v) async {
                  await _onSubmit();
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 12.0, right: 2, bottom: -3, top: 10),
                  border: OutlineInputBorder(
                    //添加边框
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 80,
            height: 30,
            child: ElevatedButton(
              onPressed: _onSubmit,
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

  Future<void> _onSubmit() async {
    if (widget.onSubmit != null) {
      await widget.onSubmit!(widget.controller.text);
    }
    widget.controller.clear();
    widget.focusNode.unfocus();
  }
}

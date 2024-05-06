import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:post_client/model/post/comment.dart';

import '../../page/comment/reply_page.dart';
import '../quill/quill_editor.dart';

class ReplyCommentListTile extends StatelessWidget {
  const ReplyCommentListTile({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var controller = QuillController.basic();

    if (comment.content != null) {
      controller.document = Document.fromJson(json.decode(comment.content!));
      controller.readOnly = true;
    }
    return Container(
      margin: const EdgeInsets.only(top: 2),
      color: colorScheme.surface,
      child: ListTile(
        horizontalTitleGap: 10,
        leading: ClipOval(
          child: Image.network(
            comment.user!.avatarUrl!,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),
        ),
        title: Container(
          margin: const EdgeInsets.only(top: 6),
          child: Text(
            comment.user!.name!,
            style: TextStyle(color: colorScheme.onSurface),
          ),
        ),
        subtitle: CommentQuillEditor(
          autoFocus: false,
          controller: controller,
          focusNode: FocusNode(),
        ),
        trailing: Container(
          width: 40,
          height: double.infinity,
          color: colorScheme.primaryContainer,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReplyPage(
                    comment: comment,
                    onDeleteComment: (comment) {},
                  ),
                ),
              );
            },
            child: Icon(
              Icons.arrow_forward_ios,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

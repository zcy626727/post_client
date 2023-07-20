import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:post_client/model/message/comment.dart';

class ReplyCommentListTile extends StatelessWidget {
  const ReplyCommentListTile({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var text = "";
    if (comment.content != null) {
      text = Document.fromJson(json.decode(comment.content!)).toPlainText();
      if (text.length > 30) {
        text = text.substring(30);
      }
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
        subtitle: Text(
          text,
          maxLines: 2,
          style: TextStyle(color: colorScheme.onSurface),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

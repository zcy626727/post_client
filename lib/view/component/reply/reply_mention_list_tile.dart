import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:post_client/model/message/comment.dart';
import 'package:post_client/model/message/mention.dart';

import '../../../model/message/post.dart';


class ReplyMentionListTile extends StatelessWidget {
  const ReplyMentionListTile({super.key, required this.mention});

  final Mention mention;
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    var source = mention.source;
    var text = "";
    if (source is Post) {
      if (source.content != null) {
        text = Document.fromJson(json.decode(source.content!)).toPlainText().substring(10);
      }
    } else if (source is Comment) {
      if (source.content != null) {
        text = Document.fromJson(json.decode(source.content!)).toPlainText().substring(10);
      }
    }
    return Container(
      margin: const EdgeInsets.only(top: 2),
      color: colorScheme.surface,
      child: ListTile(
        horizontalTitleGap: 10,
        leading:ClipOval(
          child: Image.network(
            source.user!.avatarUrl!,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),
        ),
        title: Container(
          margin: const EdgeInsets.only(top: 6),
          child: Text(source.user!.name!),
        ),
        subtitle: Text(
          text,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:post_client/constant/source.dart';
import 'package:post_client/model/message/comment.dart';
import 'package:post_client/model/message/mention.dart';
import 'package:post_client/view/widget/quill_text.dart';

import '../../../model/message/post.dart';
import '../../page/comment/reply_page.dart';
import '../quill/quill_editor.dart';

class ReplyMentionListTile extends StatelessWidget {
  const ReplyMentionListTile({super.key, required this.mention});

  final Mention mention;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    var source = mention.source;
    var controller = QuillController.basic();

    if (source is Post) {
      if (source.content != null) {
        controller.document = Document.fromJson(json.decode(source.content!));
      }
    } else if (source is Comment) {
      if (source.content != null) {
        controller.document = Document.fromJson(json.decode(source.content!));
      }
    }
    return Container(
      margin: const EdgeInsets.only(top: 2),
      color: colorScheme.surface,
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 8, right: 8),
        horizontalTitleGap: 10,
        leading: ClipOval(
          child: Image.network(
            mention.sourceUser!.avatarUrl!,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),
        ),
        title: Container(
          margin: const EdgeInsets.only(top: 6),
          child: Text(
            mention.sourceUser!.name!,
            style: TextStyle(color: colorScheme.onSurface),
          ),
        ),
        subtitle: CommentQuillEditor(
          autoFocus: false,
          controller: controller,
          focusNode: FocusNode(),
          readOnly: true,
        ),
        trailing: mention.sourceType == MentionSourceType.comment
            ? Container(
                width: 40,
                height: double.infinity,
                color: colorScheme.primaryContainer,
                child: TextButton(
                  onPressed: () {
                    var comment = mention.source;
                    if (comment is Comment) {
                      comment.user = mention.sourceUser;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReplyPage(
                            comment: comment,
                            onDeleteComment: (comment) {},
                          ),
                        ),
                      );
                    }
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: colorScheme.onSurface,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

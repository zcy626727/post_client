import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../../../../model/user/user.dart';

//连接嵌入块和按钮
class MyAtBlockEmbed extends CustomBlockEmbed {
  MyAtBlockEmbed(String value) : super(embedType, value);

  static const String embedType = "at";

  //根据document生成BlockEmbed
  static MyAtBlockEmbed fromDocument(Document document) => MyAtBlockEmbed(jsonEncode(document.toDelta().toJson()));

  Document get document => Document.fromJson(jsonDecode(data));
}

class MyMentionEmbedBuilder extends EmbedBuilder {
  MyMentionEmbedBuilder();

  @override
  String get key => MyAtBlockEmbed.embedType;

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    User user = User.fromJson(json.decode(node.value.data));

    var colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 1, right: 3, left: 3),
      color: colorScheme.primaryContainer,
      child: Container(
        padding: const EdgeInsets.only(left: 5, right: 5, bottom: 1),
        child: Text(
          "@${user.name ?? "路由器"}",
          style: TextStyle(color: colorScheme.onPrimaryContainer, fontSize: 13),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}




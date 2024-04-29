import 'package:flutter/material.dart';
import 'package:post_client/model/post/mention.dart';
import 'package:post_client/view/component/reply/reply_mention_list_tile.dart';

import '../../../service/post/mention_service.dart';
import '../../widget/common_item_list.dart';

class ReplyMentionListPage extends StatefulWidget {
  const ReplyMentionListPage({super.key});

  @override
  State<ReplyMentionListPage> createState() => _ReplyListPageState();
}

class _ReplyListPageState extends State<ReplyMentionListPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        toolbarHeight: 50,
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        leading: IconButton(
          splashRadius: 20,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: colorScheme.onBackground,
          ),
        ),
        title: Text(
          "@我",
          style: TextStyle(color: colorScheme.onSurface),
        ),
        actions: [],
      ),
      body: CommonItemList<Mention>(
        onLoad: (int page) async {
          var list = await MentionService.getReplyMentionList(0, 20);
          return list;
        },
        itemName: "回复",
        itemHeight: null,
        isGrip: false,
        enableScrollbar: true,
        itemBuilder: (ctx, mention, mentionList, onFresh) {
          return ReplyMentionListTile(mention: mention);
        },
      ),
    );
  }
}

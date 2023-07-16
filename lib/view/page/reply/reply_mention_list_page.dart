import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:post_client/model/comment.dart';
import 'package:post_client/model/mention.dart';
import 'package:post_client/model/post.dart';
import 'package:post_client/view/widget/quill_text.dart';

import '../../../service/mention_service.dart';

class ReplyMentionListPage extends StatefulWidget {
  const ReplyMentionListPage({super.key});

  @override
  State<ReplyMentionListPage> createState() => _ReplyListPageState();
}

class _ReplyListPageState extends State<ReplyMentionListPage> {
  late Future _futureBuilderFuture;

  List<Mention> _mentionList = <Mention>[];

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
  }

  Future getData() async {
    return Future.wait([getFolloweeList()]);
  }

  Future<void> getFolloweeList() async {
    try {
      var list = await MentionService.getReplyMentionList(0, 20);
      _mentionList.addAll(list);
    } on DioException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
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
            body: ListView.builder(
              itemCount: _mentionList.length,
              itemBuilder: (context, index) {
                var mention = _mentionList[index];
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

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(mention.sourceUser!.avatarUrl!),
                  ),
                  title: Text(mention.sourceUser!.name!),
                  subtitle: Text(
                    text,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          );
        }
      },
    );
  }
}

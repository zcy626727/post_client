import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:intl/intl.dart';
import 'package:post_client/service/media/history_service.dart';
import 'package:post_client/view/component/feedback/media_feedback_bar.dart';
import 'package:post_client/view/component/media/media_more_button.dart';
import 'package:post_client/view/component/quill/quill_editor.dart';

import '../../../constant/media.dart';
import '../../../model/media/article.dart';
import '../../../model/media/history.dart';
import '../../../model/message/comment.dart';
import '../../../service/media/article_service.dart';
import '../comment/comment_page.dart';

class ArticleDetailPage extends StatefulWidget {
  const ArticleDetailPage({super.key, required this.article, this.onDeleteMedia, this.onUpdateMedia});

  final Article article;
  final Function(Article)? onDeleteMedia;
  final Function(Article)? onUpdateMedia;

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  late Future _futureBuilderFuture;
  final QuillController controller = QuillController.basic();
  final FocusNode focusNode = FocusNode();

  late History history;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
  }

  Future getData() async {
    return Future.wait([getArticle(), getHistory()]);
  }

  Future<void> getArticle() async {
    try {
      var article = await ArticleService.getArticleById(widget.article.id!);

      //如果不存在则直接创建
      controller.document = Document.fromJson(json.decode(article.content ?? ""));
      widget.article.content = article.content;
    } on DioException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getHistory() async {
    try {
      //获取或创建历史
      history = await HistoryService.getOrCreateHistoryByMedia(widget.article.id!, MediaType.article);
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
                "文章",
                style: TextStyle(color: colorScheme.onSurface),
              ),
              actions: [
                MediaMoreButton(
                  media: widget.article,
                  onDeleteMedia: (media) {
                    Navigator.of(context).pop();
                    if (widget.onDeleteMedia != null) {
                      widget.onDeleteMedia!(media as Article);
                    }
                  },
                  onUpdateMedia: (media) {
                    widget.article.copyArticle(media as Article);
                    if (widget.onUpdateMedia != null) {
                      widget.onUpdateMedia!(media);
                    }
                    setState(() {});
                  },
                ),
              ],
            ),
            body: Container(
              color: colorScheme.surface,
              margin: const EdgeInsets.only(top: 1),
              padding: const EdgeInsets.only(left: 3, right: 3),
              child: ListView(
                children: [
                  if (widget.article.coverUrl != null && widget.article.coverUrl!.isNotEmpty) Image(image: NetworkImage(widget.article.coverUrl!)),
                  Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    child: Text(
                      widget.article.title!,
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
                    ),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.only(left: 3, right: 3),
                    visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                    leading: CircleAvatar(radius: 18, backgroundImage: NetworkImage(widget.article.user!.avatarUrl!)),
                    title: Text(
                      widget.article.title!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      DateFormat("yyyy-MM-dd").format(widget.article.createTime!),
                      style: TextStyle(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  buildText(),
                  MediaFeedbackBar(
                    mediaType: MediaType.article,
                    mediaId: widget.article.id!,
                    media: widget.article,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    height: 40,
                    color: colorScheme.primaryContainer,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommentPage(
                              commentParentType: CommentParentType.article,
                              commentParentId: widget.article.id!,
                              parentUserId: widget.article.userId!,
                            ),
                          ),
                        );
                      },
                      child: const Text("查看评论"),
                    ),
                  ),
                ],
              ),
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

  Widget buildText() {
    return Container(
      margin: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
      width: double.infinity,
      child: ArticleQuillEditor(
        controller: controller,
        focusNode: FocusNode(),
        readOnly: true,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

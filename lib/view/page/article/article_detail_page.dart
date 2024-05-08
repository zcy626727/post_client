import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import 'package:post_client/view/component/feedback/media_feedback_bar.dart';
import 'package:post_client/view/component/media/media_more_button.dart';
import 'package:post_client/view/component/quill/quill_editor.dart';
import 'package:post_client/view/page/album/album_in_media.dart';

import '../../../constant/source.dart';
import '../../../model/post/article.dart';
import '../../../model/post/comment.dart';
import '../../../model/post/history.dart';
import '../../../service/post/article_service.dart';
import '../../../service/post/history_service.dart';
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
  late Article article;

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
      article = await ArticleService.getArticleById(widget.article.id!);
      article.user = widget.article.user;
      //如果不存在则直接创建
      controller.document = Document.fromJson(json.decode(article.content ?? ""));
      controller.readOnly = true;
      article.content = article.content;
    } on DioException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getHistory() async {
    try {
      //获取或创建历史
      history = await HistoryService.getOrCreateHistoryByMedia(widget.article.id!, SourceType.article);
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
                  media: article,
                  onDeleteMedia: (media) {
                    Navigator.of(context).pop();
                    if (widget.onDeleteMedia != null) {
                      widget.onDeleteMedia!(media as Article);
                    }
                  },
                  onUpdateMedia: (media) {
                    article.copyArticle(media as Article);
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
                  if (article.coverUrl != null && article.coverUrl!.isNotEmpty)
                    Image(
                      height: 100,
                      image: NetworkImage(article.coverUrl!),
                      fit: BoxFit.cover,
                    ),
                  if (article.hasAlbum())
                    Container(
                      margin: const EdgeInsets.only(top: 2, bottom: 1),
                      child: AlbumInMedia(
                        albumId: article.albumId!,
                        onChangeMedia: (media) {
                          var newArticle = media as Article;
                          newArticle.user = article.user;
                          article = newArticle;
                          setState(() {});
                        },
                      ),
                    ),
                  Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    child: Text(
                      article.title!,
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
                    ),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.only(left: 3, right: 3),
                    visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                    leading: CircleAvatar(radius: 18, backgroundImage: NetworkImage(article.user!.avatarUrl!)),
                    title: Text(
                      article.title!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      DateFormat("yyyy-MM-dd").format(article.createTime!),
                      style: TextStyle(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  buildText(),
                  MediaFeedbackBar(
                    mediaType: SourceType.article,
                    mediaId: article.id!,
                    media: article,
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
                              commentParentId: article.id!,
                              parentUserId: article.userId!,
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
      child: CommonQuillEditor(
        controller: controller,
        focusNode: FocusNode(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

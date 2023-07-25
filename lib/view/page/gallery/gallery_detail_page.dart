import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:post_client/constant/media.dart';
import 'package:post_client/model/media/gallery.dart';
import 'package:post_client/view/page/comment/comment_page.dart';

import '../../../model/media/history.dart';
import '../../../model/message/comment.dart';
import '../../../service/media/history_service.dart';
import '../../component/feedback/media_feedback_bar.dart';
import '../../component/media/media_more_button.dart';

class GalleryDetailPage extends StatefulWidget {
  const GalleryDetailPage({super.key, required this.gallery, this.onDeleteMedia, this.onUpdateMedia});

  final Gallery gallery;
  final Function(Gallery)? onDeleteMedia;
  final Function(Gallery)? onUpdateMedia;

  @override
  State<GalleryDetailPage> createState() => _GalleryDetailPageState();
}

class _GalleryDetailPageState extends State<GalleryDetailPage> {
  late Future _futureBuilderFuture;
  late History history;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
  }

  Future getData() async {
    return Future.wait([getHistory()]);
  }

  Future<void> getHistory() async {
    try {
      //获取或创建历史
      history = await HistoryService.getOrCreateHistoryByMedia(widget.gallery.id!, MediaType.gallery);
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
                "图片",
                style: TextStyle(color: colorScheme.onSurface),
              ),
              actions: [
                MediaMoreButton(
                  media: widget.gallery,
                  onDeleteMedia: (media) {
                    Navigator.of(context).pop();
                    if (widget.onDeleteMedia != null) {
                      widget.onDeleteMedia!(media as Gallery);
                    }
                  },
                  onUpdateMedia: (media) {
                    widget.gallery.copyGallery(media as Gallery);
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
              padding: const EdgeInsets.only(left: 3, right: 3, top: 1),
              child: ListView(
                children: [
                  ...List<Image>.generate(widget.gallery.thumbnailUrlList!.length, (index) {
                    return Image(
                      image: NetworkImage(widget.gallery.thumbnailUrlList![index]),
                      fit: BoxFit.fitWidth,
                    );
                  }),
                  ListTile(
                    contentPadding: const EdgeInsets.only(left: 3, right: 3),
                    visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                    leading: CircleAvatar(radius: 18, backgroundImage: NetworkImage(widget.gallery.user!.avatarUrl!)),
                    title: Text(
                      widget.gallery.title!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      DateFormat("yyyy-MM-dd").format(widget.gallery.createTime!),
                      style: TextStyle(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Text(
                      widget.gallery.introduction!,
                      style: TextStyle(fontSize: 15, color: colorScheme.onSurface),
                    ),
                  ),
                  MediaFeedbackBar(
                    mediaType: MediaType.gallery,
                    mediaId: widget.gallery.id!,
                    media: widget.gallery,
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
                                    commentParentType: CommentParentType.gallery,
                                    commentParentId: widget.gallery.id!,
                                    parentUserId: widget.gallery.userId!,
                                  )),
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
}

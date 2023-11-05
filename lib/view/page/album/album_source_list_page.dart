import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:post_client/config/page_config.dart';
import 'package:post_client/constant/media.dart';
import 'package:post_client/constant/source.dart';
import 'package:post_client/model/favorites.dart';
import 'package:post_client/model/media/album.dart';
import 'package:post_client/model/media/article.dart';
import 'package:post_client/model/media/audio.dart';
import 'package:post_client/model/media/gallery.dart';
import 'package:post_client/model/media/video.dart';
import 'package:post_client/model/message/feed_feedback.dart';
import 'package:post_client/service/media/album_service.dart';
import 'package:post_client/service/media/gallery_service.dart';
import 'package:post_client/service/media/media_service.dart';
import 'package:post_client/service/message/feed_service.dart';
import 'package:post_client/view/component/comment/comment_list_tile.dart';
import 'package:post_client/view/page/album/album_edit_page.dart';

import '../../../config/global.dart';
import '../../../model/message/comment.dart';
import '../../../model/message/post.dart';
import '../../component/media/list/article_list_tile.dart';
import '../../component/media/list/audio_list_tile.dart';
import '../../component/media/list/gallery_list_tile.dart';
import '../../component/media/list/video_list_tile.dart';
import '../../component/post/post_list_tile.dart';
import '../../component/show/show_snack_bar.dart';
import '../../widget/dialog/confirm_alert_dialog.dart';
import '../comment/reply_page.dart';

class AlbumSourceListPage extends StatefulWidget {
  const AlbumSourceListPage({super.key, required this.album, this.onDelete});

  final Album album;
  final Function(Album)? onDelete;

  @override
  State<AlbumSourceListPage> createState() => _AlbumSourceListPageState();
}

class _AlbumSourceListPageState extends State<AlbumSourceListPage> {
  late Future _futureBuilderFuture;
  List<Audio> audioList = [];
  List<Video> videoList = [];
  List<Gallery> galleryList = [];
  List<Article> articleList = [];

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
  }

  Future getData() async {
    return Future.wait([getDataList()]);
  }

  Future<void> getDataList() async {
    try {
      switch (widget.album.mediaType) {
        case MediaType.gallery:
          galleryList = await GalleryService.getGalleryListByAlbumId(albumUserId: widget.album.userId!, albumId: widget.album.id!, pageSize: PageConfig.commonPageSize);
        case MediaType.audio:
        case MediaType.video:
        case MediaType.article:
      }
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
                '合集：${widget.album.title ?? "未知名称"}',
                style: TextStyle(color: colorScheme.onSurface),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 5),
                  child: PopupMenuButton<String>(
                    splashRadius: 20,
                    itemBuilder: (BuildContext context) {
                      return [
                        if (Global.user.id == widget.album.userId)
                          PopupMenuItem(
                            height: 35,
                            value: 'delete',
                            child: Text(
                              '删除',
                              style: TextStyle(color: colorScheme.onBackground.withAlpha(200), fontSize: 14),
                            ),
                          ),
                        if (Global.user.id == widget.album.userId)
                          PopupMenuItem(
                            height: 35,
                            value: 'edit',
                            child: Text(
                              '编辑',
                              style: TextStyle(color: colorScheme.onBackground.withAlpha(200), fontSize: 14),
                            ),
                          ),
                      ];
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        width: 1,
                        color: colorScheme.onSurface.withAlpha(30),
                        style: BorderStyle.solid,
                      ),
                    ),
                    color: colorScheme.surface,
                    onSelected: (value) async {
                      switch (value) {
                        case "delete":
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ConfirmAlertDialog(
                                text: "是否确定删除？",
                                onConfirm: () async {
                                  try {
                                    await AlbumService.deleteUserAlbumById(widget.album.id!);
                                    if (widget.onDelete != null) {
                                      widget.onDelete!(widget.album);
                                    }
                                  } on DioException catch (e) {
                                    if (mounted) ShowSnackBar.exception(context: context, e: e, defaultValue: "删除失败");
                                  } finally {
                                    if (mounted) Navigator.pop(context);
                                  }
                                },
                                onCancel: () {
                                  Navigator.pop(context);
                                },
                              );
                            },
                          );
                          break;
                        case "edit":
                          if (mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AlbumEditPage(
                                  album: widget.album,
                                ),
                              ),
                            );
                          }
                          break;
                      }
                    },
                    child: Icon(Icons.more_horiz, color: colorScheme.onSurface),
                  ),
                )
              ],
            ),
            body: Container(
              color: colorScheme.background,
              child: buildSourceList(),
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

  Widget buildSourceList() {
    switch (widget.album.mediaType) {
      case MediaType.gallery:
        return GridView.builder(
          controller: ScrollController(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            //长宽比例
            childAspectRatio: 1,
            //主轴距离
            mainAxisSpacing: 5.0,
            //辅轴距离
            crossAxisSpacing: 5.0,
          ),
          itemBuilder: (ctx, index) {
            var source = galleryList[index];
            return GalleryListTile(
              key: ValueKey(source.id),
              gallery: source,
              onUpdateMedia: (a) {
                source.copyGallery(a);
                setState(() {});
              },
              onDeleteMedia: (a) {
                videoList.remove(source);
                setState(() {});
              },
            );
          },
          itemCount: galleryList.length,
        );
      case MediaType.audio:
        return ListView.builder(
          itemBuilder: (ctx, index) {
            var source = audioList[index];
            return AudioListTile(
              key: ValueKey(source.id),
              audio: source,
              onUpdateMedia: (a) {
                source.copyAudio(a);
                setState(() {});
              },
              onDeleteMedia: (a) {
                videoList.remove(source);
                setState(() {});
              },
            );
          },
          itemCount: audioList.length,
        );
      case MediaType.video:
        return ListView.builder(
          itemBuilder: (ctx, index) {
            var source = videoList[index];
            return VideoListTile(
              key: ValueKey(source.id),
              video: source,
              onUpdateMedia: (a) {
                source.copyGallery(a);
                setState(() {});
              },
              onDeleteMedia: (a) {
                videoList.remove(source);
                setState(() {});
              },
            );
          },
          itemCount: videoList.length,
        );
      case MediaType.article:
        return ListView.builder(
            itemBuilder: (ctx, index) {
              var source = articleList[index];
              return ArticleListTile(
                key: ValueKey(source.id),
                article: source,
                onUpdateMedia: (a) {
                  source.copyArticle(a);
                  setState(() {});
                },
                onDeleteMedia: (a) {
                  articleList.remove(a);
                  setState(() {});
                },
              );
            },
            itemCount: articleList.length);
      default:
        return const Center(
          child: Text("未知类型"),
        );
    }
  }
}

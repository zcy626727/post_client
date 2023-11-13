import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:post_client/config/page_config.dart';
import 'package:post_client/model/media/album.dart';
import 'package:post_client/service/media/album_service.dart';
import 'package:post_client/service/media/article_service.dart';
import 'package:post_client/service/media/audio_service.dart';
import 'package:post_client/service/media/gallery_service.dart';
import 'package:post_client/service/media/video_service.dart';
import 'package:post_client/view/page/album/album_edit_page.dart';
import 'package:post_client/view/page/list/common_source_list.dart';

import '../../../config/global.dart';
import '../../component/show/show_snack_bar.dart';
import '../../widget/dialog/confirm_alert_dialog.dart';

class AlbumSourceListPage extends StatefulWidget {
  const AlbumSourceListPage({super.key, required this.album, this.onDelete, this.onUpdate});

  final Album album;
  final Function(Album)? onDelete;
  final Function(Album)? onUpdate;

  @override
  State<AlbumSourceListPage> createState() => _AlbumSourceListPageState();
}

class _AlbumSourceListPageState extends State<AlbumSourceListPage> {
  late Future _futureBuilderFuture;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
  }

  Future getData() async {
    return Future.wait([getDataList()]);
  }

  Future<void> getDataList() async {
    try {} on DioException catch (e) {
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
                                  onUpdate: (a) {
                                    widget.album.copyAlbum(a);
                                    if (widget.onUpdate != null) {
                                      widget.onUpdate!(widget.album);
                                    }
                                    setState(() {});
                                  },
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
              child: CommonSourceList(
                mediaType: widget.album.mediaType,
                onLoadAudio: (pageIndex) async {
                  return await AudioService.getAudioListByAlbumId(
                    albumUserId: widget.album.userId!,
                    albumId: widget.album.id!,
                    pageSize: PageConfig.commonPageSize,
                    pageIndex: pageIndex,
                  );
                },
                onLoadVideo: (pageIndex) async {
                  return await VideoService.getVideoListByAlbumId(
                    albumUserId: widget.album.userId!,
                    albumId: widget.album.id!,
                    pageSize: PageConfig.commonPageSize,
                    pageIndex: pageIndex,
                  );
                },
                onLoadGallery: (pageIndex) async {
                  return await GalleryService.getGalleryListByAlbumId(
                    albumUserId: widget.album.userId!,
                    albumId: widget.album.id!,
                    pageIndex: pageIndex,
                    pageSize: PageConfig.commonPageSize,
                  );
                },
                onLoadArticle: (pageIndex) async {
                  return await ArticleService.getArticleListByAlbumId(
                    albumUserId: widget.album.userId!,
                    albumId: widget.album.id!,
                    pageIndex: pageIndex,
                    pageSize: PageConfig.commonPageSize,
                  );
                },
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

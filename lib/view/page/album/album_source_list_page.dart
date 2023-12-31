import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:post_client/config/page_config.dart';
import 'package:post_client/model/media/album.dart';
import 'package:post_client/model/media/follow_album.dart';
import 'package:post_client/service/media/album_service.dart';
import 'package:post_client/service/media/article_service.dart';
import 'package:post_client/service/media/audio_service.dart';
import 'package:post_client/service/media/follow_album_service.dart';
import 'package:post_client/service/media/gallery_service.dart';
import 'package:post_client/service/media/video_service.dart';
import 'package:post_client/util/entity_utils.dart';
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
  FollowAlbum? followAlbum;
  late Future _futureBuilderFuture;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
  }

  Future getData() async {
    return Future.wait([getFollowAlbum()]);
  }

  //获取合集关注情况
  Future<void> getFollowAlbum() async {
    try {
      if (widget.album.id != null) {
        followAlbum = await FollowAlbumService.getFollowAlbum(albumId: widget.album.id!);
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
            body: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverToBoxAdapter(
                    child: Container(
                      height: 100,
                      color: colorScheme.surface,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Row(
                        children: [
                          //图片
                          Container(
                            width: 150,
                            height: double.infinity,
                            color: colorScheme.primaryContainer,
                            child: widget.album.coverUrl != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image(
                                      image: NetworkImage(widget.album.coverUrl!),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Icon(
                                    Icons.album_outlined,
                                    size: 70,
                                    color: colorScheme.onPrimaryContainer,
                                  ),
                          ),
                          //
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //专辑标题
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.album.title ?? "已失效",
                                        style: TextStyle(
                                          color: colorScheme.onSurface.withAlpha(200),
                                          fontSize: 18,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(bottom: 5),
                                        child: Text(
                                          widget.album.introduction ?? "已失效",
                                          style: TextStyle(color: colorScheme.onSurface.withAlpha(170)),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  //用户
                                  if (widget.album.user != null)
                                    Row(
                                      children: [
                                        ClipOval(
                                          child: Image.network(
                                            widget.album.user!.avatarUrl!,
                                            width: 32,
                                            height: 32,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.album.user!.name ?? "未知用户",
                                              style: TextStyle(color: colorScheme.onSurface.withAlpha(200), fontSize: 12),
                                            ),
                                            Text(
                                              DateFormat("yyyy-MM-dd").format(widget.album.createTime!),
                                              style: TextStyle(color: colorScheme.onSurface.withAlpha(150), fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: Column(
                children: [
                  Container(
                    color: colorScheme.surface,
                    margin: const EdgeInsets.only(top: 1, bottom: 1),
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(onPressed: () {}, icon: const Icon(Icons.sort)),
                        Row(
                          children: [
                            IconButton(
                              color: (followAlbum == null || EntityUtil.idIsEmpty(followAlbum!.id)) ? null : Colors.red,
                              onPressed: () async {
                                try {
                                  if (followAlbum == null || EntityUtil.idIsEmpty(followAlbum!.id)) {
                                    //关注
                                    followAlbum = await FollowAlbumService.followAlbum(albumId: widget.album.id!, mediaType: widget.album.mediaType);
                                  } else {
                                    //取消关注
                                    await FollowAlbumService.unfollowAlbum(followAlbumId: followAlbum!.id!);
                                    followAlbum = null;
                                  }
                                  setState(() {});
                                } on Exception catch (e) {
                                  if (mounted) ShowSnackBar.exception(context: context, e: e, defaultValue: "操作失败");
                                }
                              },
                              icon: const Icon(Icons.folder_special),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
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

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:post_client/config/page_config.dart';
import 'package:post_client/model/post/favorites.dart';
import 'package:post_client/service/post/favorites_service.dart';
import 'package:post_client/service/post/follow_favorites_service.dart';
import 'package:post_client/view/page/favorites/favorites_edit_page.dart';

import '../../../config/global.dart';
import '../../../model/post/follow_favorites.dart';
import '../../../util/entity_utils.dart';
import '../../component/show/show_snack_bar.dart';
import '../../widget/dialog/confirm_alert_dialog.dart';
import '../list/common_source_list.dart';

class FavoritesSourceListPage extends StatefulWidget {
  const FavoritesSourceListPage({super.key, required this.favorites, this.onUpdate, this.onDelete});

  final Favorites favorites;

  final Function(Favorites)? onUpdate;
  final Function(Favorites)? onDelete;

  @override
  State<FavoritesSourceListPage> createState() => _FavoritesSourceListPageState();
}

class _FavoritesSourceListPageState extends State<FavoritesSourceListPage> {
  late Future _futureBuilderFuture;
  FollowFavorites? followFavorites;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
  }

  Future getData() async {
    return Future.wait([getFollowFavorites()]);
  }

  Future<void> getFollowFavorites() async {
    try {
      if (widget.favorites.id != null) {
        followFavorites = await FollowFavoritesService.getFollowFavorites(favoritesId: widget.favorites.id!, sourceType: widget.favorites.sourceType!);
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
                  margin: const EdgeInsets.only(right: 10),
                  child: PopupMenuButton<String>(
                    splashRadius: 20,
                    itemBuilder: (BuildContext context) {
                      return [
                        if (Global.user.id == widget.favorites.userId)
                          PopupMenuItem(
                            height: 35,
                            value: 'delete',
                            child: Text(
                              '删除',
                              style: TextStyle(color: colorScheme.onBackground.withAlpha(200), fontSize: 14),
                            ),
                          ),
                        if (Global.user.id == widget.favorites.userId)
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
                                    await FavoritesService.deleteUserFavoritesById(widget.favorites.id!, widget.favorites.sourceType!);
                                    if (widget.onDelete != null) {
                                      widget.onDelete!(widget.favorites);
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
                                builder: (context) => FavoritesEditPage(
                                  favorites: widget.favorites,
                                  onUpdate: (f) {
                                    widget.favorites.copyFavorites(f);
                                    if (widget.onUpdate != null) {
                                      widget.onUpdate!(widget.favorites);
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
                      width: double.infinity,
                      color: colorScheme.surface,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: widget.favorites.coverUrl != null && widget.favorites.coverUrl!.isNotEmpty
                                ? Image(
                                    height: 200,
                                    width: double.infinity,
                                    image: NetworkImage(widget.favorites.coverUrl!),
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    color: colorScheme.primaryContainer,
                                    height: 200,
                                    width: double.infinity,
                                    child: Icon(
                                      Icons.album_outlined,
                                      size: 70,
                                      color: colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Text(
                              widget.favorites.title ?? "未知名称",
                              maxLines: 1,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: colorScheme.onSurface.withAlpha(200)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              "${widget.favorites.introduction}",
                              style: TextStyle(color: colorScheme.onSurface.withAlpha(170)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
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
                        // IconButton(splashRadius: 10, onPressed: () {}, icon: const Icon(Icons.sort)),
                        const SizedBox(),
                        Row(
                          children: [
                            IconButton(
                              color: (followFavorites == null || EntityUtil.idIsEmpty(followFavorites!.id)) ? null : Colors.red,
                              splashRadius: 5,
                              onPressed: () async {
                                try {
                                  if (followFavorites == null || EntityUtil.idIsEmpty(followFavorites!.id)) {
                                    //关注
                                    followFavorites = await FollowFavoritesService.followFavorites(favoritesId: widget.favorites.id!, sourceType: widget.favorites.sourceType!);
                                  } else {
                                    //取消关注
                                    await FollowFavoritesService.unfollowFavorites(followFavoritesId: followFavorites!.id!, sourceType: widget.favorites.sourceType!);
                                    followFavorites = null;
                                  }
                                  setState(() {});
                                } on Exception catch (e) {
                                  if (mounted) ShowSnackBar.exception(context: context, e: e, defaultValue: "操作失败");
                                }
                              },
                              icon: const Icon(Icons.folder_special),
                            ),

                            // IconButton(splashRadius: 10, onPressed: () {}, icon: const Icon(Icons.folder_special)),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: CommonSourceList(
                      sourceType: widget.favorites.sourceType,
                      onLoadPost: (pageIndex) async {
                        var result = await FavoritesService.getSourceListByFavoritesId(favoritesId: widget.favorites.id!, pageIndex: pageIndex, pageSize: PageConfig.commonPageSize);
                        return result.$1;
                      },
                      onLoadComment: (pageIndex) async {
                        var result = await FavoritesService.getSourceListByFavoritesId(favoritesId: widget.favorites.id!, pageIndex: pageIndex, pageSize: PageConfig.commonPageSize);
                        return result.$2;
                      },
                      onLoadAudio: (pageIndex) async {
                        var result = await FavoritesService.getSourceListByFavoritesId(favoritesId: widget.favorites.id!, pageIndex: pageIndex, pageSize: PageConfig.commonPageSize);
                        return result.$4;
                      },
                      onLoadVideo: (pageIndex) async {
                        var result = await FavoritesService.getSourceListByFavoritesId(favoritesId: widget.favorites.id!, pageIndex: pageIndex, pageSize: PageConfig.commonPageSize);
                        return result.$6;
                      },
                      onLoadGallery: (pageIndex) async {
                        var result = await FavoritesService.getSourceListByFavoritesId(favoritesId: widget.favorites.id!, pageIndex: pageIndex, pageSize: PageConfig.commonPageSize);
                        return result.$5;
                      },
                      onLoadArticle: (pageIndex) async {
                        var result = await FavoritesService.getSourceListByFavoritesId(favoritesId: widget.favorites.id!, pageIndex: pageIndex, pageSize: PageConfig.commonPageSize);
                        return result.$3;
                      },
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

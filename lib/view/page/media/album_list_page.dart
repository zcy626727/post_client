import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:post_client/config/global.dart';
import 'package:post_client/model/post/album.dart';
import 'package:post_client/service/post/album_service.dart';
import 'package:post_client/view/component/media/list/album_list_tile.dart';
import 'package:post_client/view/page/album/album_edit_page.dart';

import '../../../common/list/common_item_list.dart';
import '../../../constant/source.dart';

class AlbumListPage extends StatefulWidget {
  const AlbumListPage({super.key});

  @override
  State<AlbumListPage> createState() => _AlbumListPageState();
}

class _AlbumListPageState extends State<AlbumListPage> {
  late Future _futureBuilderFuture;

  int _mediaType = 0;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
  }

  Future getData() async {
    return Future.wait([getFolloweeList()]);
  }

  Future<void> getFolloweeList() async {
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
                "合集",
                style: TextStyle(color: colorScheme.onSurface),
              ),
              actions: [
                PopupMenuButton<String>(
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        height: 35,
                        value: 'create',
                        child: Text(
                          '创建合集',
                          style: TextStyle(color: colorScheme.onBackground.withAlpha(200), fontSize: 14),
                        ),
                      ),
                    ];
                  },
                  icon: Icon(Icons.more_horiz, color: colorScheme.onSurface),
                  splashRadius: 20,
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
                      case "create":
                        var album = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AlbumEditPage()),
                        );
                        //todo 创建成功返回album，然后根据条件添加到列表
                        break;
                    }
                  },
                ),
              ],
            ),
            body: Container(
              color: colorScheme.background,
              child: Column(
                children: [
                  Container(
                    height: 40,
                    color: colorScheme.surface,
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    margin: const EdgeInsets.only(bottom: 2),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        buildSourceTypeItem("全部", 0),
                        const SizedBox(width: 5),
                        buildSourceTypeItem("音频", SourceType.audio),
                        const SizedBox(width: 5),
                        buildSourceTypeItem("文章", SourceType.article),
                        const SizedBox(width: 5),
                        buildSourceTypeItem("视频", SourceType.video),
                        const SizedBox(width: 5),
                        buildSourceTypeItem("图片", SourceType.gallery),
                      ],
                    ),
                  ),
                  Expanded(
                    child: CommonItemList<Album>(
                      key: ValueKey(_mediaType),
                      onLoad: (int page) async {
                        var commentList = await AlbumService.getUserAlbumList(Global.user, _mediaType, page, 20);
                        return commentList;
                      },
                      itemName: "合集",
                      itemHeight: null,
                      isGrip: false,
                      enableScrollbar: true,
                      itemBuilder: (ctx, album, albumList, onFresh) {
                        return AlbumListTile(
                          album: album,
                          onDeleteAlbum: (a) {
                            if (albumList != null) {
                              albumList.remove(a);
                              setState(() {});
                            }
                          },
                        );
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

  Widget buildSourceTypeItem(String title, int sourceType) {
    var colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Container(
        height: 25,
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: ElevatedButton(
          onPressed: () {
            if (_mediaType == sourceType) {
              return;
            }
            setState(() {
              _mediaType = sourceType;
            });
          },
          style: ButtonStyle(
            elevation: const MaterialStatePropertyAll(0),
            backgroundColor: MaterialStatePropertyAll(
              sourceType == _mediaType ? colorScheme.inverseSurface : colorScheme.surfaceVariant,
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: sourceType == _mediaType ? colorScheme.onInverseSurface : colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

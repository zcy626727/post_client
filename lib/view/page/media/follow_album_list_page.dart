import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:post_client/config/page_config.dart';
import 'package:post_client/model/post/follow_album.dart';
import 'package:post_client/service/post/follow_album_service.dart';
import 'package:post_client/util/entity_utils.dart';

import '../../../common/list/common_item_list.dart';
import '../../../constant/source.dart';
import '../../../model/post/album.dart';
import '../../component/media/list/album_list_tile.dart';

class FollowAlbumListPage extends StatefulWidget {
  const FollowAlbumListPage({super.key});

  @override
  State<FollowAlbumListPage> createState() => _FollowAlbumListPageState();
}

class _FollowAlbumListPageState extends State<FollowAlbumListPage> {
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
                    child: CommonItemList<FollowAlbum>(
                      key: ValueKey(_mediaType),
                      onLoad: (int page) async {
                        var followAlbum = await FollowAlbumService.getUserFollowAlbumList(pageIndex: page, pageSize: PageConfig.commonPageSize, mediaType: _mediaType, withUser: true);
                        return followAlbum;
                      },
                      itemName: "合集",
                      itemHeight: null,
                      isGrip: false,
                      enableScrollbar: true,
                      itemBuilder: (ctx, followAlbum, albumList, onFresh) {
                        //找不到该专辑，判定为失效
                        if (followAlbum.album == null || EntityUtil.idIsEmpty(followAlbum.album!.id)) {
                          var a = Album();
                          a.id = followAlbum.albumId;
                          a.user = followAlbum.user;
                          followAlbum.album = a;
                        }
                        return AlbumListTile(
                          album: followAlbum.album!,
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

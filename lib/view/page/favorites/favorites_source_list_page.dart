import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:post_client/model/favorites.dart';
import 'package:post_client/service/media/media_service.dart';
import 'package:post_client/service/message/feed_service.dart';

import '../list/common_source_list.dart';

class FavoritesSourceListPage extends StatefulWidget {
  const FavoritesSourceListPage({super.key, required this.favorites});

  final Favorites favorites;

  @override
  State<FavoritesSourceListPage> createState() => _FavoritesSourceListPageState();
}

class _FavoritesSourceListPageState extends State<FavoritesSourceListPage> {
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
                '收藏夹：${widget.favorites.title ?? "未知名称"}',
                style: TextStyle(color: colorScheme.onSurface),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              actions: const [],
            ),
            body: Container(
              color: colorScheme.background,
              child: CommonSourceList(
                sourceType: widget.favorites.sourceType,
                onLoadPost: (pageIndex) async {
                  var result = await FeedService.getFeedListByIdList(postIdList: widget.favorites.sourceIdList);
                  return result.$1;
                },
                onLoadComment: (pageIndex) async {
                  var result = await FeedService.getFeedListByIdList(commentIdList: widget.favorites.sourceIdList);
                  return result.$2;
                },
                onLoadAudio: (pageIndex) async {
                  var result = await MediaService.getMediaListByIdList(audioIdList: widget.favorites.sourceIdList);
                  return result.$2;
                },
                onLoadVideo: (pageIndex) async {
                  var result = await MediaService.getMediaListByIdList(videoIdList: widget.favorites.sourceIdList!);
                  return result.$4;
                },
                onLoadGallery: (pageIndex) async {
                  var result = await MediaService.getMediaListByIdList(galleryIdList: widget.favorites.sourceIdList);
                  return result.$3;
                },
                onLoadArticle: (pageIndex) async {
                  var result = await MediaService.getMediaListByIdList(articleIdList: widget.favorites.sourceIdList!);
                  return result.$1;
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

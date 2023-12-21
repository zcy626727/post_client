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
              actions: const [],
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
                        IconButton(onPressed: () {}, icon: const Icon(Icons.sort)),
                        Row(
                          children: [
                            IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                            IconButton(onPressed: () {}, icon: const Icon(Icons.folder_special)),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
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

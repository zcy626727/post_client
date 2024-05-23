import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:post_client/model/post/history.dart';
import 'package:post_client/service/post/history_service.dart';
import 'package:post_client/view/component/history/history_list_tile.dart';

import '../../../constant/source.dart';
import '../../widget/common_item_list.dart';

class HistoryListPage extends StatefulWidget {
  const HistoryListPage({super.key});

  @override
  State<HistoryListPage> createState() => _HistoryListPageState();
}

class _HistoryListPageState extends State<HistoryListPage> {
  late Future _futureBuilderFuture;

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
                "浏览历史",
                style: TextStyle(color: colorScheme.onSurface),
              ),
              actions: [],
            ),
            body: DefaultTabController(
              length: 4,
              child: Container(
                color: colorScheme.surface,
                child: Column(
                  children: [
                    TabBar(
                      labelPadding: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      tabs: [
                        buildTab("图片"),
                        buildTab("视频"),
                        buildTab("音频"),
                        buildTab("文章"),
                      ],
                    ),
                    Expanded(
                      child: buildTabBarView(),
                    ),
                  ],
                ),
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

  Tab buildTab(String title) {
    return Tab(
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        width: 65,
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
      ),
    );
  }

  Widget buildTabBarView() {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.background,
      padding: const EdgeInsets.only(left: 1, right: 1, top: 1),
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          CommonItemList<History>(
            onLoad: (int page) async {
              var galleryList = await HistoryService.getUserHistoryList(SourceType.gallery, page, 20);
              return galleryList;
            },
            itemName: "历史",
            itemHeight: null,
            enableScrollbar: true,
            itemBuilder: (ctx, history, historyList, onFresh) {
              return HistoryListTile(
                key: ValueKey(history.id),
                history: history,
                onDelete: (History h) {
                  historyList?.remove(history);
                  setState(() {});
                },
              );
            },
          ),
          CommonItemList<History>(
            onLoad: (int page) async {
              var galleryList = await HistoryService.getUserHistoryList(SourceType.video, page, 20);
              return galleryList;
            },
            itemName: "历史",
            itemHeight: null,
            enableScrollbar: true,
            itemBuilder: (ctx, history, historyList, onFresh) {
              return HistoryListTile(
                key: ValueKey(history.id),
                history: history,
                onDelete: (History h) {
                  historyList?.remove(history);
                  setState(() {});
                },
              );
            },
          ),
          CommonItemList<History>(
            onLoad: (int page) async {
              var galleryList = await HistoryService.getUserHistoryList(SourceType.audio, page, 20);
              return galleryList;
            },
            itemName: "历史",
            itemHeight: null,
            enableScrollbar: true,
            itemBuilder: (ctx, history, historyList, onFresh) {
              return HistoryListTile(
                key: ValueKey(history.id),
                history: history,
                onDelete: (History h) {
                  historyList?.remove(history);
                  setState(() {});
                },
              );
            },
          ),
          CommonItemList<History>(
            onLoad: (int page) async {
              var galleryList = await HistoryService.getUserHistoryList(SourceType.article, page, 20);
              return galleryList;
            },
            itemName: "历史",
            itemHeight: null,
            enableScrollbar: true,
            itemBuilder: (ctx, history, historyList, onFresh) {
              return HistoryListTile(
                key: ValueKey(history.id),
                history: history,
                onDelete: (History h) {
                  historyList?.remove(history);
                  setState(() {});
                },
              );
            },
          ),
        ],
      ),
    );
  }
}


import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class WatchLaterListPage extends StatefulWidget {
  const WatchLaterListPage({super.key});

  @override
  State<WatchLaterListPage> createState() => _WatchLaterListPageState();
}

class _WatchLaterListPageState extends State<WatchLaterListPage> {
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
    try {
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
                "稍后再看",
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
          Container(),
          Container(),
          Container(),
          Container(),
        ],
      ),
    );
  }
}

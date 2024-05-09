import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../constant/ui.dart';
import '../../../component/live/category/live_category_grid_item.dart';

class LiveCategoryListPage extends StatefulWidget {
  const LiveCategoryListPage({super.key});

  @override
  State<LiveCategoryListPage> createState() => _LiveCategoryListPageState();
}

class _LiveCategoryListPageState extends State<LiveCategoryListPage> {
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
                "选择分类",
                style: TextStyle(color: colorScheme.onSurface, fontSize: appbarTitleFontSize),
              ),
              actions: [],
            ),
            body: Container(
              color: colorScheme.background,
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      margin: const EdgeInsets.only(top: 1, bottom: 1),
                      color: colorScheme.surface,
                      child: TabBar(
                        tabAlignment: TabAlignment.start,
                        isScrollable: true,
                        tabs: [
                          SizedBox(height: double.infinity, child: Center(child: Text("推荐"))),
                          SizedBox(height: double.infinity, child: Center(child: Text("游戏"))),
                          SizedBox(height: double.infinity, child: Center(child: Text("户外"))),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: colorScheme.surface,
                        child: TabBarView(
                          children: [
                            //
                            Container(
                              margin: EdgeInsets.only(left: 5, right: 5),
                              child: GridView.builder(
                                controller: ScrollController(),
                                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 90,
                                  childAspectRatio: 1.2,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 5,
                                ),
                                itemCount: 11,
                                itemBuilder: (context, index) {
                                  return LiveCategoryGridItem();
                                },
                              ),
                            ),
                            Icon(Icons.directions_transit),
                            Icon(Icons.directions_bike),
                          ],
                        ),
                      ),
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
}

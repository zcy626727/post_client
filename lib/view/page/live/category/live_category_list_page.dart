import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:post_client/model/live/live_category.dart';

import '../../../../constant/ui.dart';
import '../../../../model/live/live_topic.dart';
import '../../../component/live/category/live_category_grid_item.dart';
import '../../../widget/common_item_list.dart';

class LiveCategoryListPage extends StatefulWidget {
  const LiveCategoryListPage({super.key});

  @override
  State<LiveCategoryListPage> createState() => _LiveCategoryListPageState();
}

class _LiveCategoryListPageState extends State<LiveCategoryListPage> {
  late Future _futureBuilderFuture;

  List<LiveTopic> topicList = <LiveTopic>[];

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
  }

  Future getData() async {
    return Future.wait([getTopicList()]);
  }

  Future<void> getTopicList() async {
    // 查找topic列表
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
                length: topicList.length,
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      margin: const EdgeInsets.only(top: 1, bottom: 1),
                      color: colorScheme.surface,
                      child: TabBar(
                        tabAlignment: TabAlignment.start,
                        isScrollable: true,
                        onTap: (index) {
                          // 获取主题的分类列表
                        },
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
                        child: CommonItemList<LiveCategory>(
                          onLoad: (int page) async {
                            // todo 根据topicId查找对应的categoryList
                            return [];
                          },
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 90,
                            childAspectRatio: 1.2,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                          ),
                          itemName: "直播间",
                          itemHeight: null,
                          isGrip: true,
                          enableScrollbar: true,
                          itemBuilder: (ctx, item, itemList, onFresh) {
                            return LiveCategoryGridItem(category: item);
                          },
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

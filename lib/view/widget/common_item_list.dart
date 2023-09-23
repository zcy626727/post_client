import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

import '../../../util/responsive.dart';

class CommonItemList<T> extends StatefulWidget {
  const CommonItemList({
    Key? key,
    required this.onLoad,
    required this.itemBuilder,
    required this.itemName,
    this.itemHeight,
    this.enableRefresh = true,
    this.isGrip = true,
    this.enableScrollbar = false,
    this.enableLoad = true,
    this.gripCount = 2,
    this.gripAspectRatio = 1.5,
  }) : super(key: key);

  final Future<List<T>> Function(int) onLoad;
  final bool enableRefresh;
  final bool enableLoad;
  final String itemName;
  final double? itemHeight;
  final Widget Function(BuildContext context, T item, List<T>? itemList, Function onFresh) itemBuilder;
  final bool enableScrollbar;

  //是否为网格
  final bool isGrip;

  //网格横向数量
  final int gripCount;

  //长宽比例
  final double gripAspectRatio;

  @override
  State<CommonItemList> createState() => _CommonItemListState<T>();
}

class _CommonItemListState<T> extends State<CommonItemList<T>> {
  final EasyRefreshController _refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  List<T>? _itemList;

  bool noData = false;

  //当前页数
  int _page = 0;

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
    try {
      var list = await widget.onLoad(_page);
      if (_itemList == null) {
        _itemList = list;
      } else if (list.isEmpty) {
        noData = true;
      } else {
        _itemList!.addAll(list);
      }
      _page++;
    } on DioException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  //刷新
  void _onRefresh() async {
    try {
      _itemList = await widget.onLoad(0);
      _page = 1;
      //获取成功
      _refreshController.finishRefresh();
      // _refreshController.resetNoData();
      setState(() {});
    } catch (e) {
      //获取失败
      // _refreshController.refreshFailed();
    }
  }

  //加载更多
  void _onLoading() async {
    try {
      var list = await widget.onLoad(_page);
      if (list.isNotEmpty) {
        //获取
        _itemList!.addAll(list);
        _page++;
      } else {
        noData = true;
      }
      _refreshController.finishLoad();
      if (mounted) setState(() {});
    } catch (e) {
      //获取失败
      log(e.toString());
      // _refreshController.loadFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          return widget.isGrip ? gridBuild() : listBuild();
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

  Widget gridBuild() {
    var colorScheme = Theme.of(context).colorScheme;
    if (_itemList == null) {
      return Center(
        child: Text("数据为空", style: TextStyle(color: colorScheme.onSurface)),
      );
    }
    if (_itemList!.isEmpty) {
      return Center(
        child: Text("${widget.itemName}列表为空", style: TextStyle(color: colorScheme.onSurface)),
      );
    }
    return EasyRefresh(
      header: MaterialHeader(backgroundColor: colorScheme.primaryContainer, color: colorScheme.onPrimaryContainer),
      footer: CupertinoFooter(backgroundColor: colorScheme.primaryContainer, foregroundColor: colorScheme.onPrimaryContainer),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoad: noData ? null : _onLoading,
      child: GridView.builder(
        controller: ScrollController(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.gripCount,
          //长宽比例
          childAspectRatio: widget.gripAspectRatio,
          //主轴高度
          mainAxisExtent: widget.itemHeight,
          //主轴距离
          mainAxisSpacing: 5.0,
          //辅轴距离
          crossAxisSpacing: 5.0,
        ),
        itemCount: _itemList!.length,
        itemBuilder: (context, index) {
          return widget.itemBuilder(context, _itemList![index], _itemList, () {
            setState(() {});
          });
        },
      ),
    );
  }

  Widget listBuild() {
    var colorScheme = Theme.of(context).colorScheme;
    if (_itemList == null) {
      return Center(
        child: Text("数据为空", style: TextStyle(color: colorScheme.onSurface)),
      );
    }
    if (_itemList!.isEmpty) {
      return Center(
        child: Text("${widget.itemName}列表为空", style: TextStyle(color: colorScheme.onSurface)),
      );
    }
    return EasyRefresh(
      header: MaterialHeader(backgroundColor: colorScheme.primaryContainer, color: colorScheme.onPrimaryContainer),
      footer: CupertinoFooter(backgroundColor: colorScheme.primaryContainer, foregroundColor: colorScheme.onPrimaryContainer),
      controller: _refreshController,
      onRefresh: widget.enableRefresh ? _onRefresh : null,
      onLoad: widget.enableLoad ? (noData ? null : _onLoading) : null,
      child: widget.enableScrollbar
          ? Scrollbar(
              child: ListView.builder(
              itemCount: _itemList!.length,
              itemBuilder: (context, index) {
                return widget.itemBuilder(context, _itemList![index], _itemList, () {
                  setState(() {});
                });
              },
            ))
          : ListView.builder(
              itemCount: _itemList!.length,
              itemBuilder: (context, index) {
                return widget.itemBuilder(context, _itemList![index], _itemList, () {
                  setState(() {});
                });
              },
            ),
    );
  }
}

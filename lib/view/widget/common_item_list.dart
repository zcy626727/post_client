import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:post_client/view/component/load/mobile_refersh_footer.dart';
import 'package:post_client/view/component/load/mobile_refresh_header.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../util/responsive.dart';

class CommonItemList<T> extends StatefulWidget {
  const CommonItemList(
      {Key? key,
      required this.onLoad,
      required this.itemBuilder,
      required this.itemName,
      this.itemHeight,
      this.enableUp = true,
      this.isGrip = true,
      this.enableScrollbar = false})
      : super(key: key);

  final Future<List<T>> Function(int) onLoad;
  final bool enableUp;
  final bool isGrip;
  final String itemName;
  final double? itemHeight;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final bool enableScrollbar;

  @override
  State<CommonItemList> createState() => _CommonItemListState<T>();
}

class _CommonItemListState<T> extends State<CommonItemList<T>> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<T>? _itemList;
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
      } else {
        _itemList!.addAll(list);
      }
      _page++;
    } on DioError catch (e) {
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
      _refreshController.refreshCompleted();
      _refreshController.resetNoData();
      setState(() {});
    } catch (e) {
      //获取失败
      _refreshController.refreshFailed();
    }
  }

  //加载更多
  void _onLoading() async {
    try {
      var list = await widget.onLoad(_page);
      if (list.isEmpty) {
        _refreshController.loadNoData();
      } else {
        _itemList!.addAll(list);
        _page++;
        //获取成功
        _refreshController.loadComplete();
        if (mounted) setState(() {});
      }
    } catch (e) {
      //获取失败
      log(e.toString());
      _refreshController.loadFailed();
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
        child: Text("访问服务器失败", style: TextStyle(color: colorScheme.onSurface)),
      );
    }
    if (_itemList!.isEmpty) {
      return Center(
        child: Text("${widget.itemName}列表为空",
            style: TextStyle(color: colorScheme.onSurface)),
      );
    }
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: widget.enableUp,
      header: const MobileRefreshHeader(),
      footer: const MobileRefreshFooter(),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: GridView.builder(
        controller: ScrollController(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: Responsive.isSmall(context) ? 1 : 3,
          //长宽比例
          childAspectRatio: 2,
          //主轴高度
          mainAxisExtent: widget.itemHeight,
          //主轴距离
          mainAxisSpacing: 1.0,
          //辅轴距离
          crossAxisSpacing: 5.0,
        ),
        itemCount: _itemList!.length,
        itemBuilder: (context, index) {
          return widget.itemBuilder(context, _itemList![index]);
        },
      ),
    );
  }

  Widget listBuild() {
    var colorScheme = Theme.of(context).colorScheme;
    if (_itemList == null) {
      return Center(
        child: Text("访问服务器失败", style: TextStyle(color: colorScheme.onSurface)),
      );
    }
    if (_itemList!.isEmpty) {
      return Center(
        child: Text("${widget.itemName}列表为空",
            style: TextStyle(color: colorScheme.onSurface)),
      );
    }
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: widget.enableUp,
      header: const MobileRefreshHeader(),
      footer: const MobileRefreshFooter(),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: widget.enableScrollbar
          ? Scrollbar(
              child: ListView.builder(
              controller: ScrollController(),
              itemCount: _itemList!.length,
              itemBuilder: (context, index) {
                return widget.itemBuilder(context, _itemList![index]);
              },
            ))
          : ListView.builder(
              controller: ScrollController(),
              itemCount: _itemList!.length,
              itemBuilder: (context, index) {
                return widget.itemBuilder(context, _itemList![index]);
              },
            ),
    );
  }
}

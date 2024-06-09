import 'package:flutter/material.dart';

import '../../../../common/list/common_item_list.dart';
import '../../../../constant/ui.dart';
import '../../../../model/message/live_category.dart';
import '../../../../model/message/live_room.dart';
import '../../../../service/message/live_room_service.dart';
import '../../../component/live/room/live_room_grid_item.dart';

class LiveRoomListOfCategoryPage extends StatefulWidget {
  const LiveRoomListOfCategoryPage({super.key, required this.category});

  final LiveCategory category;

  @override
  State<LiveRoomListOfCategoryPage> createState() => _LiveRoomListOfCategoryPageState();
}

class _LiveRoomListOfCategoryPageState extends State<LiveRoomListOfCategoryPage> {
  late Future _futureBuilderFuture;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
  }

  Future getData() async {
    return Future.wait([]);
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
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
              "英雄联盟",
              style: TextStyle(color: colorScheme.onSurface, fontSize: appbarTitleFontSize),
            ),
            actions: [],
          ),
          body: snapShot.connectionState == ConnectionState.done
              ? Container(
                  color: colorScheme.background,
                  child: CommonItemList<LiveRoom>(
                    onLoad: (int page) async {
                      if (widget.category.id == null) {
                        return [];
                      }
                      var itemList = await LiveRoomService.getRoomListByCategory(categoryId: widget.category.id!);
                      return itemList;
                    },
                    itemName: "直播间",
                    isGrip: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 1, crossAxisCount: 2, crossAxisSpacing: 5, mainAxisSpacing: 5),
                    enableScrollbar: true,
                    itemBuilder: (ctx, item, itemList, onFresh) {
                      return Container(
                        padding: const EdgeInsets.only(top: 2, left: 2, right: 2),
                        child: LiveRoomGridItem(liveRoom: item),
                      );
                    },
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:post_client/config/constants.dart';
import 'package:post_client/model/user/user.dart';
import 'package:post_client/state/user_state.dart';
import 'package:post_client/util/responsive.dart';
import 'package:post_client/view/component/live/room/live_room_grid_item.dart';
import 'package:post_client/view/page/live/category/live_category_list_page.dart';
import 'package:provider/provider.dart';

import '../../../common/list/common_item_list.dart';
import '../../../model/message/live_category.dart';
import '../../../model/message/live_room.dart';
import '../../../service/message/live_room_service.dart';

class LiveScreen extends StatefulWidget {
  const LiveScreen({super.key});

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  List<LiveCategory> liveCategoryList = <LiveCategory>[LiveCategory.all(id: 0, avatarUrl: testImageUrl, name: "推荐")];
  int _currentCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Selector<UserState, User>(
      selector: (context, data) => data.user,
      shouldRebuild: (pre, next) => pre.token != next.token,
      builder: (context, user, child) {
        return Responsive.isSmallWithDevice(context) ? buildMobile() : buildDesktop();
      },
    );
  }

  Widget buildMobile() {
    var colorScheme = Theme.of(context).colorScheme;

    var c = QuillController.basic();
    return Container(
      height: double.infinity,
      color: colorScheme.background,
      child: Container(
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.only(left: 2, right: 2, bottom: 2),
        child: Column(
          children: [
            // 直播分类
            Container(
              color: colorScheme.surface,
              padding: const EdgeInsets.only(left: 2),
              height: 45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 收藏的分类
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: liveCategoryList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.only(right: 2),
                          child: buildCategoryItem(liveCategoryList[index].name ?? "未知", index),
                        );
                      },
                    ),
                  ),
                  // 展开分类和主题的按钮
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LiveCategoryListPage()),
                        );
                      },
                      icon: const Icon(Icons.format_align_right))
                ],
              ),
            ),
            // 推荐直播间
            Expanded(
              child: Container(
                color: colorScheme.background,
                child: CommonItemList<LiveRoom>(
                  key: ValueKey(_currentCategoryIndex),
                  onLoad: (int page) async {
                    if (_currentCategoryIndex == 0) {
                      var itemList = await LiveRoomService.getRoomListRandom(pageIndex: page, pageSize: 20);
                      return itemList;
                    } else {
                      int id = liveCategoryList[_currentCategoryIndex].id!;
                      var itemList = LiveRoomService.getRoomListByCategory(categoryId: id);
                      return itemList;
                    }
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
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildCategoryItem(String title, int categoryIndex) {
    var colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: TextButton(
          onPressed: () {
            if (_currentCategoryIndex == categoryIndex) {
              return;
            }
            setState(() {
              _currentCategoryIndex = categoryIndex;
            });
          },
          style: ButtonStyle(
            elevation: const MaterialStatePropertyAll(0),
            backgroundColor: MaterialStatePropertyAll(
              _currentCategoryIndex == categoryIndex ? colorScheme.inverseSurface : colorScheme.surfaceVariant,
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: categoryIndex == _currentCategoryIndex ? colorScheme.onInverseSurface : colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDesktop() {
    return Container();
  }
}

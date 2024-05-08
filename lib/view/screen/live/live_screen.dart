import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:post_client/model/user/user.dart';
import 'package:post_client/state/user_state.dart';
import 'package:post_client/util/responsive.dart';
import 'package:provider/provider.dart';

import '../../../model/live/live_category.dart';

class LiveScreen extends StatefulWidget {
  const LiveScreen({super.key});

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  List<LiveCategory> liveCategoryList = <LiveCategory>[];
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
        color: colorScheme.surface,
        height: 70,
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.only(left: 2, right: 2, bottom: 2),
        child: Column(
          children: [
            // 轮播图，
            // 直播分类
            Container(
              padding: const EdgeInsets.only(left: 2),
              height: 45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 收藏的分类
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.only(right: 2),
                          child: buildCategoryItem("黄播", index),
                        );
                      },
                    ),
                  ),

                  // 展开分类和主题的按钮
                  IconButton(onPressed: () {}, icon: const Icon(Icons.format_align_right))
                ],
              ),
            ),
            // 推荐直播间
            Expanded(
              child: GridView.builder(
                controller: ScrollController(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                ),
                itemCount: 11,
                itemBuilder: (context, index) {
                  return Container(
                    width: 100,
                    height: 300,
                    color: colorScheme.primaryContainer,
                  );
                },
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

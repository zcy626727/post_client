import 'package:flutter/material.dart';
import 'package:post_client/model/post.dart';
import 'package:post_client/util/responsive.dart';
import 'package:post_client/view/component/post/post_card.dart';
import 'package:post_client/view/widget/common_item_list.dart';
import 'package:provider/provider.dart';

import '../../../model/user.dart';
import '../../../state/user_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Selector<UserState, User>(
      selector: (context, data) => data.user,
      shouldRebuild: (pre, next) => pre.token != next.token,
      builder: (context, user, child) {
        return Responsive.isSmallWithDevice(context)
            ? buildMobile(user)
            : buildDesktop();
      },
    );
  }

  Widget buildMobile(User user) {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.background,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            //app bar
            SliverToBoxAdapter(
              child: Container(
                color: colorScheme.surface,
                margin: const EdgeInsets.only(bottom: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    Container(
                      width: 50.0,
                      height: 50.0,
                      margin: const EdgeInsets.only(left: 5),
                      child: TextButton(
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: CircleAvatar(
                          radius: 16.0,
                          backgroundImage: user.avatarUrl == null
                              ? null
                              : NetworkImage(user.avatarUrl!),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ];
        },
        body: DefaultTabController(
          length: 1,
          child: Column(
            children: [
              //tab bar
              const HomeScreenTabBar(),
              //tab bar view list
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    CommonItemList<Post>(
                      onLoad: (int page) async {
                        var postList = <Post>[];
                        postList.add(Post.one());
                        return postList;
                      },
                      enableUp: true,
                      itemName: "动态",
                      itemHeight: null,
                      isGrip: false,
                      enableScrollbar: true,
                      itemBuilder: (ctx, post) {
                        return PostCard(
                          post: post,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDesktop() {
    return Container();
  }
}

class HomeScreenTabBar extends StatefulWidget {
  const HomeScreenTabBar({Key? key}) : super(key: key);

  @override
  State<HomeScreenTabBar> createState() => _HomeScreenTabBarState();
}

class _HomeScreenTabBarState extends State<HomeScreenTabBar> {
  static const double iconSize = 28;

  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 65,
      width: double.infinity,
      color: colorScheme.surface,
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15.0),
      child: TabBar(
          onTap: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          //指示器大小设置为和label一致
          indicatorSize: TabBarIndicatorSize.label,
          //启动滚动(选项多时启用)
          // isScrollable: true,
          //未选中内容颜色
          unselectedLabelColor: Colors.grey,
          //选中内容颜色
          labelColor: colorScheme.primary,
          //label间距
          labelPadding: const EdgeInsets.symmetric(horizontal: 3.0),
          indicator: BoxDecoration(
            color: colorScheme.primaryContainer,
            //形状
            borderRadius: BorderRadius.circular(50),
          ),
          splashBorderRadius: BorderRadius.circular(50),
          tabs: [
            tabBuild(0, Icons.topic, "动态"),
            // tabBuild(1, Icons.article_outlined, "视频"),
            // tabBuild(2,Icons.subject_outlined, "话题"),
            // tabBuild(3,Icons.insert_drive_file, "文件"),
          ]),
    );
  }

  Widget tabBuild(int index, IconData iconData, String title) {
    return Tab(
      iconMargin: EdgeInsets.zero,
      child: SizedBox(
        //高度会自动填充剩余部分，设置宽度以保证背景圆形
        width: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: iconSize,
            ),
            const SizedBox(width: 5),
            if (_currentPage == index) Text(title),
          ],
        ),
      ),
    );
  }
}

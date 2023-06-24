import 'package:flutter/material.dart';
import 'package:post_client/config/global.dart';
import 'package:post_client/model/post.dart';
import 'package:post_client/service/post_service.dart';
import 'package:post_client/state/user_state.dart';
import 'package:post_client/view/component/post/post_card.dart';
import 'package:post_client/view/component/post/post_list.dart';
import 'package:post_client/view/widget/common_item_list.dart';
import 'package:provider/provider.dart';

import '../../../config/constants.dart';
import '../../../model/user.dart';

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({Key? key}) : super(key: key);

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  @override
  Widget build(BuildContext context) {
    var userState = Provider.of<UserState>(context);

    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  backgroundColor: colorScheme.surface,
                  pinned: true,
                  //划到上面时标题栏是否隐藏
                  floating: false,
                  //向下滑动一点就显示全部
                  snap: false,
                  primary: true,
                  expandedHeight: 300,
                  toolbarHeight: 50,
                  leading: Center(
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Material(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                        clipBehavior: Clip.hardEdge,
                        color: colorScheme.surface.withAlpha(100),
                        child: IconButton(
                          splashRadius: 20,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: buildProfileCard(userState.user),
                  ),
                  bottom: PreferredSize(
                    //如果高度有问题就改这里的值
                    preferredSize: const Size(double.infinity, 30),
                    child: Container(
                      color: colorScheme.surface,
                      child: TabBar(
                        labelPadding: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        tabs: [
                          buildTab("动态"),
                          buildTab("图片"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: Container(
            margin: const EdgeInsets.only(top: 80),
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Container(
                  color: colorScheme.background,
                  child: PostList(
                    onLoad: (int page) async {
                      var postList = await PostService.getPostListByUserId(Global.user.id!, page, 20);
                      return postList;
                    },
                    enableRefresh: false,
                    itemName: "动态",
                    itemHeight: null,
                    enableScrollbar: true,
                  ),
                ),
                Container(
                  child: Text("图片"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  final double backgroundImageHeight = 150;

  //用户资料
  Widget buildProfileCard(User user) {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          //背景图
          Image(
            image: NetworkImage(user.avatarUrl!),
            height: backgroundImageHeight,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          //个人信息等
          Container(
            margin: EdgeInsets.only(top: backgroundImageHeight),
            padding: const EdgeInsets.only(left: 20),
            width: double.infinity,
            color: colorScheme.surface,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //名字
                Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: Text(
                    Global.user.name ?? "未知",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: colorScheme.onSurface),
                  ),
                ),
              ],
            ),
          ),
          //头像、按钮
          Container(
            margin: EdgeInsets.only(left: 20, top: backgroundImageHeight - 35),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(user.avatarUrl!),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 40),
                  height: 30,
                  child: OutlinedButton(onPressed: () {}, child: const Text("编辑资料")),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Tab buildTab(String title) {
    return Tab(
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
      ),
    );
  }
}

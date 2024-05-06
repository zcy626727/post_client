import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:post_client/util/responsive.dart';
import 'package:post_client/view/page/account/user_details_page.dart';
import 'package:provider/provider.dart';

import '../../../config/global.dart';
import '../../../model/user/user.dart';
import '../../../state/user_state.dart';
import '../../component/setting/light_dark_switch.dart';
import '../notion/bulletin_list_page.dart';
import '../reply/reply_comment_list_page.dart';
import '../reply/reply_mention_list_page.dart';

class MobileAccountDrawerPage extends StatelessWidget {
  const MobileAccountDrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Drawer(
      width: 300,
      backgroundColor: colorScheme.surface,
      child: SafeArea(
        child: Selector<UserState, UserState>(
          selector: (context, userState) => userState,
          shouldRebuild: (pre, next) => true,
          builder: (context, userState, index) {
            User user = userState.user;
            bool isLogin = user.token != null;
            isLogin = true;
            log("移动端抽屉栏构建");
            return Column(
              children: [
                headBuild(context, userState.user),
                Divider(
                  height: 1,
                  color: colorScheme.primaryContainer,
                ),
                Container(height: 5),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      if (isLogin)
                        MobileDrawerItem(
                          // leading: Icon(
                          //   Icons.comment,
                          //   color: colorScheme.onBackground,
                          //   size: 23,
                          // ),
                          trailing: Icon(
                            Icons.arrow_right,
                            color: colorScheme.onBackground,
                          ),
                          title: "我的评论",
                          onPress: () {},
                        ),
                      if (isLogin)
                        MobileDrawerItem(
                          // leading: SvgPicture.asset(
                          //   "assets/icons/aite.svg",
                          //   height: 20,
                          //   width: 20,
                          //   colorFilter: ColorFilter.mode(colorScheme.onBackground, BlendMode.srcIn),
                          // ),
                          trailing: Icon(
                            Icons.arrow_right,
                            color: colorScheme.onBackground,
                          ),
                          title: "@我",
                          onPress: () {
                            if (Global.user.id == null) {
                              //显示登录页
                              Navigator.pushNamed(context, "login");
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ReplyMentionListPage()),
                              );
                            }
                          },
                        ),
                      if (isLogin)
                        MobileDrawerItem(
                          // leading: Icon(
                          //   Icons.reply,
                          //   color: colorScheme.onBackground,
                          //   size: 23,
                          // ),
                          trailing: Icon(
                            Icons.arrow_right,
                            color: colorScheme.onBackground,
                          ),
                          title: "回复",
                          onPress: () {
                            if (Global.user.id == null) {
                              //显示登录页
                              Navigator.pushNamed(context, "login");
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ReplyCommentListPage()),
                              );
                            }
                          },
                        ),
                      if (isLogin)
                        MobileDrawerItem(
                          // leading: Icon(
                          //   Icons.insert_comment_outlined,
                          //   color: colorScheme.onBackground,
                          //   size: 23,
                          // ),
                          trailing: Icon(
                            Icons.arrow_right,
                            color: colorScheme.onBackground,
                          ),
                          title: "通知",
                          onPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const BulletinListPage()),
                            );
                          },
                        ),
                      if (isLogin)
                        if (isLogin)
                          MobileDrawerItem(
                            // leading: Icon(
                            //   Icons.logout,
                            //   color: colorScheme.onBackground,
                            //   size: 23,
                            // ),
                            title: "注销",
                            onPress: () {
                              //清空token
                              user.clearUserInfo();
                              userState.user = user;
                              //不能在updateUserOfDB后面
                              Navigator.pop(context);
                              //持久化用户信息
                              updateUserOfDB(user);
                            },
                          ),
                    ],
                  ),
                ),
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //功能按钮导航
                      const SizedBox(),
                      //亮暗模式
                      LightDarkSwitch(
                        isLarge: Responsive.isSmall(context),
                        width: !Responsive.isSmall(context) ? 40 : 130,
                      ),
                      //钱包
                      const SizedBox()
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget headBuild(BuildContext context, User user) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 205,
      margin: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //头像
          IconButton(
            splashRadius: 35,
            iconSize: 65,
            icon: CircleAvatar(
              //头像半径
              radius: 40,
              backgroundImage: user.avatarUrl == null ? null : NetworkImage(user.avatarUrl!),
            ),
            onPressed: () async {
              if ((user.token != null && user.token != "")) {
                //已登录
                //进入用户详情页面
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserDetailPage(user: user)),
                );
              } else {
                //未登录
                Navigator.pop(context);
                Navigator.pushNamed(context, "login");
              }
            },
          ),
          const SizedBox(height: 10),
          Text(
            user.name != null && user.name!.isNotEmpty ? user.name! : "未登录",
            style: TextStyle(color: colorScheme.onSurface, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Text(user.formatId(), style: TextStyle(color: colorScheme.onSurface.withAlpha(160))),
          // const SizedBox(height: 4),
          // SizedBox(
          //   height: 20,
          //   child: Chip(
          //     backgroundColor: Colors.deepOrange[300],
          //     padding: const EdgeInsets.only(bottom: 3, left: 4, right: 4),
          //     // labelPadding: EdgeInsets.zero,
          //     visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
          //     label: const Text(
          //       'lv 6',
          //       style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 5),
          //
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: CommonSocialInfo(
              followerNumber: user.followerNumber ?? 0,
              followNumber: user.followeeNumber ?? 0,
            ),
          ),
        ],
      ),
    );
  }

  updateUserOfDB(User user) async {
    try {
      await Global.userProvider.update(user);
    } catch (e) {
      log("清除数据库登录信息失败");
    }
  }
}

class MobileDrawerItem extends StatelessWidget {
  const MobileDrawerItem({
    Key? key,
    required this.title,
    required this.onPress,
    this.leading,
    this.trailing,
  }) : super(key: key);

  final Widget? leading;
  final Widget? trailing;
  final String title;
  final GestureTapCallback? onPress;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 45,
      child: TextButton(
        onPressed: onPress,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (leading != null) leading!,
                  if (leading != null) const SizedBox(width: 15),
                  Container(
                    margin: const EdgeInsets.only(bottom: 3),
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 15, color: colorScheme.onBackground),
                    ),
                  )
                ],
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}

class CommonSocialInfo extends StatelessWidget {
  const CommonSocialInfo({
    Key? key,
    required this.followerNumber,
    required this.followNumber,
  }) : super(key: key);

  //粉丝
  final int followerNumber;

  //关注
  final int followNumber;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextStyle textStyle = TextStyle(color: colorScheme.onSurface.withAlpha(160));
    TextStyle numberStyle = TextStyle(color: colorScheme.onSurface);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Column(
            children: [
              Text("$followNumber", style: numberStyle),
              Text("关注", style: textStyle),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text("$followerNumber", style: numberStyle),
              Text("粉丝", style: textStyle),
            ],
          ),
        ),
      ],
    );
  }
}

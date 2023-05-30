import 'package:flutter/material.dart';
import 'package:post_client/screen/follow/follow_screen.dart';
import 'package:post_client/screen/notion/notion_screen.dart';
import 'package:post_client/screen/own/own_screen.dart';
import 'package:post_client/view/screen/home/home_screen.dart';
import 'package:provider/provider.dart';

import '../state/screen_state.dart';
import '../util/responsive.dart';
import 'component/navigation/desktop_side_navigation_bar.dart';
import 'component/navigation/mobile_bottom_navigation_bar.dart';
import 'page/account/mobile_account_page.dart';

//主界面，负责处理布局、加载配置
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MainScreenState();
  }
}

class MainScreenState extends State<MainScreen> {
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      drawer: const MobileAccountDrawer(),
      drawerEnableOpenDragGesture: false,
      body: Container(
        color: colorScheme.surface,
        child: Row(
          children: [
            //左侧菜单栏
            if (!Responsive.isSmallWithDevice(context))
              const DesktopSideNavigationBar(),
            //主界面
            Expanded(
              flex: 5,
              //适配不规则屏幕（刘海屏）
              child: SafeArea(
                child: _body(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Responsive.isSmallWithDevice(context)
          ? const MobileBottomNavigationBar()
          : null,
    );
  }

  Widget _body() {
    return SafeArea(
      child: Container(
        child:
            _getPage(Provider.of<ScreenNavigatorState>(context).firstNavIndex),
      ),
    );
  }

  Widget _getPage(int index) {
    // var userState = Provider.of<UserState>(context);
    // if (!userState.isLogin) {
    //   return const DesktopAccountScreen();
    // }
    switch (index) {
      case FirstNav.home:
        return const HomeScreen();
      case FirstNav.follow:
        return const FollowScreen();
      case FirstNav.notice:
        return const NotionScreen();
      case FirstNav.own:
        return const OwnScreen();
      default:
        return Container();
    }
  }
}

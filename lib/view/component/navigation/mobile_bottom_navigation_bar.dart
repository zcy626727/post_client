import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state/screen_state.dart';

class MobileBottomNavigationBar extends StatefulWidget {
  const MobileBottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<MobileBottomNavigationBar> createState() =>
      _MobileBottomNavigationBarState();
}

class _MobileBottomNavigationBarState extends State<MobileBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    var navState = Provider.of<ScreenNavigatorState>(context);
    return BottomAppBar(
      color: colorScheme.surface,
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            MobileBottomNavigationItem(
              iconData: Icons.home,
              selectedIndex: navState.firstNavIndex,
              index: FirstNav.home,
              label: "首页",
              press: () {
                navState.firstNavIndex = FirstNav.home;
              },
            ),
            MobileBottomNavigationItem(
              iconData: Icons.rss_feed,
              selectedIndex: navState.firstNavIndex,
              index: FirstNav.follow,
              label: "关注",
              press: () {
                navState.firstNavIndex = FirstNav.follow;
              },
            ),
            Container(
              width: 45,
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(colorScheme.secondary),
                  splashFactory: NoSplash.splashFactory,
                ),
                onPressed: () {
                  //todo 弹出上传界面（全屏）
                },
                child: Icon(
                  Icons.add,
                  color: colorScheme.onSecondary,
                ),
              ),
            ),
            MobileBottomNavigationItem(
              iconData: Icons.notifications_on,
              selectedIndex: navState.firstNavIndex,
              index: FirstNav.notice,
              label: "通知",
              press: () {
                navState.firstNavIndex = FirstNav.notice;
              },
            ),
            MobileBottomNavigationItem(
              iconData: Icons.view_stream,
              selectedIndex: navState.firstNavIndex,
              index: FirstNav.media,
              label: "媒体",
              press: () {
                navState.firstNavIndex = FirstNav.media;
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MobileBottomNavigationItem extends StatelessWidget {
  const MobileBottomNavigationItem(
      {Key? key,
      required this.selectedIndex,
      required this.index,
      this.label,
      required this.iconData,
      this.press})
      : super(key: key);

  //当前选中索引
  final int selectedIndex;

  //该项索引
  final int index;

  final String? label;

  //展示图标
  final IconData iconData;

  //点击回调
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    bool isSelected = index == selectedIndex;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Color currentColor =
        isSelected ? colorScheme.primary : colorScheme.onSurface;

    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: press,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          //不加颜色无法
          color: colorScheme.surface,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconData, color: currentColor),
              if (label != null)
                Text(
                  label!,
                  style: TextStyle(
                      color: currentColor, fontSize: isSelected ? 13 : 12),
                )
            ],
          ),
        ),
      ),
    );
  }
}

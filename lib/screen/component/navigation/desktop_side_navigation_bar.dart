import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state/screen_state.dart';
import '../../widget/light_dark_switch.dart';

class DesktopSideNavigationBar extends StatefulWidget {
  const DesktopSideNavigationBar({Key? key}) : super(key: key);

  @override
  State<DesktopSideNavigationBar> createState() => _DesktopSideNavigationBarState();
}

class _DesktopSideNavigationBarState extends State<DesktopSideNavigationBar> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    var navState = Provider.of<ScreenNavigatorState>(context);
    return Drawer(
      elevation: 1,
      width: 65,
      backgroundColor: colorScheme.surface,
      child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          //头像
                          Container(
                            padding: const EdgeInsets.all(4.0),
                            child: const Center(
                              child: Image(
                                image: AssetImage('assets/images/hei.jpg'),
                                width: 50,
                                height: 50,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          DesktopSideNavigationItem(
                            iconData: Icons.home,
                            index: FirstNav.home,
                            selectedIndex: navState.firstNavIndex,
                            press: (index) {
                              navState.firstNavIndex = index;
                            },
                          ),
                          const SizedBox(height: 5.0),
                          DesktopSideNavigationItem(
                            iconData: Icons.podcasts,
                            index: FirstNav.follow,
                            selectedIndex: navState.firstNavIndex,
                            press: (index) {
                              navState.firstNavIndex = index;
                            },
                          ),
                          const SizedBox(height: 5.0),
                          DesktopSideNavigationItem(
                            iconData: Icons.notifications_on,
                            index: FirstNav.follow,
                            selectedIndex: navState.firstNavIndex,
                            press: (index) {
                              navState.firstNavIndex = index;
                            },
                          ),
                          const SizedBox(height: 5.0),
                          DesktopSideNavigationItem(
                            iconData: Icons.star,
                            index: FirstNav.follow,
                            selectedIndex: navState.firstNavIndex,
                            press: (index) {
                              navState.firstNavIndex = index;
                            },
                          ),
                          const SizedBox(height: 5.0),
                          DesktopSideNavigationItem(
                            iconData: Icons.person,
                            index: FirstNav.account,
                            selectedIndex: navState.firstNavIndex,
                            press: (index) {
                              navState.firstNavIndex = index;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //用户界面和亮暗模式
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    child: Column(
                      children: [
                        //设置界面
                        IconButton(
                          onPressed: () {
                            //弹出设置
                          },
                          icon: const Icon(Icons.settings),
                        ),
                        //亮暗模式
                        const LightDarkSwitch(isLarge: false, width: 120,),
                      ],
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}

class DesktopSideNavigationItem extends StatelessWidget {
  const DesktopSideNavigationItem({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.iconData,
    required this.index,
    required this.selectedIndex,
    required this.press,
  }) : super(key: key);

  //当前选中索引
  final int selectedIndex;

  //该项索引
  final int index;

  //展示图标
  final IconData iconData;

  //点击回调
  final Function(int) press;

  @override
  Widget build(BuildContext context) {
    bool isSelected = index == selectedIndex;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Color currentColor = isSelected ? colorScheme.onPrimary : colorScheme.onSurface;

    return Container(
      margin: const EdgeInsets.only(top: 3, bottom: 3),
      child: SizedBox(
        height: 40,
        child: Center(
          child: TextButton(
            onPressed: () {
              press(index);
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              )),
              padding: MaterialStateProperty.all(const EdgeInsets.only(top: 17.0, bottom: 20.0)),
              backgroundColor: isSelected ? MaterialStateProperty.all(colorScheme.primary) : null,
            ),
            child: Icon(
              iconData,
              color: currentColor,
              size: 23,
            ),
          ),
        ),
      ),
    );
  }
}

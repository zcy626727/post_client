import 'package:flutter/material.dart';
import 'package:post_client/view/page/article/article_edit_page.dart';
import 'package:post_client/view/page/audio/audio_edit_page.dart';
import 'package:post_client/view/page/live/room/create_live_page.dart';
import 'package:post_client/view/page/post/post_edit_page.dart';
import 'package:post_client/view/page/video/video_edit_page.dart';
import 'package:post_client/view/widget/button/common_action_one_button.dart';
import 'package:provider/provider.dart';

import '../../../config/global.dart';
import '../../../state/screen_state.dart';
import '../../../util/webrtc.dart';
import '../../page/gallery/gallery_edit_page.dart';

class MobileBottomNavigationBar extends StatefulWidget {
  const MobileBottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<MobileBottomNavigationBar> createState() => _MobileBottomNavigationBarState();
}

class _MobileBottomNavigationBarState extends State<MobileBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    var navState = Provider.of<ScreenNavigatorState>(context);
    return BottomAppBar(
      padding: EdgeInsets.zero,
      height: 55,
      color: colorScheme.surface,
      child: Material(
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
                iconData: Icons.live_tv,
                selectedIndex: navState.firstNavIndex,
                index: FirstNav.live,
                label: "直播",
                press: () {
                  navState.firstNavIndex = FirstNav.live;
                },
              ),
              Container(
                width: 50,
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(colorScheme.secondary),
                    splashFactory: NoSplash.splashFactory,
                  ),
                  onPressed: () async {
                    if (Global.user.token == null) {
                      // 未登录不能发布
                      Navigator.pushNamed(context, "login");
                    } else {
                      //弹出底部栏
                      await showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            color: colorScheme.surface,
                            child: SafeArea(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                                color: colorScheme.surface,
                                height: 220,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        buildUploadItem(
                                            title: "图片",
                                            iconData: Icons.image_outlined,
                                            onTap: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => const GalleryEditPage()),
                                              );
                                            }),
                                        buildUploadItem(
                                            title: "视频",
                                            iconData: Icons.video_file_outlined,
                                            onTap: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => const VideoEditPage()),
                                              );
                                            }),
                                        buildUploadItem(
                                            title: "音频",
                                            iconData: Icons.audio_file_outlined,
                                            onTap: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => const AudioEditPage()),
                                              );
                                            }),
                                        buildUploadItem(
                                          title: "文章",
                                          iconData: Icons.article_outlined,
                                          onTap: () {
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => const ArticleEditPage()),
                                            );
                                          },
                                        ), //文章
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        buildUploadItem(
                                          title: "动态",
                                          iconData: Icons.post_add,
                                          onTap: () {
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => const PostEditPage()),
                                            );
                                          },
                                        ), //推文
                                        buildUploadItem(
                                          title: "直播",
                                          iconData: Icons.live_tv,
                                          onTap: () {
                                            Navigator.pop(context);
                                            enableRTC(onEnable: () {
                                              //确保RTC正常使用
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => const CreateLivePage()),
                                              );
                                            }, onError: () {
                                              // ShowSnackBar.error(context: this.context, message: "直播功能需要开启权限");
                                            });
                                          },
                                        ),
                                        const Expanded(child: SizedBox()),
                                        const Expanded(child: SizedBox()),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 40,
                                      child: Center(
                                        child: CommonActionOneButton(
                                          backgroundColor: colorScheme.primaryContainer,
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: colorScheme.onSecondary,
                    ),
                  ),
                ),
              ),
              MobileBottomNavigationItem(
                iconData: Icons.rss_feed,
                selectedIndex: navState.firstNavIndex,
                index: FirstNav.follow,
                label: "动态",
                press: () {
                  if (Global.user.id == null) {
                    // 未登录不能发布
                    Navigator.pushNamed(context, "login");
                  } else {
                    navState.firstNavIndex = FirstNav.follow;
                  }
                },
              ),
              MobileBottomNavigationItem(
                iconData: Icons.person,
                selectedIndex: navState.firstNavIndex,
                index: FirstNav.mine,
                label: "我的",
                press: () {
                  if (Global.user.id == null) {
                    // 未登录不能发布
                    Navigator.pushNamed(context, "login");
                  } else {
                    navState.firstNavIndex = FirstNav.mine;
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUploadItem({required String title, required IconData iconData, required VoidCallback onTap}) {
    var colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: SizedBox(
        height: 80,
        child: TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            )),
          ),
          onPressed: onTap,
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: colorScheme.primaryContainer,
                child: Icon(iconData),
              ),
              Text(
                title,
                style: TextStyle(color: colorScheme.onSurface),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MobileBottomNavigationItem extends StatelessWidget {
  const MobileBottomNavigationItem({Key? key, required this.selectedIndex, required this.index, this.label, required this.iconData, this.press}) : super(key: key);

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
    Color currentColor = isSelected ? colorScheme.primary : colorScheme.onSurface;

    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: press,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: isSelected ? colorScheme.primaryContainer : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconData, color: currentColor),
              if (label != null)
                Text(
                  label!,
                  style: TextStyle(color: currentColor, fontSize: isSelected ? 13 : 12),
                )
            ],
          ),
        ),
      ),
    );
  }
}

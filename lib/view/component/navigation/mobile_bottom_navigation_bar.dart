import 'package:flutter/material.dart';
import 'package:post_client/view/page/article/article_edit_page.dart';
import 'package:post_client/view/page/post/post_edit_page.dart';
import 'package:post_client/view/widget/button/common_action_one_button.dart';
import 'package:post_client/view/widget/button/common_action_two_button.dart';
import 'package:provider/provider.dart';

import '../../../state/screen_state.dart';

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
                    backgroundColor: MaterialStateProperty.all(colorScheme.secondary),
                    splashFactory: NoSplash.splashFactory,
                  ),
                  onPressed: () async {
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
                              height: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
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
                                      buildUploadItem(title: "投票", iconData: Icons.how_to_vote_outlined, onTap: () {}), //动态投票
                                      buildUploadItem(title: "问答", iconData: Icons.question_answer_outlined, onTap: () {}), //帖子
                                      buildUploadItem(
                                          title: "文章",
                                          iconData: Icons.article_outlined,
                                          onTap: () {
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) =>  const ArticleEditPage()),
                                            );
                                          }), //文章
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      buildUploadItem(title: "图片", iconData: Icons.image_outlined, onTap: () {}),
                                      buildUploadItem(title: "视频", iconData: Icons.video_file_outlined, onTap: () {}),
                                      buildUploadItem(title: "音频", iconData: Icons.audio_file_outlined, onTap: () {}),
                                      const Expanded(child: SizedBox())
                                    ],
                                  ),
                                  SizedBox(
                                    height: 40,
                                    child: Center(
                                      child: CommonActionOneButton(
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
      ),
    );
  }

  Widget buildUploadItem({required String title, required IconData iconData, required VoidCallback onTap}) {
    var colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: SizedBox(
        height: 60,
        child: TextButton(
          onPressed: onTap,
          child: Column(
            children: [
              Icon(iconData),
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

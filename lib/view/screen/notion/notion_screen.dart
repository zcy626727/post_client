import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:post_client/model/user.dart';
import 'package:post_client/state/user_state.dart';
import 'package:post_client/util/responsive.dart';
import 'package:post_client/view/page/notion/bulletin_list_page.dart';
import 'package:post_client/view/page/reply/reply_comment_list_page.dart';
import 'package:post_client/view/page/reply/reply_mention_list_page.dart';
import 'package:provider/provider.dart';

class NotionScreen extends StatefulWidget {
  const NotionScreen({super.key});

  @override
  State<NotionScreen> createState() => _NotionScreenState();
}

class _NotionScreenState extends State<NotionScreen> {
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

    return Container(
      color: colorScheme.background,
      child: Column(
        children: [
          Container(
            color: colorScheme.surface,
            height: 70,
            margin: const EdgeInsets.only(bottom: 2),
            padding: const EdgeInsets.only(left: 2, right: 2, bottom: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NotionTabButton(
                  title: "回复",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ReplyCommentListPage()),
                    );
                  },
                  svgPath: "assets/icons/huifu.svg",
                ),
                NotionTabButton(
                  title: "@我",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ReplyMentionListPage()),
                    );
                  },
                  svgPath: "assets/icons/aite.svg",
                ),
                NotionTabButton(
                  title: "通知",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BulletinListPage()),
                    );
                  },
                  svgPath: "assets/icons/tongzhi.svg",
                ),
              ],
            ),
          ),
          Expanded(
            child: buildChatList(),
          )
        ],
      ),
    );
  }

  Widget buildChatList() {
    var colorScheme = Theme.of(context).colorScheme;

    return Container(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 0,
            color: colorScheme.surface,
            margin: const EdgeInsets.only(bottom: 2.0),
            child: ListTile(
              leading: const CircleAvatar(backgroundImage: NetworkImage('https://pic1.zhimg.com/80/v2-64803cb7928272745eb2bb0203e03648_1440w.webp')),
              title: Text(
                "路由器",
                style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
              ),
              subtitle: const Text(
                "你瞅啥",
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {
                //如果是移动端则点击后弹出路由
                if (Responsive.isSmall(context)) {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) {
                  //       return const CommonChatPage();
                  //     },
                  //   ),
                  // );
                }
              },
            ),
          );
        },
        itemCount: 5,
      ),
    );
  }

  Widget buildDesktop() {
    return Container();
  }
}

class NotionTabButton extends StatelessWidget {
  const NotionTabButton({
    super.key,
    required this.title,
    required this.onTap,
    required this.svgPath,
  });

  final String title;
  final VoidCallback onTap;
  final String svgPath;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: TextButton(
        onPressed: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SvgPicture.asset(
              svgPath,
              height: 25,
              width: 25,
              colorFilter: ColorFilter.mode(colorScheme.onSurface, BlendMode.srcIn),
            ),
            Text(
              title,
              style: TextStyle(color: colorScheme.onSurface, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

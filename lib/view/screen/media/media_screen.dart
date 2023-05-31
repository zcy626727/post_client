import 'package:flutter/material.dart';
import 'package:post_client/model/user.dart';
import 'package:post_client/state/user_state.dart';
import 'package:post_client/util/responsive.dart';
import 'package:post_client/view/widget/common_header_bar.dart';
import 'package:provider/provider.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  @override
  Widget build(BuildContext context) {
    return Selector<UserState, User>(
      selector: (context, data) => data.user,
      shouldRebuild: (pre, next) => pre.token != next.token,
      builder: (context, user, child) {
        return Responsive.isSmallWithDevice(context)
            ? buildMobile()
            : buildDesktop();
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
            height: 160,
            margin: const EdgeInsets.only(bottom: 3),
            width: double.infinity,
            color: colorScheme.surface,
            child: Column(
              children: [
                CommonHeaderBar(
                  title: "浏览历史",
                  trailing: TextButton(
                    onPressed: () {},
                    child: const Text("查看全部"),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 160,
            margin: const EdgeInsets.only(bottom: 3),
            width: double.infinity,
            color: colorScheme.surface,
            child: Column(
              children: [
                CommonHeaderBar(
                  title: "稍后再看",
                  trailing: TextButton(
                    onPressed: () {},
                    child: const Text("查看全部"),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: colorScheme.surface,
            margin: const EdgeInsets.only(bottom: 3),
            height: 120,
            child: Column(
              children: [
                CommonHeaderBar(
                  title: "收藏",
                  trailing: TextButton(
                    onPressed: () {},
                    child: const Text("查看全部"),
                  ),
                ),
                Row(
                  children: [],
                )
              ],
            ),
          ),
          //其他选项
          Container(
            color: colorScheme.surface,
            child: Column(
              children: [
                TextButton(
                  onPressed: () {},
                  child: ListTile(
                    iconColor: colorScheme.onSurface,
                    visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -4),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                    leading: const Icon(
                      Icons.wifi_rounded,
                      size: 20,
                    ),
                    minLeadingWidth: 30,
                    title: Text(
                      "哈哈哈",
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                  color: colorScheme.onSurface,
                ),
                TextButton(
                  onPressed: () {},
                  child: ListTile(
                    iconColor: colorScheme.onSurface,
                    visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -4),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                    leading: const Icon(
                      Icons.wifi_rounded,
                      size: 20,
                    ),
                    minLeadingWidth: 30,
                    title: Text(
                      "哈哈哈",
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDesktop() {
    return Container();
  }
}

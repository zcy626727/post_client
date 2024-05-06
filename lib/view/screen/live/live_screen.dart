import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:post_client/model/user/user.dart';
import 'package:post_client/state/user_state.dart';
import 'package:post_client/util/responsive.dart';
import 'package:post_client/view/component/quill/quill_tool_bar.dart';
import 'package:provider/provider.dart';

import '../../component/quill/quill_editor.dart';

class LiveScreen extends StatefulWidget {
  const LiveScreen({super.key});

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
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

    var c = QuillController.basic();
    return Container(
      height: double.infinity,
      color: colorScheme.background,
      child: Container(
        color: colorScheme.surface,
        height: 70,
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.only(left: 2, right: 2, bottom: 2),
        child: Column(
          children: [
            // 直播界面
            CommonQuillToolBar(controller: c),
            Expanded(
              child: CommonQuillEditor(
                controller: c,
                focusNode: FocusNode(),
                autoFocus: false,
              ),
            )
          ],
        ),
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

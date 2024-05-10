import 'package:flutter/material.dart';

import '../../../constant/ui.dart';
import '../../../util/responsive.dart';
import 'chat_page.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        toolbarHeight: 50,
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        leading: IconButton(
          splashRadius: 20,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: colorScheme.onBackground,
          ),
        ),
        title: Text(
          "消息",
          style: TextStyle(color: colorScheme.onSurface, fontSize: appbarTitleFontSize),
        ),
        actions: [],
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 1),
        color: colorScheme.background,
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 0,
              color: colorScheme.surface,
              margin: const EdgeInsets.only(bottom: 2.0),
              child: ListTile(
                leading: const CircleAvatar(backgroundImage: NetworkImage(testImageUrl)),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const ChatPage();
                        },
                      ),
                    );
                  }
                },
              ),
            );
          },
          itemCount: 5,
        ),
      ),
    );
  }
}

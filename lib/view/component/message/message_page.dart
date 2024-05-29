import 'package:flutter/material.dart';
import 'package:post_client/config/page_config.dart';
import 'package:post_client/model/message/user_interaction.dart';

import '../../../constant/ui.dart';
import '../../../service/message/user_message_service.dart';
import '../../../util/responsive.dart';
import 'chat_page.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  late Future _futureBuilderFuture;
  int pageIndex = 0;
  DateTime startTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
  }

  Future getData() async {
    return Future.wait([loadUserMessage()]);
  }

  var interList = <UserInteraction>[];

  // 加载历史消息
  Future loadUserMessage() async {
    var usm = await UserMessageService.getInteractionList(pageIndex: pageIndex, pageSize: PageConfig.commonPageSize, startTime: startTime);
    pageIndex++;
    interList.addAll(usm);
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
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
                  final userInter = interList[index];
                  int? unreadCount = userInter.unreadCount;
                  return Card(
                    elevation: 0,
                    color: colorScheme.surface,
                    margin: const EdgeInsets.only(bottom: 2.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          userInter.otherUser?.avatarUrl ?? testImageUrl,
                        ),
                      ),
                      title: Text(
                        userInter.otherUser!.name ?? "未知",
                        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                      ),
                      subtitle: Text(
                        "${unreadCount ?? 0} 条消息未读",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      onTap: () {
                        //如果是移动端则点击后弹出路由
                        if (Responsive.isSmall(context)) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ChatPage(userInteraction: userInter);
                              },
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
                itemCount: interList.length,
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          );
        }
      },
    );
  }
}

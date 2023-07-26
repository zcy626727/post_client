import 'package:flutter/material.dart';
import 'package:post_client/config/global.dart';
import 'package:post_client/service/user/user_service.dart';
import 'package:post_client/view/component/media/upload/image_upload_card.dart';
import 'package:provider/provider.dart';

import '../../../domain/task/upload_media_task.dart';
import '../../../state/user_state.dart';
import '../../widget/button/common_action_two_button.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late UploadMediaTask _avatarTask;
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _avatarTask = UploadMediaTask();
    if (Global.user.alreadyLogin()) {
      _avatarTask.status = UploadTaskStatus.finished.index;
      _avatarTask.staticUrl = Global.user.avatarUrl;
      _usernameController.text = Global.user.name ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    //更新用户信息时使用
    var userState = Provider.of<UserState>(context);
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
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
          "个人资料",
          style: TextStyle(color: colorScheme.onSurface),
        ),
        actions: [],
      ),
      body: Column(
        children: [
          //头像
          Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.only(left: 8, right: 6),
            color: colorScheme.surface,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "头像",
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  height: 80,
                  width: 80,
                  child: ImageUploadCard(
                    key: ValueKey(Global.user.id),
                    task: _avatarTask,
                    enableDelete: false,
                    onUpdateImage: (task) async {
                      //更新完后
                      await UserService.updateAvatarUrl(task.staticUrl);
                      userState.user.avatarUrl = task.staticUrl;
                      userState.notify();
                    },
                  ),
                )
              ],
            ),
          ),
          //名字
          Container(
            height: 50,
            margin: const EdgeInsets.only(top: 2),
            color: colorScheme.surface,
            child: TextButton(
              onPressed: () async {
                //点击弹出对话框输入新名字
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    contentPadding: const EdgeInsets.only(left: 8, right: 8, top: 20, bottom: 10),
                    content: TextFormField(
                      controller: _usernameController,
                      style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 10.0, right: 2, bottom: 10, top: 10),
                        labelText: "名字",
                        labelStyle: TextStyle(color: colorScheme.onSurface),
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          //添加边框
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        suffixIcon: Icon(
                          Icons.person,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    actions: [
                      CommonActionTwoButton(
                        onLeftTap: () {
                          Navigator.of(context).pop();
                        },
                        onRightTap: () async {
                          if (_usernameController.text != Global.user.name && _usernameController.text.isNotEmpty) {
                            await UserService.updateUsername(_usernameController.text);
                            if (mounted) Navigator.of(context).pop();
                            userState.user.name = _usernameController.text;
                            userState.notify();
                          }
                        },
                        rightTextColor: colorScheme.onPrimary,
                        backgroundRightColor: colorScheme.primary,
                      )
                    ],
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "名字",
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    Global.user.name ?? "",
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),

          //密码
          Container(
            height: 50,
            margin: const EdgeInsets.only(top: 2),
            color: colorScheme.surface,
            child: TextButton(
              onPressed: () {
                //弹出修改密码界面
              },
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  "更改密码",
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

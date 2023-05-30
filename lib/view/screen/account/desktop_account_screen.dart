import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:post_client/view/screen/account/sign_in_or_up_screen.dart';
import 'package:provider/provider.dart';

import '../../../model/user.dart';
import '../../../service/user_service.dart';
import '../../../state/user_state.dart';

class DesktopAccountScreen extends StatefulWidget {
  const DesktopAccountScreen({Key? key}) : super(key: key);

  @override
  State<DesktopAccountScreen> createState() => _DesktopAccountScreenState();
}

class _DesktopAccountScreenState extends State<DesktopAccountScreen> {
  @override
  Widget build(BuildContext context) {
    //如果未登录转到登录页
    return Selector<UserState, User>(
      selector: (context, userState) => userState.user,
      shouldRebuild: (pre, next) => pre.token != next.token,
      builder: (context, user, child) {
        //未登录，显示登录注册界面
        if (user.token == null) {
          return const SignInOrUpScreen();
        } else {
          return buildAccountInfo();
        }
      },
    );
  }

  Widget buildAccountInfo() {
    var colorScheme = Theme.of(context).colorScheme;
    return Selector<UserState, UserState>(
      selector: (context, userState) => userState,
      shouldRebuild: (pre, next) => pre.user.token != next.user.token,
      builder: (context, userState, child) {
        var user = userState.user;
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 2, right: 2, top: 2),
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Card(
                      margin: const EdgeInsets.all(0),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      color: colorScheme.surface,
                      child: Container(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                //头像
                                IconButton(
                                  splashRadius: 35,
                                  iconSize: 60,
                                  icon: CircleAvatar(
                                    //头像半径
                                    radius: 30,
                                    backgroundImage: user.avatarUrl == null
                                        ? null
                                        : NetworkImage(user.avatarUrl!),
                                  ),
                                  onPressed: () async {
                                    //打开file picker
                                    FilePickerResult? result =
                                        await FilePicker.platform.pickFiles();
                                    if (result != null) {
                                      File file =
                                          File(result.files.single.path!);
                                    } else {
                                      // User canceled the picker
                                    }
                                  },
                                ),
                                //信息
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //名字
                                    Text(
                                      user.name ?? "未登录",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4.0,
                                    ),
                                    //号码
                                    Text(
                                      "ID: ${user.formatId()}",
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          color: colorScheme.onSurface
                                              .withAlpha(100)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            //社交信息
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 50.0,
                    height: double.infinity,
                    margin: const EdgeInsets.only(left: 3),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Card(
                      elevation: 0,
                      margin: const EdgeInsets.all(0),
                      color: colorScheme.surface,
                      child: TextButton(
                        onPressed: () async {
                          //退出登录
                          await UserService.signOut();
                          userState.user = User();
                        },
                        clipBehavior: Clip.hardEdge,
                        child: Icon(
                          Icons.logout_outlined,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const Expanded(child: Placeholder())
          ],
        );
      },
    );
  }
}

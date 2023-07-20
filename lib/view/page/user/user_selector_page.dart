//用户选择器
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:post_client/config/constants.dart';
import 'package:post_client/model/user/user.dart';
import 'package:post_client/view/widget/button/common_action_one_button.dart';

class UserSelectorPage extends StatefulWidget {
  const UserSelectorPage({Key? key}) : super(key: key);

  @override
  State<UserSelectorPage> createState() => _UserSelectorPageState();
}

class _UserSelectorPageState extends State<UserSelectorPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            child: const CupertinoSearchTextField(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 20,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: NetworkImage(testImageUrl),
                  ),
                  onTap: () {
                    Navigator.pop(context, json.encode(User(id: 1, phoneNumber: "100")));
                  },
                  title: const Text("路由器"),
                  subtitle: const Text("正在关注"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

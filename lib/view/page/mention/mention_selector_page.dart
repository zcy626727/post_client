//用户选择器
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:post_client/model/user/user.dart';
import 'package:post_client/service/user/user_service.dart';

import '../../../service/post/follow_service.dart';

class MentionSelectorPage extends StatefulWidget {
  const MentionSelectorPage({Key? key}) : super(key: key);

  @override
  State<MentionSelectorPage> createState() => _MentionSelectorPageState();
}

class _MentionSelectorPageState extends State<MentionSelectorPage> {
  List<User> _userList = <User>[];

  late Future _futureBuilderFuture;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
  }

  Future getData() async {
    return Future.wait([getFolloweeList()]);
  }

  Future<void> getFolloweeList() async {
    try {
      var followeeList = await FollowService.getFolloweeList(0, 20);
      for (var u in followeeList) {
        u.following = true;
      }
      _userList.addAll(followeeList);
    } on DioException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          return SafeArea(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(5),
                  child: CupertinoSearchTextField(
                    onSubmitted: (value) async {
                      if (value.isEmpty) {
                        return;
                      }
                      try {
                        _userList = await UserService.searchUser(value, 0, 50);
                        setState(() {});
                      } on DioException catch (e) {
                        log(e.toString());
                      } catch (e) {
                        log(e.toString());
                      }
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _userList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var user = _userList[index];
                      return ListTile(
                        key: ValueKey(user.id),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.avatarUrl ?? ""),
                        ),
                        onTap: () {
                          Navigator.pop(context, json.encode(user));
                        },
                        title: Text(user.name ?? ""),
                        subtitle: Text(""),
                      );
                    },
                  ),
                ),
              ],
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

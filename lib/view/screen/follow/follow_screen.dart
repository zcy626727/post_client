import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:post_client/model/post.dart';
import 'package:post_client/model/user.dart';
import 'package:post_client/service/follow_service.dart';
import 'package:post_client/service/post_service.dart';
import 'package:post_client/state/user_state.dart';
import 'package:post_client/util/responsive.dart';
import 'package:post_client/view/component/post/post_list_tile.dart';
import 'package:post_client/view/component/post/post_list.dart';
import 'package:post_client/view/page/account/user_details_page.dart';
import 'package:post_client/view/widget/common_item_list.dart';
import 'package:provider/provider.dart';

import '../../../constant/post.dart';

class FollowScreen extends StatefulWidget {
  const FollowScreen({super.key});

  @override
  State<FollowScreen> createState() => _FollowScreenState();
}

class _FollowScreenState extends State<FollowScreen> {
  final int selectedIndex = 0;
  int _sourceType = 0;

  late List<User> _followeeList = <User>[];

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
      _followeeList = await FollowService.getFolloweeList(0, 10);
    } on DioException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Selector<UserState, User>(
      selector: (context, data) => data.user,
      shouldRebuild: (pre, next) => pre.token != next.token,
      builder: (context, user, child) {
        return Responsive.isSmallWithDevice(context) ? buildMobile(user) : buildDesktop();
      },
    );
  }

  Widget buildMobile(User user) {
    var colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          return Container(
            color: colorScheme.background,
            child: Column(
              children: [
                Container(
                  height: 100,
                  margin: const EdgeInsets.only(bottom: 2),
                  color: colorScheme.surface,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: ScrollController(),
                    itemCount: _followeeList.length,
                    itemBuilder: (context, index) {
                      var followee = _followeeList[index];
                      return TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserDetailPage(
                                user: followee,
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          height: 60,
                          width: 60,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundImage: NetworkImage(followee.avatarUrl!),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  height: 40,
                  color: colorScheme.surface,
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  margin: const EdgeInsets.only(bottom: 2),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      buildSourceTypeItem("全部", 0),
                      const SizedBox(width: 5),
                      buildSourceTypeItem("音频", PostSourceType.audio),
                      const SizedBox(width: 5),
                      buildSourceTypeItem("文章", PostSourceType.article),
                      const SizedBox(width: 5),
                      buildSourceTypeItem("视频", PostSourceType.video),
                      const SizedBox(width: 5),
                      buildSourceTypeItem("图片", PostSourceType.gallery),
                    ],
                  ),
                ),
                Expanded(
                  child: PostList(
                    key: ValueKey(_sourceType),
                    onLoad: (int page) async {
                      var postList = await PostService.getFolloweePostList(_sourceType, page, 20);
                      return postList;
                    },
                    enableRefresh: true,
                    itemName: "动态",
                    itemHeight: null,
                    enableScrollbar: true,
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

  Widget buildSourceTypeItem(String title, int sourceType) {
    var colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Container(
        height: 25,
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: ElevatedButton(
          onPressed: () {
            if (_sourceType == sourceType) {
              return;
            }
            setState(() {
              _sourceType = sourceType;
            });
          },
          style: ButtonStyle(
            elevation: const MaterialStatePropertyAll(0),
            backgroundColor: MaterialStatePropertyAll(
              sourceType == _sourceType ? colorScheme.inverseSurface : colorScheme.surfaceVariant,
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: sourceType == _sourceType ? colorScheme.onInverseSurface : colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDesktop() {
    return Container();
  }
}

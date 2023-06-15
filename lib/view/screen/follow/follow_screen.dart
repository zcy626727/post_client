import 'package:flutter/material.dart';
import 'package:post_client/model/post.dart';
import 'package:post_client/model/user.dart';
import 'package:post_client/state/user_state.dart';
import 'package:post_client/util/responsive.dart';
import 'package:post_client/view/component/post/post_card.dart';
import 'package:post_client/view/widget/common_item_list.dart';
import 'package:provider/provider.dart';

class FollowScreen extends StatefulWidget {
  const FollowScreen({super.key});

  @override
  State<FollowScreen> createState() => _FollowScreenState();
}

class _FollowScreenState extends State<FollowScreen> {
  final int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
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
              itemCount: 3,
              itemBuilder: (context, index) {
                return TextButton(
                  onPressed: () {},
                  child: Container(
                    height: 60,
                    width: 60,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundImage: AssetImage('assets/images/hei.jpg'),
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
                Center(
                  child: Container(
                    height: 25,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        elevation: const MaterialStatePropertyAll(0),
                        backgroundColor: MaterialStatePropertyAll(colorScheme.inverseSurface),
                      ),
                      child: Text(
                        "全部",
                        style: TextStyle(
                          color: colorScheme.onInverseSurface,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Center(
                  child: Container(
                    height: 25,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        elevation: const MaterialStatePropertyAll(0),
                        backgroundColor: MaterialStatePropertyAll(
                          colorScheme.background,
                        ),
                      ),
                      child: Text(
                        "动态",
                        style: TextStyle(
                          color: colorScheme.onBackground,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: CommonItemList<Post>(
              onLoad: (int page) async {
                var postList = <Post>[];
                postList.add(Post.one());
                return postList;
              },
              itemName: "动态",
              itemHeight: null,
              isGrip: false,
              enableScrollbar: true,
              itemBuilder: (ctx, post) {
                return PostCard(
                  post: post,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget buildDesktop() {
    return Container();
  }
}

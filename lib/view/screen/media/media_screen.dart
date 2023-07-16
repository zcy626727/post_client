import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:post_client/model/album.dart';
import 'package:post_client/model/favorites.dart';
import 'package:post_client/model/history.dart';
import 'package:post_client/model/user.dart';
import 'package:post_client/service/album_service.dart';
import 'package:post_client/service/favorites_service.dart';
import 'package:post_client/state/user_state.dart';
import 'package:post_client/util/responsive.dart';
import 'package:post_client/view/component/media/album_list_tile.dart';
import 'package:post_client/view/widget/common_header_bar.dart';
import 'package:provider/provider.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  late Future _futureBuilderFuture;

  List<Album> _albumList = <Album>[];

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
  }

  Future getData() async {
    return Future.wait([getAlbum()]);
  }

  Future<void> getAlbum() async {
    try {
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
          return Selector<UserState, User>(
            selector: (context, data) => data.user,
            shouldRebuild: (pre, next) => pre.token != next.token,
            builder: (context, user, child) {
              return Responsive.isSmallWithDevice(context) ? buildMobile() : buildDesktop();
            },
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

  Widget buildMobile() {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.background,
      child: Column(
        children: [
          // Container(
          //   color: colorScheme.surface,
          //   margin: const EdgeInsets.only(bottom: 3),
          //   height: 200,
          //   child: Column(
          //     children: [
          //       CommonHeaderBar(
          //         title: "收藏",
          //         trailing: TextButton(
          //           onPressed: () {},
          //           child: const Text("查看全部"),
          //         ),
          //       ),
          //       Row(
          //         children: [],
          //       )
          //     ],
          //   ),
          // ),
          Container(
            margin: const EdgeInsets.only(top: 1),
            padding: const EdgeInsets.symmetric(vertical: 5),
            color: colorScheme.surface,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildItemButton(iconData: Icons.collections_bookmark, text: "我的收藏", onPress: () {}),
                buildItemButton(iconData: Icons.history, text: "历史记录"),
                buildItemButton(iconData: Icons.watch_later_outlined, text: "稍后再看"),
                buildItemButton(iconData: Icons.download, text: "缓存列表"),
              ],
            ),
          ),
          //订阅
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 2),
              color: colorScheme.surface,
              child: Column(
                children: [
                  const CommonHeaderBar(title: "订阅合集"),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (ctx, index) {
                        return AlbumListTile(album: _albumList[index]);
                      },
                      itemCount: _albumList.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItemButton({required IconData iconData, required String text, VoidCallback? onPress}) {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 85,
      child: TextButton(
        onPressed: onPress,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 45,
              width: 50,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Icon(
                iconData,
                color: colorScheme.onSurface,
              ),
            ),
            Text(
              text,
              style: TextStyle(color: colorScheme.onSurface, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDesktop() {
    return Container();
  }
}

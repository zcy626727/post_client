import 'package:flutter/material.dart';
import 'package:post_client/config/global.dart';
import 'package:post_client/model/post/album.dart';
import 'package:post_client/model/post/favorites.dart';
import 'package:post_client/view/widget/common_item_list.dart';

import '../../../service/post/album_service.dart';
import '../../widget/button/common_action_two_button.dart';

class SelectAlbumDialog extends StatefulWidget {
  const SelectAlbumDialog({Key? key, required this.onSelected, required this.mediaType, required this.onClear}) : super(key: key);

  final int mediaType;
  final Function(Album) onSelected;
  final Function onClear;

  @override
  State<SelectAlbumDialog> createState() => _SelectAlbumDialogState();
}

class _SelectAlbumDialogState extends State<SelectAlbumDialog> {
  late Future _futureBuilderFuture;
  Map<Favorites, bool> changeFavoritesMap = {};

  Future<void> loadFavoritesList() async {}

  Future getData() async {
    return Future.wait([loadFavoritesList()]);
  }

  @override
  void initState() {
    _futureBuilderFuture = getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          return _buildDialog();
        } else {
          // 请求未结束，显示loading
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildDialog() {
    var colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      contentPadding: const EdgeInsets.all(5.0),
      backgroundColor: colorScheme.surface,
      titlePadding: const EdgeInsets.only(top: 15.0, left: 10.0),
      content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return SizedBox(
            width: 250,
            height: 200,
            child: CommonItemList<Album>(
              onLoad: (int page) async {
                var albumList = await AlbumService.getUserAlbumList(Global.user, widget.mediaType, page, 20);
                return albumList;
              },
              itemName: "合集",
              itemHeight: null,
              isGrip: false,
              gripAspectRatio: 1,
              enableScrollbar: true,
              itemBuilder: (ctx, album, albumList, onFresh) {
                return TextButton(
                  onPressed: () {
                    widget.onSelected(album);
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    title: Text(album.title ?? "未知名称"),
                    subtitle: Text(album.introduction ?? "没有介绍"),
                    visualDensity: const VisualDensity(vertical: -4),
                  ),
                );
              },
            ));
      }),
      actions: [
        CommonActionTwoButton(
          rightTitle: "清除",
          leftTitle: "取消",
          rightTextColor: colorScheme.onPrimary,
          backgroundRightColor: colorScheme.primary,
          onRightTap: () {
            widget.onClear();
            Navigator.pop(context);
          },
          onLeftTap: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}

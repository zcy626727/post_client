import 'package:flutter/material.dart';
import 'package:post_client/constant/source.dart';
import 'package:post_client/view/component/favorites/favorites_list_tile.dart';
import 'package:post_client/view/page/favorites/favorites_edit_page.dart';

import '../../../common/list/common_item_list.dart';
import '../../../model/post/favorites.dart';
import '../../../service/post/favorites_service.dart';

class FavoritesListPage extends StatefulWidget {
  const FavoritesListPage({super.key});

  @override
  State<FavoritesListPage> createState() => _FavoritesListPageState();
}

class _FavoritesListPageState extends State<FavoritesListPage> {
  int _sourceType = SourceType.post;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          "收藏",
          style: TextStyle(color: colorScheme.onSurface),
        ),
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  height: 35,
                  value: 'create',
                  child: Text(
                    '新建收藏夹',
                    style: TextStyle(color: colorScheme.onBackground.withAlpha(200), fontSize: 14),
                  ),
                ),
              ];
            },
            icon: Icon(Icons.more_horiz, color: colorScheme.onSurface),
            splashRadius: 20,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                width: 1,
                color: colorScheme.onSurface.withAlpha(30),
                style: BorderStyle.solid,
              ),
            ),
            color: colorScheme.surface,
            onSelected: (value) async {
              switch (value) {
                case "create":
                  var post = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FavoritesEditPage()),
                  );
                  //todo 创建成功返回post，然后根据条件添加到列表
                  break;
              }
            },
          ),
        ],
      ),
      body: Container(
        color: colorScheme.background,
        child: Column(
          children: [
            Container(
              height: 40,
              color: colorScheme.surface,
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  buildSourceTypeItem("动态", SourceType.post),
                  const SizedBox(width: 5),
                  buildSourceTypeItem("评论", SourceType.comment),
                  const SizedBox(width: 5),
                  buildSourceTypeItem("音频", SourceType.audio),
                  const SizedBox(width: 5),
                  buildSourceTypeItem("文章", SourceType.article),
                  const SizedBox(width: 5),
                  buildSourceTypeItem("视频", SourceType.video),
                  const SizedBox(width: 5),
                  buildSourceTypeItem("图片", SourceType.gallery),
                ],
              ),
            ),
            Expanded(
              child: CommonItemList<Favorites>(
                key: ValueKey(_sourceType),
                onLoad: (int page) async {
                  var favoritesList = await FavoritesService.getUserFavoritesList(_sourceType, page, 20);
                  return favoritesList;
                },
                itemName: "合集",
                isGrip: false,
                enableScrollbar: true,
                itemBuilder: (ctx, favorites, favoritesList, onFresh) {
                  return FavoritesListTile(
                    favorites: favorites,
                    onDeleteFavorites: (f) {
                      favoritesList?.remove(favorites);
                      setState(() {});
                    },
                    onUpdateFavorites: (f) {
                      favorites.copyFavorites(f);
                      setState(() {});
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSourceTypeItem(String title, int sourceType) {
    var colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Container(
        height: 25,
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
}

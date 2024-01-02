import 'package:flutter/material.dart';
import 'package:post_client/constant/source.dart';
import 'package:post_client/model/follow_favorites.dart';
import 'package:post_client/service/user/follow_favorites_service.dart';
import 'package:post_client/view/component/favorites/favorites_list_tile.dart';

import '../../../model/favorites.dart';
import '../../../util/entity_utils.dart';
import '../../widget/common_item_list.dart';

class FollowFavoritesListPage extends StatefulWidget {
  const FollowFavoritesListPage({super.key});

  @override
  State<FollowFavoritesListPage> createState() => _FollowFavoritesListPageState();
}

class _FollowFavoritesListPageState extends State<FollowFavoritesListPage> {
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
              child: CommonItemList<FollowFavorites>(
                key: ValueKey(_sourceType),
                onLoad: (int page) async {
                  var followFavoritesList = await FollowFavoritesService.getUserFollowFavoritesList(sourceType: _sourceType, withUser: true);
                  return followFavoritesList;
                },
                itemName: "合集",
                isGrip: false,
                enableScrollbar: true,
                itemBuilder: (ctx, ff, ffList, onFresh) {
                  //找不到该收藏夹，判定为失效
                  if (ff.favorites == null || EntityUtil.idIsEmpty(ff.favorites!.id)) {
                    var f = Favorites();
                    f.id = ff.favoritesId;
                    f.user = ff.user;
                    ff.favorites = f;
                  }
                  return FavoritesListTile(
                    favorites: ff.favorites!,
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

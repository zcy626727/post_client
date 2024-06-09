import 'package:flutter/material.dart';
import 'package:post_client/model/post/favorites.dart';
import 'package:post_client/service/post/favorites_service.dart';
import 'package:post_client/service/post/favorites_source_service.dart';
import 'package:post_client/util/entity_utils.dart';
import 'package:post_client/view/component/favorites/select_favorites_list_tile.dart';

import '../../../common/list/common_item_list.dart';
import '../../widget/button/common_action_two_button.dart';

class SelectFavoritesDialog extends StatefulWidget {
  const SelectFavoritesDialog({Key? key, required this.onConfirm, required this.sourceType, required this.sourceId}) : super(key: key);

  final Function(int) onConfirm;
  final int sourceType;
  final String sourceId;

  @override
  State<SelectFavoritesDialog> createState() => _SelectFavoritesDialogState();
}

class _SelectFavoritesDialogState extends State<SelectFavoritesDialog> {
  late Future _futureBuilderFuture;
  Map<Favorites, bool> changeFavoritesMap = {};
  Map<String, bool> sourceInFavoritesIdMap = {};

  Future<void> loadFavoritesSourceList() async {
    var favoritesSourceList = await FavoritesSourceService.getFavoritesSourceListBySourceId(
      sourceId: widget.sourceId,
      sourceType: widget.sourceType,
    );
    for (var fs in favoritesSourceList) {
      if (!EntityUtil.idIsEmpty(fs.favoritesId)) {
        sourceInFavoritesIdMap[fs.favoritesId!] = true;
      }
    }
  }

  Future getData() async {
    return Future.wait([loadFavoritesSourceList()]);
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
            child: CommonItemList<Favorites>(
              onLoad: (int page) async {
                var favoritesList = await FavoritesService.getUserFavoritesList(widget.sourceType, page, 20);
                return favoritesList;
              },
              itemName: "收藏夹",
              itemHeight: null,
              enableScrollbar: true,
              itemBuilder: (ctx, favorites, favoritesList, onFresh) {
                return SelectFavoritesListTile(
                    favorites: favorites,
                    sourceId: widget.sourceId,
                    sourceInFavoritesIdMap: sourceInFavoritesIdMap,
                    onChanged: (value) {
                      //这样会将所有选择过的favorites都加入map
                      changeFavoritesMap[favorites] = value;
                    });
              },
            ));
      }),
      actions: <Widget>[
        CommonActionTwoButton(
          height: 35,
          onLeftTap: () {
            Navigator.pop(context);
          },
          backgroundRightColor: colorScheme.primary,
          rightTextColor: colorScheme.onPrimary,
          onRightTap: () async {
            //这里遍历changeFavoritesMap，根据其中的idList是否包含sourceId来划分成两个数组，添加和移除
            List<String> addFavoritesIdList = [];
            List<String> removeFavoritesIdList = [];
            changeFavoritesMap.forEach((favorites, selected) {
              bool isContains = sourceInFavoritesIdMap[favorites.id] ?? false;
              // if (favorites.sourceIdList != null) {
              //   isContains = favorites.sourceIdList!.contains(widget.sourceId);
              // }
              if (selected) {
                //选中，
                //只有最开始是未选中的才有效
                if (!isContains) {
                  addFavoritesIdList.add(favorites.id!);
                }
              } else {
                //未选中
                //只有最开始是选中的才有效
                if (isContains) {
                  removeFavoritesIdList.add(favorites.id!);
                }
              }
            });
            await FavoritesService.updateMediaInFavorites(
              addFavoritesIdList: addFavoritesIdList,
              removeFavoritesIdList: removeFavoritesIdList,
              sourceId: widget.sourceId,
              sourceType: widget.sourceType,
            );
            await widget.onConfirm(addFavoritesIdList.length - removeFavoritesIdList.length);
          },
        )
      ],
    );
  }
}

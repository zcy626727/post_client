import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:post_client/service/favorites_service.dart';
import 'package:post_client/view/page/favorites/favorites_source_list_page.dart';

import '../../../model/favorites.dart';
import '../../widget/dialog/confirm_alert_dialog.dart';
import '../show/show_snack_bar.dart';

class FavoritesListTile extends StatelessWidget {
  const FavoritesListTile({super.key, required this.favorites, required this.onDelete});

  final Favorites favorites;
  final Function(Favorites) onDelete;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(top: 2),
      color: colorScheme.surface,
      height: 100,
      child: TextButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FavoritesSourceListPage(favorites: favorites)),
          );
        },
        child: Row(
          children: [
            Container(
              width: 150,
              height: double.infinity,
              color: colorScheme.primaryContainer,
              child: favorites.coverUrl != null && favorites.coverUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image(
                        image: NetworkImage(favorites.coverUrl!),
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(
                      Icons.album_outlined,
                      size: 70,
                      color: colorScheme.onPrimaryContainer,
                    ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          favorites.title ?? "已失效",
                          style: TextStyle(color: colorScheme.onSurface.withAlpha(200), fontSize: 20, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "内容数量：${(favorites.sourceIdList?.length) ?? 0}",
                          style: TextStyle(color: colorScheme.onSurface.withAlpha(150)),
                        ),
                        PopupMenuButton<String>(
                          splashRadius: 20,
                          itemBuilder: (BuildContext context) {
                            return [
                              PopupMenuItem(
                                height: 35,
                                value: 'delete',
                                child: Text(
                                  '删除',
                                  style: TextStyle(color: colorScheme.onBackground.withAlpha(200), fontSize: 14),
                                ),
                              ),
                            ];
                          },
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
                              case "delete":
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ConfirmAlertDialog(
                                      text: "是否确定删除？",
                                      onConfirm: () async {
                                        try {
                                          await FavoritesService.deleteUserFavoritesById(favorites.id!, favorites.sourceType!);
                                          onDelete(favorites);
                                        } on DioException catch (e) {
                                          ShowSnackBar.exception(context: context, e: e, defaultValue: "删除失败");
                                        } finally {
                                          Navigator.pop(context);
                                        }
                                      },
                                      onCancel: () {
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                );
                                break;
                            }
                          },
                          child: Icon(Icons.more_horiz, color: colorScheme.onSurface),
                        ),
                      ],
                    )

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:post_client/view/page/favorites/favorites_source_list_page.dart';

import '../../../model/post/favorites.dart';

class FavoritesListTile extends StatefulWidget {
  const FavoritesListTile({super.key, required this.favorites, this.onDeleteFavorites, this.onUpdateFavorites});

  final Favorites favorites;
  final Function(Favorites)? onDeleteFavorites;
  final Function(Favorites)? onUpdateFavorites;

  @override
  State<FavoritesListTile> createState() => _FavoritesListTileState();
}

class _FavoritesListTileState extends State<FavoritesListTile> {
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
            MaterialPageRoute(
                builder: (context) => FavoritesSourceListPage(
                      favorites: widget.favorites,
                      onDelete: (a) {
                        if (widget.onDeleteFavorites != null) widget.onDeleteFavorites!(a);
                        if (mounted) Navigator.pop(context);
                      },
                      onUpdate: (a) {
                        widget.favorites.copyFavorites(a);
                        setState(() {});
                      },
                    )),
          );
        },
        child: Row(
          children: [
            Container(
              width: 150,
              height: double.infinity,
              color: colorScheme.primaryContainer,
              child: widget.favorites.coverUrl != null && widget.favorites.coverUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image(
                        image: NetworkImage(widget.favorites.coverUrl!),
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
                          widget.favorites.title ?? "已失效",
                          style: TextStyle(color: colorScheme.onSurface.withAlpha(200), fontSize: 20, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
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

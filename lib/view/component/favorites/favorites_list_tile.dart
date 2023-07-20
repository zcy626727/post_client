import 'package:flutter/material.dart';

import '../../../model/media/media_favorites.dart';


class FavoritesListTile extends StatelessWidget {
  const FavoritesListTile({super.key, required this.favorites});

  final MediaFavorites favorites;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.all(10),
      color: colorScheme.surface,
      height: 100,
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
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        favorites.title ?? "已失效",
                        style: TextStyle(
                          color: colorScheme.onSurface.withAlpha(200),
                          fontSize: 20,
                          fontWeight: FontWeight.w600
                        ),
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
    );
  }
}

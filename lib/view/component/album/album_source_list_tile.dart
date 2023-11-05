import 'package:flutter/material.dart';
import 'package:post_client/domain/favorites_source.dart';

class AlbumSourceListTile extends StatelessWidget {
  const AlbumSourceListTile({super.key, required this.favoritesSource});

  final FavoritesSource favoritesSource;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(top: 2),
      color: colorScheme.surface,
      height: 100,
      child: TextButton(
        onPressed: () async {},
        child: Row(
          children: [
            Container(
              width: 150,
              height: double.infinity,
              color: colorScheme.primaryContainer,
              child: Stack(
                fit: StackFit.loose,
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: colorScheme.surface,
                    child: Image(
                      image: NetworkImage(favoritesSource.coverUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withAlpha(220),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Icon(
                          Icons.image,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  )
                ],
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
                          favoritesSource.title ?? "已失效",
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

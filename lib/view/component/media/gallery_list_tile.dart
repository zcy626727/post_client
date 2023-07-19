import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:post_client/model/gallery.dart';
import 'package:post_client/view/page/gallery/gallery_detail_page.dart';

class GalleryListTile extends StatefulWidget {
  const GalleryListTile({super.key, required this.gallery, this.isInner = false});

  final Gallery gallery;
  final bool isInner;

  @override
  State<GalleryListTile> createState() => _GalleryListTileState();
}

class _GalleryListTileState extends State<GalleryListTile> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return GalleryDetailPage(
                gallery: widget.gallery,
              );
            },
          ),
        );
      },
      child: Container(
        color: colorScheme.surface,
        margin: const EdgeInsets.only(top: 2),
        child: Stack(
          fit: StackFit.loose,
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              color: colorScheme.surface,
              child: Image(
                image: NetworkImage(widget.gallery.coverUrl!),
                fit: BoxFit.cover,
              ),
            ),
            if (widget.isInner)
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
    );
  }
}

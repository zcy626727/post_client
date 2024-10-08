import 'package:flutter/material.dart';
import 'package:post_client/model/post/gallery.dart';
import 'package:post_client/view/page/gallery/gallery_detail_page.dart';

import '../../../../config/constants.dart';

class GalleryListTile extends StatefulWidget {
  const GalleryListTile({super.key, required this.gallery, this.isInner = false, this.onDeleteMedia, this.onUpdateMedia});

  final Gallery gallery;
  final bool isInner;
  final Function(Gallery)? onDeleteMedia;
  final Function(Gallery)? onUpdateMedia;

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
                onUpdateMedia: widget.onUpdateMedia,
                onDeleteMedia: widget.onDeleteMedia,
              );
            },
          ),
        );
      },
      child: SizedBox(
        height: 200,
        child: Stack(
          children: [
            Image(
              width: double.infinity,
              height: 200,
              image: NetworkImage(
                widget.gallery.coverUrl == null || widget.gallery.coverUrl!.isEmpty ? testImageUrl : widget.gallery.coverUrl!,
              ),
              fit: BoxFit.cover,
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

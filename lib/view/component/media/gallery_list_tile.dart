import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:post_client/model/gallery.dart';
import 'package:post_client/view/component/media/detail/gallery_detail_page.dart';

class GalleryListTile extends StatefulWidget {
  const GalleryListTile({super.key, required this.gallery});

  final Gallery gallery;

  @override
  State<GalleryListTile> createState() => _GalleryListTileState();
}

class _GalleryListTileState extends State<GalleryListTile> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return GalleryDetailPage(gallery: widget.gallery,);
            },
          ),
        );
      },
      child: Container(
        color: colorScheme.surface,
        child: Image(
          image: NetworkImage(widget.gallery.coverUrl!),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

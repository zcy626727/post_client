import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:post_client/model/gallery.dart';
import 'package:post_client/view/component/comment/comment_list.dart';
import 'package:post_client/view/page/comment/comment_page.dart';

import '../../../../model/comment.dart';
import '../../../../service/comment_service.dart';

class GalleryDetailPage extends StatefulWidget {
  const GalleryDetailPage({super.key, required this.gallery});

  final Gallery gallery;

  @override
  State<GalleryDetailPage> createState() => _GalleryDetailPageState();
}

class _GalleryDetailPageState extends State<GalleryDetailPage> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
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
        actions: [],
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 3, right: 3, top: 1),
        child: ListView(
          children: [
            ...List<Image>.generate(widget.gallery.thumbnailUrlList!.length, (index) {
              return Image(
                image: NetworkImage(widget.gallery.thumbnailUrlList![index]),
                fit: BoxFit.fitWidth,
              );
            }),
            ListTile(
              contentPadding: const EdgeInsets.only(left: 3, right: 3),
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              leading: CircleAvatar(radius: 18, backgroundImage: NetworkImage(widget.gallery.user!.avatarUrl!)),
              title: Text(
                widget.gallery.title!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                DateFormat("yyyy-MM-dd").format(widget.gallery.createTime!),
                style: TextStyle(
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Text(
                widget.gallery.introduction!,
                style: const TextStyle(fontSize: 15),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              height: 40,
              color: colorScheme.primaryContainer,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommentPage(commentParentType: CommentParentType.gallery, commentParentId: widget.gallery.id!)
                    ),
                  );
                },
                child: const Text("查看评论"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

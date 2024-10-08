import 'package:flutter/material.dart';

import '../../../../model/post/article.dart';
import '../../../page/article/article_detail_page.dart';

class ArticleListTile extends StatefulWidget {
  const ArticleListTile({super.key, required this.article, this.isInner = false, this.onDeleteMedia, this.onUpdateMedia});

  final Article article;
  final bool isInner;
  final Function(Article)? onDeleteMedia;
  final Function(Article)? onUpdateMedia;

  @override
  State<ArticleListTile> createState() => _ArticleListTileState();
}

class _ArticleListTileState extends State<ArticleListTile> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      child: Container(
        margin: widget.isInner ? null : const EdgeInsets.only(bottom: 1),
        color: colorScheme.surface,
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                height: double.infinity,
                margin: const EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.article.title!,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.article.introduction!,
                      style: TextStyle(color: colorScheme.onSurface.withAlpha(150)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            if (widget.article.coverUrl != null && widget.article.coverUrl!.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: Image(image: NetworkImage(widget.article.coverUrl!)),
              )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ArticleDetailPage(
                article: widget.article,
                onUpdateMedia: widget.onUpdateMedia,
                onDeleteMedia: widget.onDeleteMedia,
              );
            },
          ),
        );
      },
    );
  }
}

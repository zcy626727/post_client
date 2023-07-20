import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:post_client/config/constants.dart';
import 'package:post_client/model/media/album.dart';

class AlbumListTile extends StatefulWidget {
  const AlbumListTile({super.key, required this.album});

  final Album album;

  @override
  State<AlbumListTile> createState() => _AlbumListTileState();
}

class _AlbumListTileState extends State<AlbumListTile> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      height: 110,
      child: Row(
        children: [
          //图片
          Container(
            width: 150,
            height: double.infinity,
            color: colorScheme.primaryContainer,
            child: widget.album.coverUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image(
                      image: NetworkImage(widget.album.coverUrl!),
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    Icons.album_outlined,
                    size: 70,
                    color: colorScheme.onPrimaryContainer,
                  ),
          ),
          //
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //专辑标题
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.album.title ?? "已失效",
                        style: TextStyle(
                          color: colorScheme.onSurface.withAlpha(200),
                          fontSize: 18,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  if (widget.album.user != null)
                    Row(
                      children: [
                        ClipOval(
                          child: Image.network(
                            testImageUrl,
                            width: 32,
                            height: 32,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.album.user!.name ?? "未知用户",
                              style: TextStyle(color: colorScheme.onSurface.withAlpha(200), fontSize: 12),
                            ),
                            Text(
                              DateFormat("yyyy-MM-dd").format(widget.album.createTime!),
                              style: TextStyle(color: colorScheme.onSurface.withAlpha(150), fontSize: 10),
                            ),
                          ],
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

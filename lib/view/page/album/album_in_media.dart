import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:post_client/view/component/album/album_media_list_dialog.dart';

import '../../../model/post/album.dart';
import '../../../model/post/media.dart';
import '../../../service/post/album_service.dart';

class AlbumInMedia extends StatefulWidget {
  const AlbumInMedia({super.key, required this.albumId, required this.onChangeMedia});

  final String albumId;
  final Function(Media) onChangeMedia;

  @override
  State<AlbumInMedia> createState() => _AlbumInMediaState();
}

class _AlbumInMediaState extends State<AlbumInMedia> {
  late Future _futureBuilderFuture;
  Album? album;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
  }

  Future getData() async {
    return Future.wait([getAlbum()]);
  }

  Future<void> getAlbum() async {
    try {
      album = await AlbumService.getAlbumById(widget.albumId);
    } on DioException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(left: 2, right: 2, top: 2, bottom: 2),
      height: 40,
      child: FutureBuilder(
        future: _futureBuilderFuture,
        builder: (BuildContext context, AsyncSnapshot snapShot) {
          if (snapShot.connectionState == ConnectionState.done) {
            return ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(colorScheme.primary.withAlpha(150))),
              onPressed: () {
                //展示合集内容
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return AlbumMediaListDialog(
                      album: album!,
                      onChangeMedia: (m) async {
                        await widget.onChangeMedia(m);
                      },
                    );
                  },
                );
              },
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 4, top: 2),
                    child: Icon(
                      Icons.reorder,
                      color: colorScheme.onPrimary,
                      size: 18,
                    ),
                  ),
                  Text(
                    "合集：",
                    style: TextStyle(color: colorScheme.onPrimary, fontSize: 15),
                  ),
                  Text(
                    album?.title ?? "",
                    style: TextStyle(color: colorScheme.onPrimary, fontSize: 15),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: SizedBox(
                width: 5,
                height: 5,
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

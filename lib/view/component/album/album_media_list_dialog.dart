import 'package:flutter/material.dart';
import 'package:post_client/model/post/album.dart';
import 'package:post_client/model/post/favorites.dart';
import 'package:post_client/view/widget/common_item_list.dart';

import '../../../config/page_config.dart';
import '../../../constant/source.dart';
import '../../../model/post/article.dart';
import '../../../model/post/audio.dart';
import '../../../model/post/gallery.dart';
import '../../../model/post/media.dart';
import '../../../model/post/video.dart';
import '../../../service/post/article_service.dart';
import '../../../service/post/audio_service.dart';
import '../../../service/post/gallery_service.dart';
import '../../../service/post/video_service.dart';
import '../../widget/button/common_action_one_button.dart';

class AlbumMediaListDialog extends StatefulWidget {
  const AlbumMediaListDialog({
    Key? key,
    required this.album,
    required this.onChangeMedia,
  }) : super(key: key);

  final Function(Media) onChangeMedia;
  final Album album;

  @override
  State<AlbumMediaListDialog> createState() => _AlbumMediaListDialogState();
}

class _AlbumMediaListDialogState extends State<AlbumMediaListDialog> {
  late Future _futureBuilderFuture;
  Map<Favorites, bool> changeFavoritesMap = {};

  List<Audio> audioList = [];
  List<Video> videoList = [];
  List<Gallery> galleryList = [];
  List<Article> articleList = [];

  Future<void> loadFavoritesList() async {}

  Future getData() async {
    return Future.wait([loadFavoritesList()]);
  }

  @override
  void initState() {
    _futureBuilderFuture = getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          return _buildDialog();
        } else {
          // 请求未结束，显示loading
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildDialog() {
    var colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      contentPadding: const EdgeInsets.all(5.0),
      backgroundColor: colorScheme.surface,
      titlePadding: const EdgeInsets.only(top: 15.0, left: 10.0),
      content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return switch (widget.album.mediaType) {
          SourceType.article => SizedBox(
              width: 250,
              height: 200,
              child: CommonItemList<Article>(
                onLoad: (int page) async {
                  var articleList = await ArticleService.getArticleListByAlbumId(albumUserId: widget.album.userId!, albumId: widget.album.id!, pageSize: PageConfig.commonPageSize, pageIndex: page);
                  return articleList;
                },
                itemName: "文章",
                itemHeight: null,
                enableScrollbar: true,
                itemBuilder: (ctx, article, articleList, onFresh) {
                  return TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await widget.onChangeMedia(article);
                    },
                    child: ListTile(
                      title: Text(article.title ?? "未知名称"),
                      subtitle: Text(article.introduction ?? ""),
                      visualDensity: const VisualDensity(vertical: -4),
                    ),
                  );
                },
              )),
          SourceType.video => SizedBox(
              width: 250,
              height: 200,
              child: CommonItemList<Video>(
                onLoad: (int page) async {
                  var videoList = await VideoService.getVideoListByAlbumId(albumUserId: widget.album.userId!, albumId: widget.album.id!, pageSize: PageConfig.commonPageSize, pageIndex: page);
                  return videoList;
                },
                itemName: "视频",
                itemHeight: null,
                enableScrollbar: true,
                itemBuilder: (ctx, video, videoList, onFresh) {
                  return TextButton(
                    onPressed: () {
                      widget.onChangeMedia(video);

                      Navigator.pop(context);
                    },
                    child: ListTile(
                      title: Text(video.title ?? "未知名称"),
                      subtitle: Text(video.introduction ?? ""),
                      visualDensity: const VisualDensity(vertical: -4),
                    ),
                  );
                },
              )),
          SourceType.audio => SizedBox(
              width: 250,
              height: 200,
              child: CommonItemList<Audio>(
                onLoad: (int page) async {
                  var audioList = await AudioService.getAudioListByAlbumId(albumUserId: widget.album.userId!, albumId: widget.album.id!, pageSize: PageConfig.commonPageSize, pageIndex: page);
                  return audioList;
                },
                itemName: "音频",
                itemHeight: null,
                enableScrollbar: true,
                itemBuilder: (ctx, audio, audioList, onFresh) {
                  return TextButton(
                    onPressed: () {
                      widget.onChangeMedia(audio);
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      title: Text(audio.title ?? "未知名称"),
                      subtitle: Text(audio.introduction ?? ""),
                      visualDensity: const VisualDensity(vertical: -4),
                    ),
                  );
                },
              )),
          SourceType.gallery => SizedBox(
              width: 250,
              height: 200,
              child: CommonItemList<Gallery>(
                onLoad: (int page) async {
                  var galleryList = await GalleryService.getGalleryListByAlbumId(albumUserId: widget.album.userId!, albumId: widget.album.id!, pageSize: PageConfig.commonPageSize, pageIndex: page);
                  return galleryList;
                },
                itemName: "图集",
                itemHeight: null,
                enableScrollbar: true,
                itemBuilder: (ctx, gallery, galleryList, onFresh) {
                  return TextButton(
                    onPressed: () {
                      widget.onChangeMedia(gallery);
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      title: Text(gallery.title ?? "未知名称"),
                      subtitle: Text(gallery.introduction ?? ""),
                      visualDensity: const VisualDensity(vertical: -4),
                    ),
                  );
                },
              )),
          _ => Container()
        };
      }),
      actions: [
        CommonActionOneButton(
          title: "取消",
          onTap: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}

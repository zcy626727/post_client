import 'package:flutter/material.dart';
import 'package:post_client/constant/source.dart';

import '../../../model/article.dart';
import '../../../model/audio.dart';
import '../../../model/gallery.dart';
import '../../../model/video.dart';
import '../../../service/article_service.dart';
import '../../../service/audio_service.dart';
import '../../../service/gallery_service.dart';
import '../../../service/post_service.dart';
import '../../../service/video_service.dart';
import '../../component/media/article_list_tile.dart';
import '../../component/media/audio_list_tile.dart';
import '../../component/media/gallery_list_tile.dart';
import '../../component/media/video_list_tile.dart';
import '../../component/post/post_list.dart';
import '../../widget/common_item_list.dart';

class FavoritesListPage extends StatefulWidget {
  const FavoritesListPage({super.key});

  @override
  State<FavoritesListPage> createState() => _FavoritesListPageState();
}

class _FavoritesListPageState extends State<FavoritesListPage> {
  int _sourceType = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
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
        title: Text(
          "收藏",
          style: TextStyle(color: colorScheme.onSurface),
        ),
        actions: [],
      ),
      body: Container(
        color: colorScheme.surface,
        child: Column(
          children: [
            Container(
              height: 40,
              color: colorScheme.surface,
              padding: const EdgeInsets.only(left: 5, right: 5),
              margin: const EdgeInsets.only(bottom: 2),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  buildSourceTypeItem("全部", 0),
                  const SizedBox(width: 5),
                  buildSourceTypeItem("音频", SourceType.audio),
                  const SizedBox(width: 5),
                  buildSourceTypeItem("文章", SourceType.article),
                  const SizedBox(width: 5),
                  buildSourceTypeItem("视频", SourceType.video),
                  const SizedBox(width: 5),
                  buildSourceTypeItem("图片", SourceType.gallery),
                  const SizedBox(width: 5),
                  buildSourceTypeItem("动态", SourceType.post),
                  const SizedBox(width: 5),
                  buildSourceTypeItem("评论", SourceType.comment),
                ],
              ),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSourceTypeItem(String title, int sourceType) {
    var colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Container(
        height: 25,
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: ElevatedButton(
          onPressed: () {
            if (_sourceType == sourceType) {
              return;
            }
            setState(() {
              _sourceType = sourceType;
            });
          },
          style: ButtonStyle(
            elevation: const MaterialStatePropertyAll(0),
            backgroundColor: MaterialStatePropertyAll(
              sourceType == _sourceType ? colorScheme.inverseSurface : colorScheme.surfaceVariant,
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: sourceType == _sourceType ? colorScheme.onInverseSurface : colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

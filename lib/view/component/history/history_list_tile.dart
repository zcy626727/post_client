import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:post_client/model/post/article.dart';
import 'package:post_client/model/post/audio.dart';
import 'package:post_client/model/post/gallery.dart';
import 'package:post_client/model/post/history.dart';
import 'package:post_client/model/post/media.dart';
import 'package:post_client/model/post/video.dart';

import '../../../service/post/history_service.dart';
import '../../page/article/article_detail_page.dart';
import '../../page/audio/audio_detail_page.dart';
import '../../page/gallery/gallery_detail_page.dart';
import '../../page/video/video_detail_page.dart';
import '../../widget/dialog/confirm_alert_dialog.dart';
import '../show/show_snack_bar.dart';

class HistoryListTile extends StatelessWidget {
  const HistoryListTile({super.key, required this.history, required this.onDelete});

  final Function(History) onDelete;
  final History history;

  @override
  Widget build(BuildContext context) {
    Media media = history.media ?? Media();

    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(top: 2),
      color: colorScheme.surface,
      height: 80,
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () async {
                if (media is Gallery) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GalleryDetailPage(gallery: media)));
                } else if (media is Audio) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AudioDetailPage(audio: media)));
                } else if (media is Video) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => VideoDetailPage(video: media)));
                } else if (media is Article) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ArticleDetailPage(article: media)));
                }
              },
              child: Row(
                children: [
                  Container(
                    constraints: const BoxConstraints(maxWidth: 200),
                    height: double.infinity,
                    margin: const EdgeInsets.only(right: 5),
                    color: colorScheme.primaryContainer,
                    child: media.coverUrl != null && media.coverUrl!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image(
                              image: NetworkImage(media.coverUrl!),
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            Icons.album_outlined,
                            size: 70,
                            color: colorScheme.onPrimaryContainer,
                          ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                media.title ?? "已失效",
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
          ),
          VerticalDivider(
            color: colorScheme.onSurface.withAlpha(50),
            width: 1,
            indent: 5,
            endIndent: 5,
          ),
          SizedBox(
            height: double.infinity,
            width: 60,
            child: TextButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmAlertDialog(
                      text: "是否确定删除？",
                      onConfirm: () async {
                        try {
                          await HistoryService.deleteUserHistoryById(history.id!);
                          onDelete(history);
                        } on DioException catch (e) {
                          ShowSnackBar.exception(context: context, e: e, defaultValue: "删除失败");
                        } finally {
                          Navigator.pop(context);
                        }
                      },
                      onCancel: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
              child: Icon(
                Icons.delete_outline,
                color: colorScheme.onSurface,
              ),
            ),
          )
        ],
      ),
    );
  }
}

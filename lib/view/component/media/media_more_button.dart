import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:post_client/model/post/article.dart';
import 'package:post_client/model/post/audio.dart';
import 'package:post_client/model/post/gallery.dart';
import 'package:post_client/model/post/media.dart';
import 'package:post_client/model/post/video.dart';
import 'package:post_client/view/page/audio/audio_edit_page.dart';
import 'package:post_client/view/page/gallery/gallery_edit_page.dart';
import 'package:post_client/view/page/video/video_edit_page.dart';

import '../../../config/global.dart';
import '../../../service/post/article_service.dart';
import '../../../service/post/audio_service.dart';
import '../../../service/post/gallery_service.dart';
import '../../../service/post/video_service.dart';
import '../../page/article/article_edit_page.dart';
import '../../widget/dialog/confirm_alert_dialog.dart';
import '../show/show_snack_bar.dart';

class MediaMoreButton extends StatefulWidget {
  const MediaMoreButton({super.key, required this.media, required this.onDeleteMedia, required this.onUpdateMedia});

  final Media media;

  final Function(Media) onDeleteMedia;
  final Function(Media) onUpdateMedia;

  @override
  State<MediaMoreButton> createState() => _MediaMoreButtonState();
}

class _MediaMoreButtonState extends State<MediaMoreButton> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return PopupMenuButton<String>(
      splashRadius: 20,
      itemBuilder: (BuildContext context) {
        return [
          if (widget.media.userId == Global.user.id!)
            PopupMenuItem(
              height: 35,
              value: 'delete',
              child: Text(
                '删除',
                style: TextStyle(color: colorScheme.onBackground.withAlpha(200), fontSize: 14),
              ),
            ),
          if (widget.media.userId == Global.user.id!)
            PopupMenuItem(
              height: 35,
              value: 'edit',
              child: Text(
                '编辑',
                style: TextStyle(color: colorScheme.onBackground.withAlpha(200), fontSize: 14),
              ),
            ),
        ];
      },
      icon: Icon(Icons.more_horiz, color: colorScheme.onSurface),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          width: 1,
          color: colorScheme.onSurface.withAlpha(30),
          style: BorderStyle.solid,
        ),
      ),
      color: colorScheme.surface,
      onSelected: (value) async {
        switch (value) {
          case "delete":
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return ConfirmAlertDialog(
                  text: "是否确定删除？",
                  onConfirm: () async {
                    try {
                      Media m = widget.media;
                      if (m is Gallery) {
                        GalleryService.deleteGallery(m.id);
                      } else if (m is Video) {
                        VideoService.deleteVideo(m.id);
                      } else if (m is Audio) {
                        AudioService.deleteAudio(m.id);
                      } else if (m is Article) {
                        ArticleService.deleteArticle(m.id);
                      }
                      Navigator.pop(context);
                      await widget.onDeleteMedia(widget.media);
                    } on DioException catch (e) {
                      if (mounted) ShowSnackBar.exception(context: context, e: e, defaultValue: "删除失败");
                    } finally {}
                  },
                  onCancel: () {
                    Navigator.pop(context);
                  },
                );
              },
            );
            break;
          case "edit":
            Media m = widget.media;
            if (m is Article) {
              if (mounted) await Navigator.push(context, MaterialPageRoute(builder: (context) => ArticleEditPage(article: m, onUpdateMedia: (article) => widget.onUpdateMedia(article))));
            } else if (m is Gallery) {
              if (mounted) await Navigator.push(context, MaterialPageRoute(builder: (context) => GalleryEditPage(gallery: m, onUpdateMedia: (gallery) => widget.onUpdateMedia(gallery))));
            } else if (m is Audio) {
              if (mounted) await Navigator.push(context, MaterialPageRoute(builder: (context) => AudioEditPage(audio: m, onUpdateMedia: (audio) => widget.onUpdateMedia(audio))));
            } else if (m is Video) {
              if (mounted) await Navigator.push(context, MaterialPageRoute(builder: (context) => VideoEditPage(video: m, onUpdateMedia: (video) => widget.onUpdateMedia(video))));
            }
            await widget.onUpdateMedia(widget.media);
            break;
        }
      },
    );
  }
}

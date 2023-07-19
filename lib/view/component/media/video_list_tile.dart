import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:post_client/config/constants.dart';
import 'package:post_client/model/video.dart';
import 'package:post_client/service/video_service.dart';
import 'package:post_client/view/page/video/video_detail_page.dart';

import '../../../config/global.dart';
import '../../widget/dialog/confirm_alert_dialog.dart';
import '../show/show_snack_bar.dart';

class VideoListTile extends StatefulWidget {
  const VideoListTile({super.key, required this.video, required this.onDelete, this.isInner = false});

  final Video video;
  final Function(Video) onDelete;
  final bool isInner;

  @override
  State<VideoListTile> createState() => _VideoListTileState();
}

class _VideoListTileState extends State<VideoListTile> {
  @override
  Widget build(BuildContext context) {
    var video = widget.video;
    var colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      color: colorScheme.surface,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return VideoDetailPage(
                  video: widget.video,
                );
              },
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  Image(
                    width: double.infinity,
                    image: NetworkImage(
                      widget.video.coverUrl == null || widget.video.coverUrl!.isEmpty ? testImageUrl : widget.video.coverUrl!,
                    ),
                    fit: BoxFit.cover,
                  ),
                  if (widget.isInner)
                    Center(
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withAlpha(220),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Icon(
                          Icons.video_collection_outlined,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (!widget.isInner)
              ListTile(
                contentPadding: EdgeInsets.zero,
                visualDensity: const VisualDensity(horizontal: -2, vertical: -4),
                leading: CircleAvatar(radius: 18, backgroundImage: NetworkImage(widget.video.user!.avatarUrl!)),
                title: Text(
                  video.title!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  DateFormat("yyyy-MM-dd").format(video.createTime!),
                  style: TextStyle(
                    color: colorScheme.onSurface,
                  ),
                ),
                trailing: PopupMenuButton<String>(
                  padding: const EdgeInsets.only(left: 20),
                  splashRadius: 1,
                  itemBuilder: (BuildContext context) {
                    return [
                      if (widget.video.user!.id! == Global.user.id!)
                        PopupMenuItem(
                          height: 35,
                          value: 'delete',
                          child: Text(
                            '删除',
                            style: TextStyle(color: colorScheme.onBackground.withAlpha(200), fontSize: 14),
                          ),
                        ),
                    ];
                  },
                  icon: Icon(Icons.more_vert, color: colorScheme.onSurface),
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
                                  await VideoService.deleteVideo(widget.video.id!);
                                  widget.onDelete(widget.video);
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
                        break;
                    }
                  },
                ),
              )
          ],
        ),
      ),
    );
  }
}

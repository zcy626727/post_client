import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:post_client/model/post/history.dart';
import 'package:post_client/service/post/file_url_service.dart';
import 'package:post_client/view/widget/player/common_video_player.dart';

import '../../../constant/source.dart';
import '../../../model/post/comment.dart';
import '../../../model/post/video.dart';
import '../../../service/post/history_service.dart';
import '../../component/feedback/media_feedback_bar.dart';
import '../../component/media/media_more_button.dart';
import '../album/album_in_media.dart';
import '../comment/comment_page.dart';

class VideoDetailPage extends StatefulWidget {
  const VideoDetailPage({super.key, required this.video, this.onDeleteMedia, this.onUpdateMedia});

  final Video video;
  final Function(Video)? onDeleteMedia;
  final Function(Video)? onUpdateMedia;

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  late Future _futureBuilderFuture;
  String? videoUrl;
  late History history;
  Video video = Video();

  @override
  void initState() {
    super.initState();
    video.copyVideo(widget.video);
    _futureBuilderFuture = getData();
  }

  Future getData() async {
    return Future.wait([getVideoUrl(), getHistory()]);
  }

  Future<void> getVideoUrl() async {
    try {
      var (url, _) = await FileUrlService.genGetFileUrl(widget.video.fileId!);
      videoUrl = url;
    } on DioException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getHistory() async {
    try {
      //获取或创建历史
      history = await HistoryService.getOrCreateHistoryByMedia(widget.video.id!, SourceType.video);
    } on DioException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
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
                "视频",
                style: TextStyle(color: colorScheme.onSurface),
              ),
              actions: [
                MediaMoreButton(
                  media: video,
                  onDeleteMedia: (media) async {
                    Navigator.of(context).pop();
                    if (widget.onDeleteMedia != null) {
                      await widget.onDeleteMedia!(media as Video);
                    }
                  },
                  onUpdateMedia: (media) async {
                    video.copyVideo(media as Video);
                    if (widget.onUpdateMedia != null) {
                      await widget.onUpdateMedia!(media);
                    }
                    await getVideoUrl();
                    setState(() {});
                  },
                ),
              ],
            ),
            body: Container(
              color: colorScheme.surface,
              margin: const EdgeInsets.only(top: 1),
              padding: const EdgeInsets.only(left: 3, right: 3),
              child: ListView(
                children: [
                  AspectRatio(
                    aspectRatio: 1.8,
                    child: Container(
                      color: colorScheme.background,
                      child: videoUrl == null
                          ? const Center(
                              child: Text("视频加载失败"),
                            )
                          : CommonVideoPlayer(key: ValueKey(videoUrl), videoUrl: videoUrl!),
                    ),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.only(left: 3, right: 3),
                    visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                    leading: CircleAvatar(radius: 18, backgroundImage: NetworkImage(video.user!.avatarUrl!)),
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
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Text(
                      video.introduction!,
                      style: TextStyle(fontSize: 15, color: colorScheme.onSurface),
                    ),
                  ),
                  if (video.hasAlbum())
                    AlbumInMedia(
                      albumId: video.albumId!,
                      onChangeMedia: (media) async {
                        var newVideo = media as Video;
                        video = newVideo;
                        var (url, _) = await FileUrlService.genGetFileUrl(video.fileId!);
                        videoUrl = url;
                        setState(() {});
                      },
                    ),
                  MediaFeedbackBar(
                    mediaType: SourceType.video,
                    mediaId: video.id!,
                    media: video,
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
                            builder: (context) => CommentPage(
                              commentParentType: CommentParentType.video,
                              commentParentId: video.id!,
                              parentUserId: video.userId!,
                            ),
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
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          );
        }
      },
    );
  }
}

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:post_client/model/audio.dart';
import 'package:post_client/view/widget/player/audio/common_audio_player_mini.dart';

import '../../../constant/media.dart';
import '../../../model/comment.dart';
import '../../../model/media_feedback.dart';
import '../../../service/file_service.dart';
import '../../../service/media_feedback_service.dart';
import '../../component/feedback/media_feedback_bar.dart';
import '../../component/feedback/media_feedback_button.dart';
import '../comment/comment_page.dart';

class AudioDetailPage extends StatefulWidget {
  const AudioDetailPage({super.key, required this.audio});

  final Audio audio;

  @override
  State<AudioDetailPage> createState() => _AudioDetailPageState();
}

class _AudioDetailPageState extends State<AudioDetailPage> {
  late Future _futureBuilderFuture;
  String? audioUrl;

  MediaFeedback _mediaFeedback = MediaFeedback();

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
  }

  Future getData() async {
    return Future.wait([getAudioUrl()]);
  }

  Future<void> getAudioUrl() async {
    try {
      var (url, _) = await FileService.genGetFileUrl(widget.audio.fileId!);
      audioUrl = url;
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
              actions: [],
            ),
            body: Container(
              color: colorScheme.surface,
              margin: const EdgeInsets.only(left: 3, right: 3, top: 1),
              child: ListView(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.only(left: 3, right: 3),
                    visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                    leading: CircleAvatar(radius: 18, backgroundImage: NetworkImage(widget.audio.user!.avatarUrl!)),
                    title: Text(
                      widget.audio.title!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      DateFormat("yyyy-MM-dd").format(widget.audio.createTime!),
                      style: TextStyle(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Text(
                      widget.audio.introduction!,
                      style: TextStyle(fontSize: 15, color: colorScheme.onSurface),
                    ),
                  ),
                  CommonAudioPlayerMini(audioUrl: audioUrl!),
                  MediaFeedbackBar(
                    mediaType: MediaType.article,
                    mediaId: widget.audio.id!,
                    media: widget.audio,
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
                                    commentParentType: CommentParentType.audio,
                                    commentParentId: widget.audio.id!,
                                    parentUserId: widget.audio.userId!,
                                  )),
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

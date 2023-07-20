import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:post_client/model/media/media.dart';

import '../../../model/media/media_feedback.dart';
import '../../../service/media/media_feedback_service.dart';
import 'media_feedback_button.dart';

class MediaFeedbackBar extends StatefulWidget {
  const MediaFeedbackBar({
    super.key,
    required this.mediaType,
    required this.mediaId,
    required this.media,
  });

  final Media media;
  final int mediaType;
  final String mediaId;

  @override
  State<MediaFeedbackBar> createState() => _MediaFeedbackBarState();
}

class _MediaFeedbackBarState extends State<MediaFeedbackBar> {
  late Future _futureBuilderFuture;
  MediaFeedback _mediaFeedback = MediaFeedback();

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
  }

  Future getData() async {
    return Future.wait([getMediaFeedback()]);
  }

  Future<void> getMediaFeedback() async {
    try {
      _mediaFeedback = await MediaFeedbackService.getMediaFeedback(widget.mediaType, widget.mediaId);
      //获取下载信息
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
          return Container(
            color: colorScheme.primary,
            margin: const EdgeInsets.symmetric(
              vertical: 5,
            ),
            child: Material(
              color: colorScheme.surface,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MediaFeedbackButton(
                    iconData: Icons.thumb_up_alt,
                    selected: _mediaFeedback.like ?? false,
                    text: "${widget.media.likeNum ?? 0}",
                    onPressed: () async {
                      if (_mediaFeedback.like == true) {
                        _mediaFeedback = await MediaFeedbackService.uploadMediaFeedback(mediaType: widget.mediaType, mediaId: widget.mediaId, like: -1);
                        widget.media.likeNum = (widget.media.likeNum ?? 0) - 1;
                      } else {
                        _mediaFeedback = await MediaFeedbackService.uploadMediaFeedback(mediaType: widget.mediaType, mediaId: widget.mediaId, like: 1);
                        widget.media.likeNum = (widget.media.likeNum ?? 0) + 1;
                      }
                      setState(() {});
                    },
                  ),
                  MediaFeedbackButton(
                    iconData: Icons.thumb_down_alt,
                    selected: _mediaFeedback.dislike ?? false,
                    text: "${widget.media.dislikeNum ?? 0}",
                    onPressed: () async {
                      if (_mediaFeedback.dislike == true) {
                        _mediaFeedback = await MediaFeedbackService.uploadMediaFeedback(mediaType: widget.mediaType, mediaId: widget.mediaId, dislike: -1);
                        widget.media.dislikeNum = (widget.media.dislikeNum ?? 0) - 1;
                      } else {
                        _mediaFeedback = await MediaFeedbackService.uploadMediaFeedback(mediaType: widget.mediaType, mediaId: widget.mediaId, dislike: 1);
                        widget.media.dislikeNum = (widget.media.dislikeNum ?? 0) + 1;
                      }
                      setState(() {});
                    },
                  ),
                  MediaFeedbackButton(
                    iconData: Icons.star,
                    selected: _mediaFeedback.favorites ?? false,
                    text: "${widget.media.favoritesNum ?? 0}",
                    onPressed: () async {
                      setState(() {});
                    },
                  ),
                  MediaFeedbackButton(
                    iconData: Icons.download_for_offline,
                    selected: false,
                    text: "下载",
                    fontSize: 12,
                    onPressed: () async {
                      setState(() {});
                    },
                  ),
                  MediaFeedbackButton(
                    iconData: Icons.screen_share,
                    selected: _mediaFeedback.share ?? false,
                    text: "${widget.media.shareNum ?? 0}",
                    onPressed: () async {
                      if (_mediaFeedback.share != true) {
                        _mediaFeedback = await MediaFeedbackService.uploadMediaFeedback(mediaType: widget.mediaType, mediaId: widget.mediaId, share: 1);
                        widget.media.shareNum = (widget.media.shareNum ?? 0) + 1;
                      }
                      setState(() {});
                    },
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

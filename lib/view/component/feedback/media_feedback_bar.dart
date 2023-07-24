import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:post_client/config/global.dart';
import 'package:post_client/constant/media.dart';
import 'package:post_client/model/media/media.dart';
import 'package:post_client/state/user_state.dart';
import 'package:provider/provider.dart';

import '../../../constant/source.dart';
import '../../../model/media/media_feedback.dart';
import '../../../service/media/media_feedback_service.dart';
import '../favorites/select_favorites_dialog.dart';
import '../show/show_snack_bar.dart';
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
      _mediaFeedback = (await MediaFeedbackService.getMediaFeedback(widget.mediaType, widget.mediaId)) ?? MediaFeedback();
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
                      if (Global.user.id == null) {
                        //显示登录页
                        Navigator.pushNamed(context, "login");
                      } else {
                        if (_mediaFeedback.like == true) {
                          _mediaFeedback = await MediaFeedbackService.uploadMediaFeedback(mediaType: widget.mediaType, mediaId: widget.mediaId, like: -1);
                          widget.media.likeNum = (widget.media.likeNum ?? 0) - 1;
                        } else {
                          _mediaFeedback = await MediaFeedbackService.uploadMediaFeedback(mediaType: widget.mediaType, mediaId: widget.mediaId, like: 1);
                          widget.media.likeNum = (widget.media.likeNum ?? 0) + 1;
                        }
                        setState(() {});
                      }
                    },
                  ),
                  MediaFeedbackButton(
                    iconData: Icons.thumb_down_alt,
                    selected: _mediaFeedback.dislike ?? false,
                    text: "${widget.media.dislikeNum ?? 0}",
                    onPressed: () async {
                      if (Global.user.id == null) {
                        //显示登录页
                        Navigator.pushNamed(context, "login");
                      } else {
                        if (_mediaFeedback.dislike == true) {
                          _mediaFeedback = await MediaFeedbackService.uploadMediaFeedback(mediaType: widget.mediaType, mediaId: widget.mediaId, dislike: -1);
                          widget.media.dislikeNum = (widget.media.dislikeNum ?? 0) - 1;
                        } else {
                          _mediaFeedback = await MediaFeedbackService.uploadMediaFeedback(mediaType: widget.mediaType, mediaId: widget.mediaId, dislike: 1);
                          widget.media.dislikeNum = (widget.media.dislikeNum ?? 0) + 1;
                        }
                      }

                      setState(() {});
                    },
                  ),
                  MediaFeedbackButton(
                    iconData: Icons.star,
                    selected: _mediaFeedback.favorites == null ? false : _mediaFeedback.favorites! > 0,
                    text: "${widget.media.favoritesNum ?? 0}",
                    onPressed: () async {
                      if (Global.user.id == null) {
                        //显示登录页
                        Navigator.pushNamed(context, "login");
                      } else {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            var sourceType = SourceType.gallery;

                            switch (widget.mediaType) {
                              case MediaType.article:
                                sourceType = SourceType.article;
                              case MediaType.audio:
                                sourceType = SourceType.audio;
                              case MediaType.video:
                                sourceType = SourceType.video;
                            }
                            return SelectFavoritesDialog(
                              onConfirm: (count) async {
                                try {
                                  _mediaFeedback.favorites = (_mediaFeedback.favorites ?? 0) + count;
                                  widget.media.favoritesNum = (widget.media.favoritesNum ?? 0) + count;
                                  setState(() {});
                                } on Exception catch (e) {
                                  ShowSnackBar.exception(context: context, e: e, defaultValue: "收藏出错");
                                } finally {
                                  Navigator.pop(context);
                                }
                              },
                              sourceType: sourceType,
                              sourceId: widget.mediaId,
                            );
                          },
                        );
                      }

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
                      if (Global.user.id == null) {
                        //todo 显示登录页

                      } else {
                        if (_mediaFeedback.share != true) {
                          _mediaFeedback = await MediaFeedbackService.uploadMediaFeedback(mediaType: widget.mediaType, mediaId: widget.mediaId, share: 1);
                          widget.media.shareNum = (widget.media.shareNum ?? 0) + 1;
                        }
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

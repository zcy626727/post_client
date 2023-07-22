import 'package:flutter/material.dart';
import 'package:post_client/constant/feed.dart';
import 'package:post_client/constant/source.dart';
import 'package:post_client/model/message/feed.dart';
import 'package:post_client/model/message/feed_feedback.dart';

import '../../../service/message/feed_feedback_service.dart';
import '../favorites/select_favorites_dialog.dart';
import '../show/show_snack_bar.dart';
import 'feed_feedback_button.dart';

class FeedFeedbackBar extends StatefulWidget {
  const FeedFeedbackBar({
    super.key,
    required this.feedType,
    required this.feed,
    required this.feedFeedback,
    required this.feedId,
    this.iconSize,
  });

  final Feed feed;
  final FeedFeedback feedFeedback;
  final int feedType;
  final String feedId;
  final double? iconSize;

  @override
  State<FeedFeedbackBar> createState() => _FeedFeedbackBarState();
}

class _FeedFeedbackBarState extends State<FeedFeedbackBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

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
            FeedFeedbackButton(
              iconData: Icons.thumb_up_alt,
              iconSize: widget.iconSize,
              selected: widget.feedFeedback.like ?? false,
              text: "${widget.feed.likeNum ?? 0}",
              onPressed: () async {
                FeedFeedback? feedFeedback;
                if (widget.feedFeedback.like == true) {
                  feedFeedback = await FeedFeedbackService.uploadFeedFeedback(mediaType: widget.feedType, mediaId: widget.feedId, like: -1);
                  widget.feed.likeNum = (widget.feed.likeNum ?? 0) - 1;
                } else {
                  feedFeedback = await FeedFeedbackService.uploadFeedFeedback(mediaType: widget.feedType, mediaId: widget.feedId, like: 1);
                  widget.feed.likeNum = (widget.feed.likeNum ?? 0) + 1;
                }
                widget.feedFeedback.copy(feedFeedback);
                setState(() {});
              },
            ),
            FeedFeedbackButton(
              iconData: Icons.star,
              iconSize: widget.iconSize,
              selected: widget.feedFeedback.favorites == null ? false : widget.feedFeedback.favorites! > 0,
              text: "${widget.feed.favoritesNum ?? 0}",
              onPressed: () async {
                //弹出列表
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    var sourceType = SourceType.comment;

                    switch (widget.feedType) {
                      case FeedType.post:
                        sourceType = SourceType.post;
                    }
                    return SelectFavoritesDialog(
                      onConfirm: (count) async {
                        try {
                          widget.feedFeedback.favorites = (widget.feedFeedback.favorites ?? 0) + count;
                          widget.feed.favoritesNum = (widget.feed.favoritesNum??0) + count;
                          setState(() {});
                        } on Exception catch (e) {
                          ShowSnackBar.exception(context: context, e: e, defaultValue: "收藏出错");
                        } finally {
                          Navigator.pop(context);
                        }
                      },
                      sourceType: sourceType,
                      sourceId: widget.feedId,
                    );
                  },
                );
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}

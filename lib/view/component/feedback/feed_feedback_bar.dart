import 'package:flutter/material.dart';
import 'package:post_client/model/message/feed.dart';
import 'package:post_client/model/message/feed_feedback.dart';

import '../../../service/message/feed_feedback_service.dart';
import 'feed_feedback_button.dart';

class FeedFeedbackBar extends StatefulWidget {
  const FeedFeedbackBar({
    super.key,
    required this.feedType,
    required this.feed,
    required this.feedFeedback,
    required this.feedId,
  });

  final Feed feed;
  final FeedFeedback feedFeedback;
  final int feedType;
  final String feedId;

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
              selected: widget.feedFeedback.like ?? false,
              text: "${widget.feed.likeNum ?? 0}",
              onPressed: () async {
                FeedFeedback? feedFeedback;
                if (widget.feedFeedback.like == true) {
                  feedFeedback = await FeedFeedbackService.uploadMediaFeedback(mediaType: widget.feedType, mediaId: widget.feedId, like: -1);
                  widget.feed.likeNum = (widget.feed.likeNum ?? 0) - 1;
                } else {
                  feedFeedback = await FeedFeedbackService.uploadMediaFeedback(mediaType: widget.feedType, mediaId: widget.feedId, like: 1);
                  widget.feed.likeNum = (widget.feed.likeNum ?? 0) + 1;
                }
                widget.feedFeedback.copy(feedFeedback);
                setState(() {});
              },
            ),
            FeedFeedbackButton(
              iconData: Icons.star,
              selected: widget.feedFeedback.favorites ?? false,
              text: "${widget.feed.favoritesNum ?? 0}",
              onPressed: () async {
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}

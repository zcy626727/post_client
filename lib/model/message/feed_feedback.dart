import 'package:json_annotation/json_annotation.dart';

part 'feed_feedback.g.dart';

@JsonSerializable()
class FeedFeedback {
  String? id;
  bool? like;
  bool? dislike;
  bool? favorites;
  bool? share;
  int? feedType;
  List<String>? feedIdList;

  FeedFeedback();

  factory FeedFeedback.fromJson(Map<String, dynamic> json) => _$FeedFeedbackFromJson(json);

  Map<String, dynamic> toJson() => _$FeedFeedbackToJson(this);

  void copy(FeedFeedback feedback) {
    id = feedback.id;
    like = feedback.like;
    dislike = feedback.dislike;
    favorites = feedback.favorites;
    share = feedback.share;
    feedType = feedback.feedType;
    feedIdList = feedback.feedIdList;
  }
}
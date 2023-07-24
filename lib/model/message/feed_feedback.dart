import 'package:json_annotation/json_annotation.dart';

part 'feed_feedback.g.dart';

@JsonSerializable()
class FeedFeedback {
  String? id;
  bool? like;
  bool? dislike;
  int? favorites;
  bool? share;
  int? feedType;
  String? feedId;

  FeedFeedback();

  factory FeedFeedback.fromJson(Map<String, dynamic> json) => _$FeedFeedbackFromJson(json);

  Map<String, dynamic> toJson() => _$FeedFeedbackToJson(this);

  void copy(FeedFeedback? feedback) {
    if(feedback==null){
      return;
    }
    id = feedback.id;
    like = feedback.like;
    dislike = feedback.dislike;
    favorites = feedback.favorites;
    share = feedback.share;
    feedType = feedback.feedType;
    feedId = feedback.feedId;
  }
}
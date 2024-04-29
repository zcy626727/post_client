import 'package:json_annotation/json_annotation.dart';

part 'feedback.g.dart';

@JsonSerializable()
class Feedback {
  String? id;
  bool? like;
  bool? dislike;
  int? favorites;
  bool? share;
  int? sourceType;
  String? sourceId;

  // ?
  List<String>? sourceIdList;

  Feedback();

  factory Feedback.fromJson(Map<String, dynamic> json) => _$FeedbackFromJson(json);

  Map<String, dynamic> toJson() => _$FeedbackToJson(this);

  void copy(Feedback? feedback) {
    if (feedback == null) {
      return;
    }
    id = feedback.id;
    like = feedback.like;
    dislike = feedback.dislike;
    favorites = feedback.favorites;
    share = feedback.share;
    sourceType = feedback.sourceType;
    sourceId = feedback.sourceId;
  }
}
import 'package:json_annotation/json_annotation.dart';

part 'media_feedback.g.dart';

@JsonSerializable()
class MediaFeedback {
  String? id;
  bool? like;
  bool? dislike;
  bool? favorites;
  bool? share;
  int? mediaType;
  List<String>? mediaIdList;

  MediaFeedback();

  factory MediaFeedback.fromJson(Map<String, dynamic> json) => _$MediaFeedbackFromJson(json);

  Map<String, dynamic> toJson() => _$MediaFeedbackToJson(this);
}
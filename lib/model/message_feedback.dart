import 'package:json_annotation/json_annotation.dart';

part 'message_feedback.g.dart';

@JsonSerializable()
class MessageFeedback {
  String? id;
  bool? like;
  bool? dislike;
  bool? favorites;
  bool? share;
  int? messageType;
  List<String>? messageIdList;

  MessageFeedback();

  factory MessageFeedback.fromJson(Map<String, dynamic> json) => _$MessageFeedbackFromJson(json);

  Map<String, dynamic> toJson() => _$MessageFeedbackToJson(this);
}
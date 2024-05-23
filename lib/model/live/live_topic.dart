import 'package:json_annotation/json_annotation.dart';

part 'live_topic.g.dart';

@JsonSerializable()
class LiveTopic {
  int? id;
  int? name;

  LiveTopic();

  void copyLiveTopic(LiveTopic category) {
    id = category.id;
  }

  factory LiveTopic.fromJson(Map<String, dynamic> json) => _$LiveTopicFromJson(json);

  Map<String, dynamic> toJson() => _$LiveTopicToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

import 'media.dart';

part 'mention.g.dart';

@JsonSerializable()
class Mention extends Media{
  String? id;
  int? userId;
  int? mediaType;
  List<String>? mediaIdList;
  DateTime? createTime;

  Mention();

  factory Mention.fromJson(Map<String, dynamic> json) => _$MentionFromJson(json);

  Map<String, dynamic> toJson() => _$MentionToJson(this);
}
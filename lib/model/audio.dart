import 'package:json_annotation/json_annotation.dart';
import 'package:post_client/model/media.dart';
import 'package:post_client/model/user.dart';

part 'audio.g.dart';

@JsonSerializable()
class Audio extends Media{
  String? id;
  int? userId;
  String? md5;
  String? title;
  String? introduction;
  DateTime? createTime;

  @JsonKey(includeFromJson: false, includeToJson: false)
  User? user;

  Audio();

  factory Audio.fromJson(Map<String, dynamic> json) => _$AudioFromJson(json);

  Map<String, dynamic> toJson() => _$AudioToJson(this);
}
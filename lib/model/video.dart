import 'package:json_annotation/json_annotation.dart';
import 'package:post_client/model/user.dart';

import 'media.dart';

part 'video.g.dart';

@JsonSerializable()
class Video extends Media {
  String? id;
  int? userId;
  String? md5;
  String? title;
  int? fileId;
  String? introduction;
  DateTime? createTime;
  String? coverUrl;

  @JsonKey(includeFromJson: false, includeToJson: false)
  User? user;

  Video();

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);

  Map<String, dynamic> toJson() => _$VideoToJson(this);
}

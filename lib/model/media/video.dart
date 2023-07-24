import 'package:json_annotation/json_annotation.dart';
import 'package:post_client/model/user/user.dart';

import 'media.dart';

part 'video.g.dart';

@JsonSerializable()
class Video extends Media {
  String? id;
  String? md5;
  int? fileId;

  @JsonKey(includeFromJson: false, includeToJson: false)
  User? user;

  Video();

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);

  Map<String, dynamic> toJson() => _$VideoToJson(this);
}

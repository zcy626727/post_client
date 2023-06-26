import 'package:json_annotation/json_annotation.dart';
import 'package:post_client/model/media.dart';
import 'package:post_client/model/user.dart';

part 'image.g.dart';

@JsonSerializable()
class Image extends Media{
  String? id;
  int? userId;
  String? md5;
  String? title;
  String? introduction;
  DateTime? createTime;
  String? thumbnailUrl;

  @JsonKey(includeFromJson: false, includeToJson: false)
  User? user;

  Image();

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);

  Map<String, dynamic> toJson() => _$ImageToJson(this);
}
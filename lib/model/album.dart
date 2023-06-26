import 'package:json_annotation/json_annotation.dart';
import 'package:post_client/model/user.dart';

import 'media.dart';

part 'album.g.dart';

@JsonSerializable()
class Album{
  String? id;
  int? userId;
  String? title;
  String? introduction;
  DateTime? createTime;
  int? mediaType;
  List<String>? mediaIdList;



  @JsonKey(includeFromJson: false, includeToJson: false)
  User? user;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<Media>? mediaList;

  Album();

  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumToJson(this);
}
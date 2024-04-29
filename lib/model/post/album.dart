import 'package:json_annotation/json_annotation.dart';
import 'package:post_client/model/user/user.dart';

import 'media.dart';

part 'album.g.dart';

@JsonSerializable()
class Album {
  String? id;
  int? userId;
  String? title;
  String? introduction;
  String? coverUrl;
  DateTime? createTime;
  int? mediaType;
  List<String>? mediaIdList;

  @JsonKey(includeFromJson: false, includeToJson: false)
  User? user;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<Media>? mediaList;

  Album();

  void copyAlbum(Album album) {
    id = album.id;
    userId = album.userId;
    title = album.title;
    introduction = album.introduction;
    coverUrl = album.coverUrl;
    createTime = album.createTime;
    mediaType = album.mediaType;
    mediaIdList = album.mediaIdList;
  }

  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumToJson(this);
}

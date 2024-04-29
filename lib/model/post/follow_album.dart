import 'package:json_annotation/json_annotation.dart';
import 'package:post_client/model/post/album.dart';

import '../user/user.dart';

part 'follow_album.g.dart';

@JsonSerializable()
class FollowAlbum {
  String? id;
  String? albumId;
  int? userId;

  @JsonKey(includeFromJson: true, includeToJson: false)
  Album? album;

  @JsonKey(includeFromJson: false, includeToJson: false)
  User? user;

  FollowAlbum();

  void copyFollowAlbum(FollowAlbum followAlbum) {
    id = followAlbum.id;
    albumId = followAlbum.albumId;
    userId = followAlbum.userId;
    album = followAlbum.album;
  }

  factory FollowAlbum.fromJson(Map<String, dynamic> json) => _$FollowAlbumFromJson(json);

  Map<String, dynamic> toJson() => _$FollowAlbumToJson(this);
}

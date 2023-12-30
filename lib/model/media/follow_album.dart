import 'package:json_annotation/json_annotation.dart';
import 'package:post_client/model/media/album.dart';

part 'follow_album.g.dart';

@JsonSerializable()
class FollowAlbum {
  String? id;
  String? albumId;
  int? userId;

  @JsonKey(includeFromJson: false, includeToJson: false)
  Album? album;

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

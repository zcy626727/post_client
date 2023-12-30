import 'package:json_annotation/json_annotation.dart';

import 'favorites.dart';

part 'follow_favorites.g.dart';

@JsonSerializable()
class FollowFavorites {
  String? id;
  String? favoritesId;
  int? userId;

  @JsonKey(includeFromJson: false, includeToJson: false)
  Favorites? favorites;

  FollowFavorites();

  void copyFollowAlbum(FollowFavorites followFavorites) {
    id = followFavorites.id;
    favoritesId = followFavorites.favoritesId;
    userId = followFavorites.userId;
    favorites = followFavorites.favorites;
  }

  factory FollowFavorites.fromJson(Map<String, dynamic> json) => _$FollowFavoritesFromJson(json);

  Map<String, dynamic> toJson() => _$FollowFavoritesToJson(this);
}

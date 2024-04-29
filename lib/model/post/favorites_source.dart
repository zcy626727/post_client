import 'package:json_annotation/json_annotation.dart';

import 'favorites.dart';

part 'favorites_source.g.dart';

@JsonSerializable()
class FavoritesSource {
  String? id;
  String? favoritesId;
  String? sourceId;
  int? userId;

  @JsonKey(includeFromJson: true, includeToJson: false)
  Favorites? favorites;

  FavoritesSource();

  void copyFavoritesSource(FavoritesSource followFavorites) {
    id = followFavorites.id;
    favoritesId = followFavorites.favoritesId;
    sourceId = followFavorites.sourceId;
    userId = followFavorites.userId;
    favorites = followFavorites.favorites;
  }

  factory FavoritesSource.fromJson(Map<String, dynamic> json) => _$FavoritesSourceFromJson(json);

  Map<String, dynamic> toJson() => _$FavoritesSourceToJson(this);
}

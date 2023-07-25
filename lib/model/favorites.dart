import 'package:json_annotation/json_annotation.dart';

part 'favorites.g.dart';

@JsonSerializable()
class Favorites {
  String? id;
  int? userId;
  String? title;
  String? introduction;
  String? coverUrl;
  DateTime? createTime;
  int? sourceType;
  List<String>? sourceIdList;

  Favorites();

  void copyFavorites(Favorites newFavorites) {
    id = newFavorites.id;
    userId = newFavorites.userId;
    title = newFavorites.title;
    introduction = newFavorites.introduction;
    coverUrl = newFavorites.coverUrl;
    createTime = newFavorites.createTime;
    sourceType = newFavorites.sourceType;
    sourceIdList = newFavorites.sourceIdList;
  }

  factory Favorites.fromJson(Map<String, dynamic> json) => _$FavoritesFromJson(json);

  Map<String, dynamic> toJson() => _$FavoritesToJson(this);
}

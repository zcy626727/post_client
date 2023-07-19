import 'package:json_annotation/json_annotation.dart';

part 'media_favorites.g.dart';

@JsonSerializable()
class MediaFavorites {
  String? id;
  int? userId;
  String? title;
  String? introduction;
  String? coverUrl;
  int? sourceType;
  List<String>? sourceIdList;
  DateTime? createTime;

  MediaFavorites();

  factory MediaFavorites.fromJson(Map<String, dynamic> json) => _$MediaFavoritesFromJson(json);

  Map<String, dynamic> toJson() => _$MediaFavoritesToJson(this);
}

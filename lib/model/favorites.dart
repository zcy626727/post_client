import 'package:json_annotation/json_annotation.dart';


part 'favorites.g.dart';

@JsonSerializable()
class Favorites{
  String? id;
  int? userId;
  int? mediaType;
  List<String>? mediaIdList;
  DateTime? createTime;

  Favorites();

  factory Favorites.fromJson(Map<String, dynamic> json) => _$FavoritesFromJson(json);

  Map<String, dynamic> toJson() => _$FavoritesToJson(this);
}
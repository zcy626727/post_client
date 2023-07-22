import 'package:json_annotation/json_annotation.dart';

part 'favorites.g.dart';

@JsonSerializable()
class Favorites{
  String? id;
  int? userId;
  String? title;
  String? introduction;
  String? coverUrl;
  DateTime? createTime;
  int? sourceType;
  List<String>? sourceIdList;

  Favorites();

  factory Favorites.fromJson(Map<String, dynamic> json) => _$FavoritesFromJson(json);

  Map<String, dynamic> toJson() => _$FavoritesToJson(this);

}
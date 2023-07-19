
import 'package:json_annotation/json_annotation.dart';

part 'message_favorites.g.dart';

@JsonSerializable()
class MessageFavorites {
  String? id;
  int? userId;
  String? title;
  String? introduction;
  String? coverUrl;
  int? messageType;
  List<String>? messageIdList;
  DateTime? createTime;

  MessageFavorites();

  factory MessageFavorites.fromJson(Map<String, dynamic> json) => _$MessageFavoritesFromJson(json);

  Map<String, dynamic> toJson() => _$MessageFavoritesToJson(this);
}
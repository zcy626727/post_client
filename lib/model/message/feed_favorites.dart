
import 'package:json_annotation/json_annotation.dart';

part 'feed_favorites.g.dart';

@JsonSerializable()
class FeedFavorites {
  String? id;
  int? userId;
  String? title;
  String? introduction;
  String? coverUrl;
  int? feedType;
  List<String>? feedIdList;
  DateTime? createTime;

  FeedFavorites();

  factory FeedFavorites.fromJson(Map<String, dynamic> json) => _$FeedFavoritesFromJson(json);

  Map<String, dynamic> toJson() => _$FeedFavoritesToJson(this);
}
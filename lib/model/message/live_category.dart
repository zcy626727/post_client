import 'package:json_annotation/json_annotation.dart';

part 'live_category.g.dart';

@JsonSerializable()
class LiveCategory {
  int? id;
  String? name;
  String? avatarUrl;

  LiveCategory();

  void copyLiveCategory(LiveCategory category) {
    id = category.id;
  }

  factory LiveCategory.fromJson(Map<String, dynamic> json) => _$LiveCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$LiveCategoryToJson(this);

  LiveCategory.all({this.id, this.name, this.avatarUrl});
}

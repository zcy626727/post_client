import 'package:json_annotation/json_annotation.dart';

part 'live_category.g.dart';

@JsonSerializable()
class LiveCategory {
  String? id;

  LiveCategory();

  void copyLiveCategory(LiveCategory category) {
    id = category.id;
  }

  factory LiveCategory.fromJson(Map<String, dynamic> json) => _$LiveCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$LiveCategoryToJson(this);
}

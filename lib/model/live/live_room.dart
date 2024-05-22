import 'package:json_annotation/json_annotation.dart';

part 'live_room.g.dart';

@JsonSerializable()
class LiveRoom {
  int? id;
  int? anchorId;
  int? categoryId;
  int? status;
  String? name;

  LiveRoom();

  void copyLiveCategory(LiveRoom category) {
    id = category.id;
    anchorId = category.anchorId;
    categoryId = category.categoryId;
    status = category.status;
    name = category.name;
  }

  factory LiveRoom.fromJson(Map<String, dynamic> json) => _$LiveRoomFromJson(json);

  Map<String, dynamic> toJson() => _$LiveRoomToJson(this);
}

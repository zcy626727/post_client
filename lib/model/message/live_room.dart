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

  void copyLiveCategory(LiveRoom room) {
    id = room.id;
    anchorId = room.anchorId;
    categoryId = room.categoryId;
    status = room.status;
    name = room.name;
  }

  LiveRoom.one() {
    id = 1;
    anchorId = 1;
    categoryId = 1;
    status = 1;
    name = "name";
  }

  factory LiveRoom.fromJson(Map<String, dynamic> json) => _$LiveRoomFromJson(json);

  Map<String, dynamic> toJson() => _$LiveRoomToJson(this);
}

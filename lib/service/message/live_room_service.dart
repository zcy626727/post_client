import '../../api/client/message/live_room_api.dart';
import '../../model/message/live_room.dart';

class LiveRoomService {
  static Future<(String, LiveRoom)> openRoom() async {
    return await LiveRoomApi.openRoom();
  }

  static Future<void> closeRoom() async {
    await LiveRoomApi.closeRoom();
  }

  static Future<String> getJoinRoomToken({required int roomId}) async {
    return await LiveRoomApi.getJoinRoomToken(roomId: roomId);
  }

  static Future<LiveRoom> saveRoom({
    required int categoryId,
    required int roomId,
    required String name,
  }) async {
    return await LiveRoomApi.saveRoom(categoryId: categoryId, name: name);
  }

  static Future<List<LiveRoom>> getRoomListRandom({
    int pageIndex = 0,
    int pageSize = 20,
  }) async {
    return await LiveRoomApi.getRoomListRandom(pageIndex: pageIndex, pageSize: pageSize);
  }

  static Future<List<LiveRoom>> getRoomListByCategory({
    required int categoryId,
    int pageIndex = 0,
    int pageSize = 20,
  }) async {
    return await LiveRoomApi.getRoomListByCategory(categoryId: categoryId, pageIndex: pageIndex, pageSize: pageSize);
  }

  static Future<LiveRoom> getRoomByAnchor() async {
    return await LiveRoomApi.getRoomByAnchor();
  }
}

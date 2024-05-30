import 'package:dio/dio.dart';
import 'package:post_client/api/client/message_http_config.dart';

import '../../../model/message/live_room.dart';

class LiveRoomApi {
  static Future<(String, LiveRoom)> openRoom() async {
    var r = await MessageHttpConfig.dio.post(
      "/liveRoom/openRoom",
      data: {},
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    return (r.data['token'].toString(), LiveRoom.fromJson(r.data['room']));
  }

  static Future<void> closeRoom() async {
    var r = await MessageHttpConfig.dio.post(
      "/liveRoom/closeRoom",
      data: {},
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<String> getJoinRoomToken({required int roomId}) async {
    var r = await MessageHttpConfig.dio.get(
      "/liveRoom/getJoinRoomToken",
      data: {"roomId": roomId},
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    return r.data['token'].toString();
  }

  static Future<LiveRoom> saveRoom({
    required int categoryId,
    required String name,
  }) async {
    var r = await MessageHttpConfig.dio.post(
      "/liveRoom/saveRoom",
      data: {"categoryId": categoryId, "roomName": name},
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    return LiveRoom.fromJson(r.data['room']);
  }

  static Future<List<LiveRoom>> getRoomListRandom({
    required int pageIndex,
    required int pageSize,
  }) async {
    var r = await MessageHttpConfig.dio.get(
      "/liveRoom/getRoomListRandom",
      data: {
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    return _parseLiveRoomList(r);
  }

  static Future<List<LiveRoom>> getRoomListByCategory({
    required int categoryId,
    required int pageIndex,
    required int pageSize,
  }) async {
    var r = await MessageHttpConfig.dio.get(
      "/liveRoom/getRoomListByCategory",
      data: {
        "pageIndex": pageIndex,
        "categoryId": categoryId,
        "pageSize": pageSize,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    return _parseLiveRoomList(r);
  }

  static Future<LiveRoom> getRoomByAnchor({
    int pageIndex = 0,
    int pageSize = 20,
  }) async {
    var r = await MessageHttpConfig.dio.get(
      "/liveRoom/getRoomByAnchor",
      data: {},
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    return LiveRoom.fromJson(r.data['room']);
  }

  static List<LiveRoom> _parseLiveRoomList(Response<dynamic> r) {
    List<LiveRoom> entityList = [];
    for (var json in r.data['roomList']) {
      var entity = LiveRoom.fromJson(json);
      entityList.add(entity);
    }
    return entityList;
  }
}

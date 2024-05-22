import 'package:dio/dio.dart';
import 'package:post_client/api/client/post_http_config.dart';
import 'package:post_client/model/live/live_room.dart';

class LiveRoomApi {
  static Future<(String, LiveRoom)> openRoom() async {
    var r = await PostHttpConfig.dio.post(
      "/liveRoom/openRoom",
      data: {},
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    return (r.data['token'].toString(), LiveRoom.fromJson(r.data['room']));
  }

  static Future<void> closeRoom() async {
    var r = await PostHttpConfig.dio.post(
      "/liveRoom/closeRoom",
      data: {},
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<String> getJoinRoomToken({required int roomId}) async {
    var r = await PostHttpConfig.dio.get(
      "/liveRoom/getJoinRoomToken",
      data: {"roomId": roomId},
      options: PostHttpConfig.options.copyWith(extra: {
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
    var r = await PostHttpConfig.dio.post(
      "/liveRoom/saveRoom",
      data: {"categoryId": categoryId, "name": name},
      options: PostHttpConfig.options.copyWith(extra: {
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
    var r = await PostHttpConfig.dio.get(
      "/liveRoom/getRoomListRandom",
      data: {
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: PostHttpConfig.options.copyWith(extra: {
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
    var r = await PostHttpConfig.dio.get(
      "/liveRoom/getRoomListByCategory",
      data: {
        "pageIndex": pageIndex,
        "categoryId": categoryId,
        "pageSize": pageSize,
      },
      options: PostHttpConfig.options.copyWith(extra: {
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
    var r = await PostHttpConfig.dio.get(
      "/liveRoom/getRoomByAnchor",
      data: {},
      options: PostHttpConfig.options.copyWith(extra: {
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

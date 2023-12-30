import 'package:dio/dio.dart';
import 'package:post_client/api/client/media_http_config.dart';

import '../../../model/media/album.dart';
import '../../../model/user/user.dart';

class AlbumApi {
  static Future<Album> createAlbum(
    String title,
    String introduction,
    int mediaType,
    String? coverUrl,
  ) async {
    var r = await MediaHttpConfig.dio.post(
      "/album/createAlbum",
      data: {
        "title": title,
        "introduction": introduction,
        "mediaType": mediaType,
        "coverUrl": coverUrl,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    //获取数据
    return Album.fromJson(r.data['album']);
  }

  static Future<void> deleteUserAlbumById(
    String albumId,
  ) async {
    await MediaHttpConfig.dio.post(
      "/album/deleteUserAlbumById",
      data: {
        "albumId": albumId,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<void> updateAlbumInfo({
    required String albumId,
    String? title,
    String? introduction,
    String? coverUrl,
  }) async {
    var r = await MediaHttpConfig.dio.post(
      "/album/updateAlbumInfo",
      data: {
        "albumId": albumId,
        "title": title,
        "introduction": introduction,
        "coverUrl": coverUrl,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<Album> getAlbumById(
    String albumId,
  ) async {
    var r = await MediaHttpConfig.dio.get(
      "/album/getAlbumById",
      queryParameters: {
        "albumId": albumId,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": false,
      }),
    );
    return Album.fromJson(r.data['album']);
  }

  static Future<List<Album>> getUserAlbumList(
    int userId,
    int mediaType,
    int pageIndex,
    int pageSize,
  ) async {
    var r = await MediaHttpConfig.dio.get(
      "/album/getUserAlbumList",
      queryParameters: {
        "targetUserId": userId,
        "mediaType": mediaType,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": true,
      }),
    );
    List<Album> albumList = [];
    for (var albumJson in r.data['albumList']) {
      var album = Album.fromJson(albumJson);
      albumList.add(album);
    }
    return albumList;
  }

  static Future<List<Album>> getAlbumListRandom(
    int pageSize,
  ) async {
    var r = await MediaHttpConfig.dio.get(
      "/album/getAlbumListRandom",
      queryParameters: {
        "pageSize": pageSize,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": false,
      }),
    );
    return _parseAlbumListWithUser(r);
  }

  static Future<List<Album>> getAlbumListByUserId(
    int userId,
    int pageIndex,
    int pageSize,
  ) async {
    var r = await MediaHttpConfig.dio.get(
      "/album/getAlbumListByUserId",
      queryParameters: {
        "targetUserId": userId,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": false,
      }),
    );

    return _parseAlbumList(r);
  }

  static Future<List<Album>> getUserFollowAlbumList({
    int pageIndex = 0,
    int pageSize = 20,
    required bool withUser,
  }) async {
    var r = await MediaHttpConfig.dio.get(
      "/followAlbum/getUserFollowAlbumList",
      queryParameters: {
        "pageIndex": pageIndex,
        "pageSize": pageSize,
        "withUser": withUser,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    return _parseAlbumListWithUser(r);
  }

  static Future<List<Album>> searchAlbum(
    String title,
    int page,
    int pageSize,
  ) async {
    var r = await MediaHttpConfig.dio.get(
      "/album/searchAlbum",
      queryParameters: {
        "title": title,
        "page": page,
        "pageSize": pageSize,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": false,
      }),
    );

    return _parseAlbumListWithUser(r);
  }

  static List<Album> _parseAlbumListWithUser(Response<dynamic> r) {
    Map<int, User> userMap = {};
    if (r.data['userList'] != null) {
      for (var userJson in r.data['userList']) {
        var user = User.fromJson(userJson);
        userMap[user.id ?? 0] = user;
      }
    }
    List<Album> albumList = [];
    if (r.data['albumList'] != null) {
      for (var albumJson in r.data['albumList']) {
        var album = Album.fromJson(albumJson);
        album.user = userMap[album.userId];
        albumList.add(album);
      }
    }
    return albumList;
  }

  static List<Album> _parseAlbumList(Response<dynamic> r) {
    List<Album> albumList = [];
    for (var albumJson in r.data['albumList']) {
      var album = Album.fromJson(albumJson);
      albumList.add(album);
    }
    return albumList;
  }
}

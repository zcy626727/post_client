import 'package:dio/dio.dart';
import 'package:post_client/model/post/follow_album.dart';

import '../../../model/user/user.dart';
import '../post_http_config.dart';

class FollowAlbumApi {
  static Future<FollowAlbum> followAlbum({
    required String albumId,
    int? mediaType,
  }) async {
    var r = await PostHttpConfig.dio.post(
      "/followAlbum/followAlbum",
      data: {
        "albumId": albumId,
        "mediaType": mediaType,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    return FollowAlbum.fromJson(r.data['followAlbum']);
  }

  static Future<void> unfollowAlbum({required String followAlbumId}) async {
    var r = await PostHttpConfig.dio.post(
      "/followAlbum/unfollowAlbum",
      data: {
        "followAlbumId": followAlbumId,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<FollowAlbum> getFollowAlbum({required String albumId}) async {
    var r = await PostHttpConfig.dio.get(
      "/followAlbum/getFollowAlbum",
      queryParameters: {
        "albumId": albumId,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    return FollowAlbum.fromJson(r.data['followAlbum']);
  }

  static Future<List<FollowAlbum>> getUserFollowAlbumList({
    int pageIndex = 0,
    int pageSize = 20,
    int? mediaType,
    required bool withUser,
  }) async {
    var r = await PostHttpConfig.dio.get(
      "/followAlbum/getUserFollowAlbumList",
      queryParameters: {
        "pageIndex": pageIndex,
        "pageSize": pageSize,
        "withUser": withUser,
        "mediaType": mediaType,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    return _parseFollowAlbumListWithUser(r);
  }

  static List<FollowAlbum> _parseFollowAlbumListWithUser(Response<dynamic> r) {
    Map<int, User> userMap = {};
    if (r.data['userList'] != null) {
      for (var userJson in r.data['userList']) {
        var user = User.fromJson(userJson);
        userMap[user.id ?? 0] = user;
      }
    }
    List<FollowAlbum> albumList = [];
    if (r.data['followAlbumList'] != null) {
      for (var followAlbumJson in r.data['followAlbumList']) {
        var followAlbum = FollowAlbum.fromJson(followAlbumJson);

        followAlbum.user = userMap[followAlbum.userId];
        //专辑没有被删除
        if (followAlbum.album != null) {
          followAlbum.album!.user = userMap[followAlbum.userId];
        }
        albumList.add(followAlbum);
      }
    }
    return albumList;
  }

  static List<FollowAlbum> _parseFollowAlbumList(Response<dynamic> r) {
    List<FollowAlbum> albumList = [];
    for (var albumJson in r.data['followAlbumList']) {
      var album = FollowAlbum.fromJson(albumJson);
      albumList.add(album);
    }
    return albumList;
  }
}

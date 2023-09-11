import 'package:dio/dio.dart';
import 'package:post_client/api/client/media_http_config.dart';
import 'package:post_client/domain/task/single_upload_task.dart';
import 'package:post_client/model/media/gallery.dart';
import 'package:post_client/model/media/media.dart';

import '../../../constant/media.dart';
import '../../../model/media/album.dart';
import '../../../model/media/article.dart';
import '../../../model/media/audio.dart';
import '../../../model/media/video.dart';
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

  static Future<void> addMediaToAlbum(
    String albumId,
    int mediaType,
    String mediaId,
  ) async {
    await MediaHttpConfig.dio.post(
      "/album/addMediaToAlbum",
      data: {
        "albumId": albumId,
        "mediaType": mediaType,
        "mediaId": mediaId,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<Album> getAlbumByIdWithMedia(
    String albumId,
  ) async {
    var r = await MediaHttpConfig.dio.get(
      "/album/getAlbumByIdWithMedia",
      queryParameters: {
        "albumId": albumId,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": true,
      }),
    );
    var album = Album.fromJson(r.data['album']);
    var mediaList = <Media>[];

    for (var mediaJson in r.data['mediaList']) {
      switch (album.mediaType) {
        case MediaType.gallery:
          mediaList.add(Gallery.fromJson(mediaJson));
        case MediaType.audio:
          mediaList.add(Audio.fromJson(mediaJson));
        case MediaType.article:
          mediaList.add(Article.fromJson(mediaJson));
        case MediaType.video:
          mediaList.add(Video.fromJson(mediaJson));
      }
    }
    album.mediaList = mediaList;

    return album;
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

  static Future<List<Album>> searchAlbum(
    String title,
    int page,
    int pageSize,
  ) async {
    var r = await MediaHttpConfig.dio.get(
      "/album/searchAlbum",
      data: {
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
    for (var userJson in r.data['userList']) {
      var user = User.fromJson(userJson);
      userMap[user.id ?? 0] = user;
    }
    List<Album> albumList = [];
    for (var albumJson in r.data['albumList']) {
      var album = Album.fromJson(albumJson);
      album.user = userMap[album.userId];
      albumList.add(album);
    }
    return albumList;
  }
}

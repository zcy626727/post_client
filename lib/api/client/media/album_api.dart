import 'package:post_client/api/client/media_http_config.dart';
import 'package:post_client/domain/task/upload_media_task.dart';
import 'package:post_client/model/article.dart';
import 'package:post_client/model/audio.dart';
import 'package:post_client/model/image.dart';
import 'package:post_client/model/media.dart';
import 'package:post_client/model/video.dart';

import '../../../model/album.dart';

class AlbumApi {
  static Future<Album> createAlbum(
    String title,
    String introduction,
    int? mediaType,
  ) async {
    var r = await MediaHttpConfig.dio.post(
      "/album/createAlbum",
      data: {
        "title": title,
        "introduction": introduction,
        "mediaType": mediaType,
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
      switch(album.mediaType){
        case MediaType.image:
          mediaList.add(Image.fromJson(mediaJson));
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
    List<Album> albumList = [];
    for (var albumJson in r.data['albumList']) {
      var album = Album.fromJson(albumJson);
      albumList.add(album);
    }
    return albumList;
  }
}

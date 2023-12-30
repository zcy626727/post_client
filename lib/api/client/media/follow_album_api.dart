import 'package:post_client/model/media/follow_album.dart';

import '../media_http_config.dart';

class FollowAlbumApi {
  static Future<FollowAlbum> followAlbum({required String albumId}) async {
    var r = await MediaHttpConfig.dio.post(
      "/followAlbum/followAlbum",
      data: {
        "albumId": albumId,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    return FollowAlbum.fromJson(r.data['followAlbum']);
  }

  static Future<void> unfollowAlbum({required String followAlbumId}) async {
    var r = await MediaHttpConfig.dio.post(
      "/followAlbum/unfollowAlbum",
      data: {
        "followAlbumId": followAlbumId,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<FollowAlbum> getFollowAlbum({required String albumId}) async {
    var r = await MediaHttpConfig.dio.get(
      "/followAlbum/getFollowAlbum",
      queryParameters: {
        "albumId": albumId,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    return FollowAlbum.fromJson(r.data['followAlbum']);
  }
}

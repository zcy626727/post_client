import 'package:dio/dio.dart';

import '../../../model/post/video.dart';
import '../../../model/user/user.dart';
import '../post_http_config.dart';

class VideoApi {
  static Future<Video> createVideo({
    required String title,
    required String introduction,
    required int fileId,
    String? coverUrl,
    required bool withPost,
    String? albumId,
  }) async {
    var r = await PostHttpConfig.dio.post(
      "/video/createVideo",
      data: {
        "title": title,
        "introduction": introduction,
        "fileId": fileId,
        "coverUrl": coverUrl,
        "withPost": withPost,
        "albumId": albumId,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    return Video.fromJson(r.data['video']);
  }

  static Future<void> updateVideoData({
    required String videoId,
    String? title,
    String? introduction,
    int? fileId,
    String? coverUrl,
    String? albumId,
  }) async {
    var r = await PostHttpConfig.dio.post(
      "/video/updateVideoData",
      data: {
        "videoId": videoId,
        "title": title,
        "introduction": introduction,
        "fileId": fileId,
        "coverUrl": coverUrl,
        "albumId": albumId,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<void> deleteUserVideoById(
    String videoId,
  ) async {
    await PostHttpConfig.dio.post(
      "/video/deleteUserVideoById",
      data: {
        "videoId": videoId,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<Video> getVideoById(
    String videoId,
  ) async {
    var r = await PostHttpConfig.dio.get(
      "/video/getVideoById",
      queryParameters: {
        "videoId": videoId,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": false,
      }),
    );
    return Video.fromJson(r.data['video']);
  }

  static Future<List<Video>> getVideoListByUserId(
    int userId,
    int pageIndex,
    int pageSize,
  ) async {
    var r = await PostHttpConfig.dio.get(
      "/video/getVideoListByUserId",
      queryParameters: {
        "targetUserId": userId,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": false,
      }),
    );

    return _parseVideoList(r);
  }

  static Future<(List<Video>, User?)> getVideoListByAlbumId({
    required int albumUserId,
    required String albumId,
    required int pageIndex,
    required int pageSize,
  }) async {
    var r = await PostHttpConfig.dio.get(
      "/video/getVideoListByAlbumId",
      queryParameters: {
        "albumUserId": albumUserId,
        "albumId": albumId,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": false,
      }),
    );

    User? user;
    if (r.data['user'] != null) {
      user = User.fromJson(r.data['user']);
    }

    var audioList = _parseVideoList(r);

    return (audioList, user);
  }

  static Future<List<Video>> getVideoListRandom(
    int pageSize,
  ) async {
    var r = await PostHttpConfig.dio.get(
      "/video/getVideoListRandom",
      queryParameters: {
        "pageSize": pageSize,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": false,
      }),
    );
    return _parseVideoListWithUser(r);
  }

  static Future<List<Video>> searchVideo(
    String title,
    int page,
    int pageSize,
  ) async {
    var r = await PostHttpConfig.dio.get(
      "/video/searchVideo",
      queryParameters: {
        "title": title,
        "page": page,
        "pageSize": pageSize,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": false,
      }),
    );

    return _parseVideoListWithUser(r);
  }

  static List<Video> _parseVideoListWithUser(Response<dynamic> r) {
    Map<int, User> userMap = {};
    if (r.data['userList'] != null) {
      for (var userJson in r.data['userList']) {
        var user = User.fromJson(userJson);
        userMap[user.id ?? 0] = user;
      }
    }
    List<Video> videoList = [];
    if (r.data['videoList'] != null) {
      for (var videoJson in r.data['videoList']) {
        var video = Video.fromJson(videoJson);
        video.user = userMap[video.userId];
        videoList.add(video);
      }
    }
    return videoList;
  }

  static List<Video> _parseVideoList(Response<dynamic> r) {
    List<Video> videoList = [];
    if (r.data['videoList'] != null) {
      for (var videoJson in r.data['videoList']) {
        var video = Video.fromJson(videoJson);
        videoList.add(video);
      }
    }
    return videoList;
  }
}

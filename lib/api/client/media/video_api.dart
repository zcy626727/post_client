import 'package:dio/dio.dart';
import 'package:post_client/model/video.dart';

import '../../../model/user.dart';
import '../media_http_config.dart';

class VideoApi {
  static Future<Video> createVideo(
    String title,
    String introduction,
    int fileId,
    String? coverUrl,
    bool withPost,
  ) async {
    var r = await MediaHttpConfig.dio.post(
      "/video/createVideo",
      data: {
        "title": title,
        "introduction": introduction,
        "fileId": fileId,
        "coverUrl": coverUrl,
        "withPost": withPost,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    return Video.fromJson(r.data['video']);
  }

  static Future<void> deleteUserVideoById(
    String videoId,
  ) async {
    await MediaHttpConfig.dio.post(
      "/video/deleteUserVideoById",
      data: {
        "videoId": videoId,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<Video> getVideoById(
    String videoId,
  ) async {
    var r = await MediaHttpConfig.dio.get(
      "/video/getVideoById",
      queryParameters: {
        "videoId": videoId,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
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
    var r = await MediaHttpConfig.dio.get(
      "/video/getVideoListByUserId",
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

    return _parseVideo(r);
  }

  static Future<List<Video>> getVideoListRandom(
    int pageSize,
  ) async {
    var r = await MediaHttpConfig.dio.get(
      "/video/getVideoListRandom",
      queryParameters: {
        "pageSize": pageSize,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": false,
      }),
    );
    return _parseVideoWithUser(r);
  }

  static List<Video> _parseVideoWithUser(Response<dynamic> r) {
    Map<int, User> userMap = {};
    for (var userJson in r.data['userList']) {
      var user = User.fromJson(userJson);
      userMap[user.id ?? 0] = user;
    }
    List<Video> videoList = [];
    for (var videoJson in r.data['videoList']) {
      var video = Video.fromJson(videoJson);
      video.user = userMap[video.userId];
      videoList.add(video);
    }
    return videoList;
  }

  static List<Video> _parseVideo(Response<dynamic> r) {
    List<Video> videoList = [];
    for (var videoJson in r.data['videoList']) {
      var video = Video.fromJson(videoJson);
      videoList.add(video);
    }
    return videoList;
  }
}

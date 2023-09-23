import 'package:dio/dio.dart';

import '../../../model/media/audio.dart';
import '../../../model/user/user.dart';
import '../media_http_config.dart';

class AudioApi {
  static Future<Audio> createAudio(
    String title,
    String introduction,
    int fileId,
    String? coverUrl,
    bool withPost,
  ) async {
    var r = await MediaHttpConfig.dio.post(
      "/audio/createAudio",
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

    return Audio.fromJson(r.data['audio']);
  }

  static Future<void> updateAudioData(
    String mediaId,
    String? title,
    String? introduction,
    int? fileId,
    String? coverUrl,
  ) async {
    if (title == null && introduction == null && fileId == null && coverUrl == null) {
      return;
    }
    var r = await MediaHttpConfig.dio.post(
      "/audio/updateAudioData",
      data: {
        "mediaId": mediaId,
        "title": title,
        "introduction": introduction,
        "fileId": fileId,
        "coverUrl": coverUrl,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<void> deleteUserAudioById(
    String audioId,
  ) async {
    await MediaHttpConfig.dio.post(
      "/audio/deleteUserAudioById",
      data: {
        "audioId": audioId,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<Audio> getAudioById(
    String audioId,
  ) async {
    var r = await MediaHttpConfig.dio.get(
      "/audio/getAudioById",
      queryParameters: {
        "audioId": audioId,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": false,
      }),
    );
    return Audio.fromJson(r.data['Audio']);
  }

  static Future<List<Audio>> getAudioListByUserId(
    int userId,
    int pageIndex,
    int pageSize,
  ) async {
    var r = await MediaHttpConfig.dio.get(
      "/audio/getAudioListByUserId",
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

    return _parseAudio(r);
  }

  static Future<List<Audio>> getAudioListRandom(
    int pageSize,
  ) async {
    var r = await MediaHttpConfig.dio.get(
      "/audio/getAudioListRandom",
      queryParameters: {
        "pageSize": pageSize,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": false,
      }),
    );
    return _parseAudioListWithUser(r);
  }

  static Future<List<Audio>> searchAudio(
    String title,
    int page,
    int pageSize,
  ) async {
    var r = await MediaHttpConfig.dio.get(
      "/audio/searchAudio",
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

    return _parseAudioListWithUser(r);
  }

  static List<Audio> _parseAudioListWithUser(Response<dynamic> r) {
    Map<int, User> userMap = {};
    if (r.data['userList'] != null) {
      for (var userJson in r.data['userList']) {
        var user = User.fromJson(userJson);
        userMap[user.id ?? 0] = user;
      }
    }

    List<Audio> audioList = [];
    if (r.data['audioList'] != null) {
      for (var audioJson in r.data['audioList']) {
        var audio = Audio.fromJson(audioJson);
        audio.user = userMap[audio.userId];
        audioList.add(audio);
      }
    }

    return audioList;
  }

  static List<Audio> _parseAudio(Response<dynamic> r) {
    List<Audio> audioList = [];
    if (r.data['audioList'] != null) {
      for (var audioJson in r.data['audioList']) {
        var audio = Audio.fromJson(audioJson);
        audioList.add(audio);
      }
    }

    return audioList;
  }
}

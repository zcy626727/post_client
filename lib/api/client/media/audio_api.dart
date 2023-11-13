import 'package:dio/dio.dart';

import '../../../model/media/audio.dart';
import '../../../model/user/user.dart';
import '../media_http_config.dart';

class AudioApi {
  static Future<Audio> createAudio({
    required String title,
    required String introduction,
    required int fileId,
    String? coverUrl,
    required bool withPost,
    String? albumId,
  }) async {
    var r = await MediaHttpConfig.dio.post(
      "/audio/createAudio",
      data: {
        "title": title,
        "introduction": introduction,
        "fileId": fileId,
        "coverUrl": coverUrl,
        "withPost": withPost,
        "albumId": albumId,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    return Audio.fromJson(r.data['audio']);
  }

  static Future<void> updateAudioData({
    required String mediaId,
    String? title,
    String? introduction,
    int? fileId,
    String? coverUrl,
    String? albumId,
  }) async {
    var r = await MediaHttpConfig.dio.post(
      "/audio/updateAudioData",
      data: {
        "mediaId": mediaId,
        "title": title,
        "introduction": introduction,
        "fileId": fileId,
        "coverUrl": coverUrl,
        "albumId": albumId,
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

    return _parseAudioList(r);
  }

  static Future<(List<Audio>, User?)> getAudioListByAlbumId({
    required int albumUserId,
    required String albumId,
    required int pageIndex,
    required int pageSize,
  }) async {
    var r = await MediaHttpConfig.dio.get(
      "/audio/getAudioListByAlbumId",
      queryParameters: {
        "albumUserId": albumUserId,
        "albumId": albumId,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": false,
      }),
    );

    User? user;
    if (r.data['user'] != null) {
      user = User.fromJson(r.data['user']);
    }

    var audioList = _parseAudioList(r);

    return (audioList, user);
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

  static List<Audio> _parseAudioList(Response<dynamic> r) {
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

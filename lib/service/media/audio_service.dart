import '../../api/client/media/audio_api.dart';
import '../../model/media/audio.dart';
import '../../model/user/user.dart';

class AudioService {
  static Future<Audio> createAudio(
    String title,
    String introduction,
    int fileId,
    String? coverUrl,
    bool withPost,
  ) async {
    var audio = await AudioApi.createAudio(title, introduction, fileId, coverUrl, withPost);
    return audio;
  }

  static Future<void> updateAudioData({
    required String mediaId,
    String? title,
    String? introduction,
    int? fileId,
    String? coverUrl,
    String? albumId,
  }) async {
    await AudioApi.updateAudioData(
      mediaId:mediaId,
      title:title,
      introduction:introduction,
      fileId:fileId,
      coverUrl:coverUrl,
      albumId: albumId,
    );
  }

  static Future<void> deleteAudio(
    String? audioId,
  ) async {
    if (audioId == null) return;
    await AudioApi.deleteUserAudioById(audioId);
  }

  static Future<Audio> getAudioById(
    String audioId,
  ) async {
    var audio = await AudioApi.getAudioById(audioId);
    return audio;
  }

  static Future<List<Audio>> getAudioListByUserId(
    User user,
    int pageIndex,
    int pageSize,
  ) async {
    var audioList = await AudioApi.getAudioListByUserId(user.id!, pageIndex, pageSize);
    for (var audio in audioList) {
      audio.user = user;
    }
    return audioList;
  }

  static Future<List<Audio>> getAudioListByAlbumId({
    required int albumUserId,
    required String albumId,
    int pageIndex = 0,
    required int pageSize,
  }) async {
    var (audioList, user) = await AudioApi.getAudioListByAlbumId(
      albumUserId: albumUserId,
      albumId: albumId,
      pageIndex: pageIndex,
      pageSize: pageSize,
    );
    for (var audio in audioList) {
      audio.user = user;
    }
    return audioList;
  }

  static Future<List<Audio>> getAudioListRandom(
    int pageSize,
  ) async {
    var audioList = await AudioApi.getAudioListRandom(pageSize);
    return audioList;
  }

  static Future<List<Audio>> searchAudio(
    String title,
    int page,
    int pageSize,
  ) async {
    var audioList = await AudioApi.searchAudio(title, page, pageSize);
    return audioList;
  }
}

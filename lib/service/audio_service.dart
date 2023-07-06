import '../api/client/media/audio_api.dart';
import '../model/audio.dart';
import '../model/user.dart';

class AudioService {
  static Future<Audio> createAudio(
    String title,
    String introduction,
    int fileId,
    String? coverUrl,
  ) async {
    var audio = await AudioApi.createAudio(title, introduction, fileId, coverUrl);
    return audio;
  }

  static Future<void> deleteAudio(
    String audioId,
  ) async {
    await AudioApi.deleteUserAudioById(audioId);
  }

  static Future<Audio> getAudioById(
    String AudioId,
  ) async {
    var Audio = await AudioApi.getAudioById(AudioId);
    return Audio;
  }

  static Future<List<Audio>> getAudioListByUserId(
    int userId,
    int pageIndex,
    int pageSize,
    User user,
  ) async {
    var AudioList = await AudioApi.getAudioListByUserId(userId, pageIndex, pageSize);
    for (var Audio in AudioList) {
      Audio.user = user;
    }
    return AudioList;
  }

  static Future<List<Audio>> getAudioListRandom(
    int pageSize,
  ) async {
    var AudioList = await AudioApi.getAudioListRandom(pageSize);
    return AudioList;
  }
}

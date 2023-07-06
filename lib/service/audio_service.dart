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

  static Future<List<Audio>> getAudioListRandom(
    int pageSize,
  ) async {
    var audioList = await AudioApi.getAudioListRandom(pageSize);
    return audioList;
  }
}

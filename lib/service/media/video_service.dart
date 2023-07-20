import '../../api/client/media/video_api.dart';
import '../../model/media/video.dart';
import '../../model/user/user.dart';

class VideoService {
  static Future<Video> createVideo(
    String title,
    String introduction,
    int fileId,
    String? coverUrl,
    bool withPost,
  ) async {
    var video = await VideoApi.createVideo(title, introduction, fileId, coverUrl, withPost);
    return video;
  }

  static Future<void> deleteVideo(
    String videoId,
  ) async {
    await VideoApi.deleteUserVideoById(videoId);
  }

  static Future<Video> getVideoById(
    String videoId,
  ) async {
    var video = await VideoApi.getVideoById(videoId);
    return video;
  }

  static Future<List<Video>> getVideoListByUserId(
    User user,
    int pageIndex,
    int pageSize,
  ) async {
    var videoList = await VideoApi.getVideoListByUserId(user.id!, pageIndex, pageSize);
    for (var video in videoList) {
      video.user = user;
    }
    return videoList;
  }

  static Future<List<Video>> getVideoListRandom(
    int pageSize,
  ) async {
    var videoList = await VideoApi.getVideoListRandom(pageSize);
    return videoList;
  }
}

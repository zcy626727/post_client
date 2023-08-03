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

  static Future<void> updateVideoData(
    String mediaId,
    String? title,
    String? introduction,
    int? fileId,
    String? coverUrl,
  ) async {
    await VideoApi.updateVideoData(mediaId, title, introduction, fileId, coverUrl);
  }

  static Future<void> deleteVideo(
    String? videoId,
  ) async {
    if (videoId == null) return;
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

  static Future<List<Video>> searchVideo(
    String title,
    int page,
    int pageSize,
  ) async {
    var videoList = await VideoApi.searchVideo(title, page, pageSize);
    return videoList;
  }
}

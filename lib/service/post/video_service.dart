import '../../api/client/post/video_api.dart';
import '../../model/post/video.dart';
import '../../model/user/user.dart';

class VideoService {
  static Future<Video> createVideo({
    required String title,
    required String introduction,
    required int fileId,
    String? coverUrl,
    required bool withPost,
    String? albumId,
  }) async {
    var video = await VideoApi.createVideo(
      title: title,
      introduction: introduction,
      fileId: fileId,
      coverUrl: coverUrl,
      withPost: withPost,
      albumId: albumId,
    );
    return video;
  }

  static Future<void> updateVideoData({
    required String mediaId,
    String? title,
    String? introduction,
    int? fileId,
    String? coverUrl,
    String? albumId,
  }) async {
    await VideoApi.updateVideoData(videoId: mediaId, title: title, introduction: introduction, fileId: fileId, coverUrl: coverUrl, albumId: albumId);
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

  static Future<List<Video>> getVideoListByAlbumId({
    required int albumUserId,
    required String albumId,
    int pageIndex = 0,
    required int pageSize,
  }) async {
    var (videoList, user) = await VideoApi.getVideoListByAlbumId(
      albumUserId: albumUserId,
      albumId: albumId,
      pageIndex: pageIndex,
      pageSize: pageSize,
    );
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

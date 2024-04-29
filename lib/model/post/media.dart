import 'package:post_client/model/post/article.dart';
import 'package:post_client/model/post/audio.dart';
import 'package:post_client/model/post/gallery.dart';
import 'package:post_client/model/post/source.dart';
import 'package:post_client/model/post/video.dart';

class Media extends Source {
  int? userId;
  String? title;
  String? coverUrl;
  DateTime? createTime;
  String? introduction;
  String? albumId;

  int? dislikeNum;
  int? shareNum;

  void copy(Media newMedia) {
    id = newMedia.id;
    userId = newMedia.userId;
    title = newMedia.title;
    albumId = newMedia.albumId;
    coverUrl = newMedia.coverUrl;
    createTime = newMedia.createTime;
    introduction = newMedia.introduction;
    likeNum = newMedia.likeNum;
    dislikeNum = newMedia.dislikeNum;
    favoritesNum = newMedia.favoritesNum;
    shareNum = newMedia.shareNum;
  }

  bool hasAlbum() {
    return albumId != null && albumId != "000000000000000000000000";
  }
}

class MediaUtils {
  static bool updateMediaInList(List<Media>? mediaList, Media newMedia) {
    if (mediaList == null) return false;
    for (var media in mediaList) {
      //找到对应的媒体项
      if (media.id == newMedia.id) {
        if (newMedia is Video && media is Video) {
          media.copyVideo(newMedia);
        } else if (newMedia is Audio && media is Audio) {
          media.copyAudio(newMedia);
        } else if (newMedia is Article && media is Article) {
          media.copyArticle(newMedia);
        } else if (newMedia is Gallery && media is Gallery) {
          media.copyGallery(newMedia);
        }
        return true;
      }
    }
    return false;
  }

  static bool deleteMediaInList(List<Media>? mediaList, Media newMedia) {
    if (mediaList == null) return false;
    for (var media in mediaList) {
      //找到对应的媒体项
      if (media.id == newMedia.id) {
        mediaList.remove(media);
        return true;
      }
    }
    return false;
  }
}

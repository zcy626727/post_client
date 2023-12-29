import 'dart:math';

import 'package:post_client/api/client/media/media_api.dart';

import '../../model/media/article.dart';
import '../../model/media/audio.dart';
import '../../model/media/gallery.dart';
import '../../model/media/video.dart';

class MediaService {
  static Future<(List<Article>, List<Audio>, List<Gallery>, List<Video>)> getMediaListByIdList({
    List<String>? articleIdList,
    List<String>? audioIdList,
    List<String>? galleryIdList,
    List<String>? videoIdList,
    int pageIndex = 0,
    int pageSize = 20,
  }) async {
    int startIndex = pageIndex * pageSize;
    int endIndex = startIndex + pageSize;

    //超过范围
    if (articleIdList != null) {
      endIndex = min(endIndex, articleIdList.length);
    }
    if (audioIdList != null) {
      endIndex = min(endIndex, audioIdList.length);
    }
    if (galleryIdList != null) {
      endIndex = min(endIndex, galleryIdList.length);
    }
    if (videoIdList != null) {
      endIndex = min(endIndex, videoIdList.length);
    }
    if (startIndex > endIndex) return (<Article>[], <Audio>[], <Gallery>[], <Video>[]);
    articleIdList = articleIdList?.sublist(startIndex, endIndex);
    audioIdList = audioIdList?.sublist(pageIndex * pageSize, endIndex);
    galleryIdList = galleryIdList?.sublist(pageIndex * pageSize, endIndex);
    videoIdList = videoIdList?.sublist(pageIndex * pageSize, endIndex);

    return await MediaApi.getMediaListByIdList(
      articleIdList: articleIdList,
      audioIdList: audioIdList,
      galleryIdList: galleryIdList,
      videoIdList: videoIdList,
    );
  }
}

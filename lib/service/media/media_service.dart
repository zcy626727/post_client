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
  }) async {
    return await MediaApi.getMediaListByIdList(
      articleIdList: articleIdList,
      audioIdList: audioIdList,
      galleryIdList: galleryIdList,
      videoIdList: videoIdList,
    );
  }
}

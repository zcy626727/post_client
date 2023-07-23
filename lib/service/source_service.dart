import 'package:post_client/api/client/message/comment_api.dart';
import 'package:post_client/api/client/message/post_api.dart';
import 'package:post_client/model/message/comment.dart';
import 'package:post_client/model/media/gallery.dart';
import 'package:post_client/model/media/history.dart';

import '../api/client/media/media_api.dart';
import '../constant/post.dart';
import '../constant/source.dart';
import '../model/media/article.dart';
import '../model/media/audio.dart';
import '../model/media/video.dart';
import '../model/message/post.dart';

class SourceService{
  static Future<void> fillSource(List<History> historyList) async {
    List<String> articleIdList = <String>[];
    List<String> audioIdList = <String>[];
    List<String> galleryIdList = <String>[];
    List<String> videoIdList = <String>[];
    List<String> postIdList = <String>[];
    List<String> commentIdList = <String>[];

    for (var history in historyList) {
      if (history.sourceId != null) {
        switch (history.sourceType) {
          case SourceType.article:
            articleIdList.add(history.sourceId!);
          case SourceType.video:
            videoIdList.add(history.sourceId!);
          case SourceType.audio:
            audioIdList.add(history.sourceId!);
          case SourceType.gallery:
            galleryIdList.add(history.sourceId!);
          case SourceType.post:
            postIdList.add(history.sourceId!);
          case SourceType.comment:
            commentIdList.add(history.sourceId!);
        }
      }
    }

    Map<String, Article> articleMap = {};
    Map<String, Audio> audioMap = {};
    Map<String, Gallery> galleryMap = {};
    Map<String, Video> videoMap = {};

    if (articleIdList.isNotEmpty || audioIdList.isNotEmpty || galleryIdList.isNotEmpty || videoIdList.isNotEmpty) {
      (articleMap, audioMap, galleryMap, videoMap) = await MediaApi.getMediaMapByIdList(
        articleIdList: articleIdList,
        audioIdList: audioIdList,
        galleryIdList: galleryIdList,
        videoIdList: videoIdList,
      );
    }

    Map<String, Post> postMap = {};
    if (postIdList.isNotEmpty) {
      postMap = await PostApi.getPostMapByIdList(commentIdList);
    }
    Map<String, Comment> commentMap = {};
    if (commentIdList.isNotEmpty) {
      commentMap = await CommentApi.getCommentMapByIdList(commentIdList);
    }

    //填充
    for (var history in historyList) {
      if (history.sourceId != null) {
        switch (history.sourceType) {
          case SourceType.article:
            history.source = articleMap[history.sourceId];
          case SourceType.video:
            history.source = videoMap[history.sourceId];
          case SourceType.audio:
            history.source = audioMap[history.sourceId];
          case SourceType.gallery:
            history.source = galleryMap[history.sourceId];
          case SourceType.comment:
            history.source = commentMap[history.sourceId];
          case SourceType.post:
            history.source = postMap[history.sourceId];
        }
      }
    }
  }


}
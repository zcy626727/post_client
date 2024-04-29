import 'dart:math';

import 'package:post_client/api/client/post/source_api.dart';
import 'package:post_client/model/post/comment.dart';

import '../../model/post/article.dart';
import '../../model/post/audio.dart';
import '../../model/post/gallery.dart';
import '../../model/post/post.dart';
import '../../model/post/video.dart';
import 'comment_service.dart';
import 'post_service.dart';

class SourceService {
  static Future<(List<Post>, List<Comment>, List<Article>, List<Audio>, List<Gallery>, List<Video>)> getSourceListByIdList({
    List<String>? postIdList,
    List<String>? commentIdList,
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
    if (postIdList != null) {
      endIndex = min(endIndex, postIdList.length);
    }
    if (commentIdList != null) {
      endIndex = min(endIndex, commentIdList.length);
    }
    if (startIndex > endIndex) return (<Post>[], <Comment>[], <Article>[], <Audio>[], <Gallery>[], <Video>[]);
    articleIdList = articleIdList?.sublist(startIndex, endIndex);
    audioIdList = audioIdList?.sublist(pageIndex * pageSize, endIndex);
    galleryIdList = galleryIdList?.sublist(pageIndex * pageSize, endIndex);
    videoIdList = videoIdList?.sublist(pageIndex * pageSize, endIndex);
    postIdList = postIdList?.sublist(startIndex, endIndex);
    commentIdList = commentIdList?.sublist(pageIndex * pageSize, endIndex);
    if ((postIdList == null || postIdList.isEmpty) &&
        (commentIdList == null || commentIdList.isEmpty) &&
        (videoIdList == null || videoIdList.isEmpty) &&
        (galleryIdList == null || galleryIdList.isEmpty) &&
        (audioIdList == null || audioIdList.isEmpty) &&
        (articleIdList == null || articleIdList.isEmpty)) return (<Post>[], <Comment>[], <Article>[], <Audio>[], <Gallery>[], <Video>[]);
    var (postList, commentList, articleList, audioList, galleryList, videoList) = await SourceApi.getSourceListByIdList(
      postIdList: postIdList,
      commentIdList: commentIdList,
      articleIdList: articleIdList,
      audioIdList: audioIdList,
      galleryIdList: galleryIdList,
      videoIdList: videoIdList,
    );

    // post和comment需要另外填充一些信息
    if (postList.isNotEmpty) {
      await PostService.fillMedia(postList);
      await PostService.fillFeedback(postList);
    }

    if (commentList.isNotEmpty) {
      await CommentService.fillFeedback(commentList);
    }

    return (postList, commentList, articleList, audioList, galleryList, videoList);
  }
}

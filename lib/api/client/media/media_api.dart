import 'package:dio/dio.dart';
import 'package:post_client/model/media/gallery.dart';
import 'package:post_client/model/user/user.dart';

import '../../../model/media/article.dart';
import '../../../model/media/audio.dart';
import '../../../model/media/video.dart';
import '../media_http_config.dart';

class MediaApi {
  static Future<(Map<String, Article>, Map<String, Audio>, Map<String, Gallery>, Map<String, Video>)> getMediaMapByIdList({
    required List<String> articleIdList,
    required List<String> audioIdList,
    required List<String> galleryIdList,
    required List<String> videoIdList,
  }) async {
    var r = await MediaHttpConfig.dio.get(
      "/media/getMediaListByIdList",
      queryParameters: {
        "articleIdList": articleIdList,
        "audioIdList": audioIdList,
        "galleryIdList": galleryIdList,
        "videoIdList": videoIdList,
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": false,
      }),
    );

    return _parseMediaMap(r);
  }

  static Future<(List<Article>, List<Audio>, List<Gallery>, List<Video>)> getMediaListByIdList({
    List<String>? articleIdList,
    List<String>? audioIdList,
    List<String>? galleryIdList,
    List<String>? videoIdList,
  }) async {
    var r = await MediaHttpConfig.dio.get(
      "/media/getMediaListByIdList",
      queryParameters: {
        "articleIdList": articleIdList??[],
        "audioIdList": audioIdList??[],
        "galleryIdList": galleryIdList??[],
        "videoIdList": videoIdList??[],
      },
      options: MediaHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": false,
      }),
    );

    return _parseMediaList(r);
  }

  static (Map<String, Article>, Map<String, Audio>, Map<String, Gallery>, Map<String, Video>) _parseMediaMap(Response<dynamic> r) {
    Map<int, User> userMap = {};
    if (r.data['userList'] != null) {
      for (var userJson in r.data['userList']) {
        var user = User.fromJson(userJson);
        userMap[user.id!] = user;
      }
    }

    Map<String, Article> articleMap = {};
    if (r.data['articleList'] != null) {
      for (var articleJson in r.data['articleList']) {
        var article = Article.fromJson(articleJson);
        article.user = userMap[article.userId];
        articleMap[article.id!] = article;
      }
    }

    Map<String, Audio> audioMap = {};
    if (r.data['audioList'] != null) {
      for (var audioJson in r.data['audioList']) {
        var audio = Audio.fromJson(audioJson);
        audio.user = userMap[audio.userId];
        audioMap[audio.id!] = audio;
      }
    }

    Map<String, Gallery> galleryMap = {};
    if (r.data['galleryList'] != null) {
      for (var galleryJson in r.data['galleryList']) {
        var gallery = Gallery.fromJson(galleryJson);
        gallery.user = userMap[gallery.userId];
        galleryMap[gallery.id!] = gallery;
      }
    }

    Map<String, Video> videoMap = {};
    if (r.data['videoList'] != null) {
      for (var videoJson in r.data['videoList']) {
        var video = Video.fromJson(videoJson);
        video.user = userMap[video.userId];
        videoMap[video.id!] = video;
      }
    }
    return (articleMap, audioMap, galleryMap, videoMap);
  }

  static (List<Article>, List<Audio>, List<Gallery>, List<Video>) _parseMediaList(Response<dynamic> r) {
    Map<int, User> userMap = {};
    if (r.data['userList'] != null) {
      for (var userJson in r.data['userList']) {
        var user = User.fromJson(userJson);
        userMap[user.id!] = user;
      }
    }

    List<Article> articleList = [];
    if (r.data['articleList'] != null) {
      for (var articleJson in r.data['articleList']) {
        var article = Article.fromJson(articleJson);
        article.user = userMap[article.userId];
        articleList.add(article);
      }
    }

    List<Audio> audioList = [];
    if (r.data['audioList'] != null) {
      for (var audioJson in r.data['audioList']) {
        var audio = Audio.fromJson(audioJson);
        audio.user = userMap[audio.userId];
        audioList.add(audio);
      }
    }

    List<Gallery> galleryList = [];
    if (r.data['galleryList'] != null) {
      for (var galleryJson in r.data['galleryList']) {
        var gallery = Gallery.fromJson(galleryJson);
        gallery.user = userMap[gallery.userId];
        galleryList.add(gallery);
      }
    }

    List<Video> videoList = [];
    if (r.data['videoList'] != null) {
      for (var videoJson in r.data['videoList']) {
        var video = Video.fromJson(videoJson);
        video.user = userMap[video.userId];
        videoList.add(video);
      }
    }
    return (articleList, audioList, galleryList, videoList);
  }
}

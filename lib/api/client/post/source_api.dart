import 'package:dio/dio.dart';
import 'package:post_client/model/post/comment.dart';
import 'package:post_client/model/post/gallery.dart';
import 'package:post_client/model/user/user.dart';

import '../../../model/post/article.dart';
import '../../../model/post/audio.dart';
import '../../../model/post/post.dart';
import '../../../model/post/video.dart';
import '../post_http_config.dart';

class SourceApi {
  static Future<(Map<String, Post>, Map<String, Comment>, Map<String, Article>, Map<String, Audio>, Map<String, Gallery>, Map<String, Video>)> getSourceMapByIdList({
    required List<String> articleIdList,
    required List<String> audioIdList,
    required List<String> galleryIdList,
    required List<String> videoIdList,
  }) async {
    var r = await PostHttpConfig.dio.get(
      "/source/getSourceListByIdList",
      queryParameters: {
        "articleIdList": articleIdList,
        "audioIdList": audioIdList,
        "galleryIdList": galleryIdList,
        "videoIdList": videoIdList,
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": false,
      }),
    );

    return _parseSourceMap(r);
  }

  static Future<(List<Post>, List<Comment>, List<Article>, List<Audio>, List<Gallery>, List<Video>)> getSourceListByIdList({
    List<String>? postIdList,
    List<String>? commentIdList,
    List<String>? articleIdList,
    List<String>? audioIdList,
    List<String>? galleryIdList,
    List<String>? videoIdList,
  }) async {
    var r = await PostHttpConfig.dio.get(
      "/source/getSourceListByIdList",
      queryParameters: {
        "articleIdList": articleIdList ?? [],
        "audioIdList": audioIdList ?? [],
        "galleryIdList": galleryIdList ?? [],
        "videoIdList": videoIdList ?? [],
        "postIdList": postIdList ?? [],
        "commentIdList": commentIdList ?? [],
      },
      options: PostHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": false,
      }),
    );

    return _parseSourceList(r);
  }

  static (Map<String, Post>, Map<String, Comment>, Map<String, Article>, Map<String, Audio>, Map<String, Gallery>, Map<String, Video>) _parseSourceMap(Response<dynamic> r) {
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

    Map<String, Post> postMap = {};
    if (r.data['postList'] != null) {
      for (var postJson in r.data['postList']) {
        var post = Post.fromJson(postJson);
        post.user = userMap[post.userId];
        postMap[post.id!] = post;
      }
    }

    Map<String, Comment> commentMap = {};
    if (r.data['commentList'] != null) {
      for (var audioJson in r.data['commentList']) {
        var comment = Comment.fromJson(audioJson);
        comment.user = userMap[comment.userId];
        commentMap[comment.id!] = comment;
      }
    }
    return (postMap, commentMap, articleMap, audioMap, galleryMap, videoMap);
  }

  static (List<Post>, List<Comment>, List<Article>, List<Audio>, List<Gallery>, List<Video>) _parseSourceList(Response<dynamic> r) {
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

    List<Post> postList = [];
    if (r.data['postList'] != null) {
      for (var postJson in r.data['postList']) {
        var post = Post.fromJson(postJson);
        post.user = userMap[post.userId];
        postList.add(post);
      }
    }

    List<Comment> commentList = [];
    if (r.data['commentList'] != null) {
      for (var audioJson in r.data['commentList']) {
        var comment = Comment.fromJson(audioJson);
        comment.user = userMap[comment.userId];
        commentList.add(comment);
      }
    }

    return (postList, commentList, articleList, audioList, galleryList, videoList);
  }
}

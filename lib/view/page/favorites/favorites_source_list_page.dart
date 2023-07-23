import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:post_client/constant/source.dart';
import 'package:post_client/model/favorites.dart';
import 'package:post_client/model/media/article.dart';
import 'package:post_client/model/media/audio.dart';
import 'package:post_client/model/media/gallery.dart';
import 'package:post_client/model/media/video.dart';
import 'package:post_client/model/message/feed_feedback.dart';
import 'package:post_client/service/media/media_service.dart';
import 'package:post_client/service/message/feed_service.dart';
import 'package:post_client/view/component/comment/comment_list_tile.dart';
import 'package:post_client/view/component/media/article_list_tile.dart';
import 'package:post_client/view/component/media/audio_list_tile.dart';

import '../../../domain/favorites_source.dart';
import '../../../model/message/comment.dart';
import '../../../model/message/post.dart';
import '../../component/media/gallery_list_tile.dart';
import '../../component/media/video_list_tile.dart';
import '../../component/post/post_list_tile.dart';
import '../../widget/common_item_list.dart';
import '../comment/reply_page.dart';

class FavoritesSourceListPage extends StatefulWidget {
  const FavoritesSourceListPage({super.key, required this.favorites});

  final Favorites favorites;

  @override
  State<FavoritesSourceListPage> createState() => _FavoritesSourceListPageState();
}

class _FavoritesSourceListPageState extends State<FavoritesSourceListPage> {
  late Future _futureBuilderFuture;
  List<Post> postList = [];
  List<Comment> commentList = [];
  List<Audio> audioList = [];
  List<Video> videoList = [];
  List<Gallery> galleryList = [];
  List<Article> articleList = [];

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
  }

  Future getData() async {
    return Future.wait([getDataList()]);
  }

  Future<void> getDataList() async {
    try {
      switch (widget.favorites.sourceType) {
        case SourceType.post:
          var result = await FeedService.getFeedListByIdList(postIdList: widget.favorites.sourceIdList);
          postList = result.$1;
        case SourceType.comment:
          var result = await FeedService.getFeedListByIdList(commentIdList: widget.favorites.sourceIdList);
          commentList = result.$2;
        case SourceType.gallery:
          var result = await MediaService.getMediaListByIdList(galleryIdList: widget.favorites.sourceIdList);
          galleryList = result.$3;
        case SourceType.audio:
          var result = await MediaService.getMediaListByIdList(audioIdList: widget.favorites.sourceIdList);
          audioList = result.$2;
        case SourceType.video:
          var result = await MediaService.getMediaListByIdList(videoIdList: widget.favorites.sourceIdList!);
          videoList = result.$4;
        case SourceType.article:
          var result = await MediaService.getMediaListByIdList(articleIdList: widget.favorites.sourceIdList!);
          articleList = result.$1;
      }
    } on DioException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          return Scaffold(
            backgroundColor: colorScheme.background,
            appBar: AppBar(
              toolbarHeight: 50,
              centerTitle: true,
              elevation: 0,
              backgroundColor: colorScheme.surface,
              leading: IconButton(
                splashRadius: 20,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: colorScheme.onBackground,
                ),
              ),
              title: Text(
                '收藏夹：${widget.favorites.title ?? "未知名称"}',
                style: TextStyle(color: colorScheme.onSurface),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              actions: const [],
            ),
            body: Container(
              color: colorScheme.background,
              child: buildSourceList(),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          );
        }
      },
    );
  }

  Widget buildSourceList() {
    switch (widget.favorites.sourceType) {
      case SourceType.gallery:
        return GridView.builder(
          controller: ScrollController(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            //长宽比例
            childAspectRatio: 1,
            //主轴距离
            mainAxisSpacing: 5.0,
            //辅轴距离
            crossAxisSpacing: 5.0,
          ),
          itemBuilder: (ctx, index) {
            var source = galleryList[index];
            return GalleryListTile(key: ValueKey(source.id), gallery: source);
          },
          itemCount: galleryList.length,
        );
      case SourceType.audio:
        return ListView.builder(
          itemBuilder: (ctx, index) {
            var source = audioList[index];
            return AudioListTile(key: ValueKey(source.id), audio: source);
          },
          itemCount: audioList.length,
        );
      case SourceType.video:
        return ListView.builder(
          itemBuilder: (ctx, index) {
            var source = videoList[index];
            return VideoListTile(
              key: ValueKey(source.id),
              video: source,
              onDelete: (Video video) {
                videoList.remove(video);
                setState(() {});
              },
            );
          },
          itemCount: videoList.length,
        );
      case SourceType.article:
        return ListView.builder(
            itemBuilder: (ctx, index) {
              var source = articleList[index];
              return ArticleListTile(key: ValueKey(source.id), article: source);
            },
            itemCount: articleList.length);
      case SourceType.post:
        return ListView.builder(
            itemBuilder: (ctx, index) {
              var source = postList[index];
              return PostListTile(
                key: ValueKey(source.id),
                post: source,
                onDeletePost: (Post post) {
                  postList.remove(post);
                  setState(() {});
                },
                feedback: source.feedback ?? FeedFeedback(),
              );
            },
            itemCount: postList.length);
      default:
        return ListView.builder(
          itemBuilder: (ctx, index) {
            var source = commentList[index];
            return CommentListTile(
              key: ValueKey(source.id),
              comment: source,
              onDeleteComment: (Comment comment) {
                commentList.remove(comment);
                setState(() {});
              },
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReplyPage(
                      comment: source,
                      onDeleteComment: (comment) {
                        commentList.remove(comment);
                        setState(() {});
                      },
                    ),
                  ),
                );
              },
            );
          },
          itemCount: commentList.length,
        );
    }
  }
}

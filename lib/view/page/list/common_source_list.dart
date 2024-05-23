import 'package:flutter/material.dart';
import 'package:post_client/constant/source.dart';
import 'package:post_client/model/post/feedback.dart' as post_feedback;
import 'package:post_client/view/component/comment/comment_list_tile.dart';
import 'package:post_client/view/component/post/post_list_tile.dart';

import '../../../model/post/album.dart';
import '../../../model/post/article.dart';
import '../../../model/post/audio.dart';
import '../../../model/post/comment.dart';
import '../../../model/post/gallery.dart';
import '../../../model/post/media.dart';
import '../../../model/post/post.dart';
import '../../../model/post/video.dart';
import '../../../model/user/user.dart';
import '../../component/media/list/album_list_tile.dart';
import '../../component/media/list/article_list_tile.dart';
import '../../component/media/list/audio_list_tile.dart';
import '../../component/media/list/gallery_list_tile.dart';
import '../../component/media/list/video_list_tile.dart';
import '../../widget/common_item_list.dart';
import '../comment/reply_page.dart';

class CommonSourceList extends StatefulWidget {
  const CommonSourceList({
    super.key,
    this.onLoadPost,
    this.onLoadGallery,
    this.onLoadVideo,
    this.onLoadAudio,
    this.onLoadArticle,
    this.onLoadAlbum,
    this.onLoadUser,
    this.sourceType,
    this.mediaType,
    this.onLoadComment,
  });

  final int? sourceType;
  final int? mediaType;
  final Future<List<Post>> Function(int)? onLoadPost;
  final Future<List<Comment>> Function(int)? onLoadComment;
  final Future<List<Gallery>> Function(int)? onLoadGallery;
  final Future<List<Video>> Function(int)? onLoadVideo;
  final Future<List<Audio>> Function(int)? onLoadAudio;
  final Future<List<Article>> Function(int)? onLoadArticle;
  final Future<List<Album>> Function(int)? onLoadAlbum;
  final Future<List<User>> Function(int)? onLoadUser;

  @override
  State<CommonSourceList> createState() => _CommonSourceListState();
}

class _CommonSourceListState extends State<CommonSourceList> {
  int sourceType = -1;

  @override
  void initState() {
    super.initState();
    sourceType = widget.sourceType ?? -1;
    if (widget.mediaType != null) {
      switch (widget.mediaType) {
        case SourceType.article:
          sourceType = SourceType.article;
        case SourceType.video:
          sourceType = SourceType.video;
        case SourceType.audio:
          sourceType = SourceType.audio;
        case SourceType.gallery:
          sourceType = SourceType.gallery;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return switch (sourceType) {
      SourceType.post => CommonItemList<Post>(
          onLoad: widget.onLoadPost!,
          itemName: "动态",
          itemHeight: null,
          enableScrollbar: true,
          itemBuilder: (ctx, post, postList, onFresh) {
            return PostListTile(
              key: ValueKey(post.id),
              post: post,
              onDeletePost: (Post post) {
                postList?.remove(post);
                setState(() {});
              },
              feedback: post.feedback ?? post_feedback.Feedback(),
            );
          },
        ),
      SourceType.comment => CommonItemList<Comment>(
          onLoad: widget.onLoadComment!,
          itemName: "评论",
          itemHeight: null,
          enableScrollbar: true,
          itemBuilder: (ctx, comment, commentList, onFresh) {
            return CommentListTile(
              key: ValueKey(comment.id),
              comment: comment,
              onDeleteComment: (Comment comment) {
                commentList?.remove(comment);
                setState(() {});
              },
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReplyPage(
                      comment: comment,
                      onDeleteComment: (comment) {
                        commentList?.remove(comment);
                        setState(() {});
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      SourceType.video => CommonItemList<Video>(
          onLoad: widget.onLoadVideo!,
          itemName: "视频",
          itemHeight: null,
          isGrip: false,
          enableScrollbar: true,
          itemBuilder: (ctx, video, videoList, onFresh) {
            return VideoListTile(
              key: ValueKey(video.id),
              video: video,
              onUpdateMedia: (m) {
                if (m.id == video.id) {
                  video.copyVideo(m);
                  setState(() {});
                } else {
                  if (MediaUtils.updateMediaInList(videoList, m)) {
                    setState(() {});
                  }
                }
              },
              onDeleteMedia: (m) {
                if (MediaUtils.deleteMediaInList(videoList, m)) {
                  setState(() {});
                }
              },
            );
          },
        ),
      SourceType.audio => CommonItemList<Audio>(
          onLoad: widget.onLoadAudio!,
          itemName: "音频",
          itemHeight: null,
          isGrip: false,
          enableScrollbar: true,
          itemBuilder: (ctx, audio, audioList, onFresh) {
            return AudioListTile(
              key: ValueKey(audio.id),
              audio: audio,
              onUpdateMedia: (m) {
                if (m.id == audio.id) {
                  audio.copyAudio(m);
                  setState(() {});
                } else {
                  if (MediaUtils.updateMediaInList(audioList, m)) {
                    setState(() {});
                  }
                }
              },
              onDeleteMedia: (m) {
                if (MediaUtils.deleteMediaInList(audioList, m)) {
                  setState(() {});
                }
              },
            );
          },
        ),
      SourceType.gallery => CommonItemList<Gallery>(
        onLoad: widget.onLoadGallery!,
          itemName: "图片",
          itemHeight: null,
          isGrip: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 1, crossAxisCount: 2, crossAxisSpacing: 5, mainAxisSpacing: 5),
          enableScrollbar: true,
          itemBuilder: (ctx, gallery, galleryList, onFresh) {
            return GalleryListTile(
              key: ValueKey(gallery.id),
              gallery: gallery,
              onUpdateMedia: (m) {
                if (m.id == gallery.id) {
                  gallery.copyGallery(m);
                  setState(() {});
                } else {
                  if (MediaUtils.updateMediaInList(galleryList, m)) {
                    setState(() {});
                  }
                }
              },
              onDeleteMedia: (m) {
                if (MediaUtils.deleteMediaInList(galleryList, m)) {
                  setState(() {});
                }
              },
            );
          },
        ),
      SourceType.article => CommonItemList<Article>(
          onLoad: widget.onLoadArticle!,
          itemName: "文章",
          itemHeight: null,
          isGrip: false,
          enableScrollbar: true,
          itemBuilder: (ctx, article, articleList, onFresh) {
            return ArticleListTile(
              key: ValueKey(article.id),
              article: article,
              onUpdateMedia: (m) {
                if (m.id == article.id) {
                  article.copyArticle(m);
                  setState(() {});
                } else {
                  if (MediaUtils.updateMediaInList(articleList, m)) {
                    setState(() {});
                  }
                }
              },
              onDeleteMedia: (m) {
                if (MediaUtils.deleteMediaInList(articleList, m)) {
                  setState(() {});
                }
              },
            );
          },
        ),
      SourceType.album => CommonItemList<Album>(
          onLoad: widget.onLoadAlbum!,
          itemName: "合集",
          itemHeight: null,
          isGrip: false,
          enableScrollbar: true,
          itemBuilder: (ctx, album, albumList, onFresh) {
            return Container(
              color: colorScheme.surface,
              margin: const EdgeInsets.only(top: 2),
              child: AlbumListTile(
                key: ValueKey(album.id),
                album: album,
                onUpdateAlbum: (a) {
                  album.copyAlbum(a);
                  setState(() {});
                },
                onDeleteAlbum: (a) {
                  if (albumList != null) {
                    albumList.remove(a);
                    setState(() {});
                  }
                },
              ),
            );
          },
        ),
      _ => const Center(
          child: Text("获取失败"),
        ),
    };
  }
}

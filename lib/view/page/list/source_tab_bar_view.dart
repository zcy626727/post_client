import 'package:flutter/material.dart';

import '../../../model/media/album.dart';
import '../../../model/media/article.dart';
import '../../../model/media/audio.dart';
import '../../../model/media/gallery.dart';
import '../../../model/media/media.dart';
import '../../../model/media/video.dart';
import '../../../model/message/feed_feedback.dart';
import '../../../model/message/post.dart';
import '../../../model/user/user.dart';
import '../../component/media/list/album_list_tile.dart';
import '../../component/media/list/article_list_tile.dart';
import '../../component/media/list/audio_list_tile.dart';
import '../../component/media/list/gallery_list_tile.dart';
import '../../component/media/list/video_list_tile.dart';
import '../../component/post/post_list_tile.dart';
import '../../widget/common_item_list.dart';

class SourceTabBarView extends StatefulWidget {
  const SourceTabBarView({
    super.key,
    this.onLoadPost,
    this.onLoadGallery,
    this.onLoadVideo,
    this.onLoadAudio,
    this.onLoadArticle,
    this.onLoadAlbum,
    this.onLoadUser,
  });

  final Future<List<Post>> Function(int)? onLoadPost;
  final Future<List<Gallery>> Function(int)? onLoadGallery;
  final Future<List<Video>> Function(int)? onLoadVideo;
  final Future<List<Audio>> Function(int)? onLoadAudio;
  final Future<List<Article>> Function(int)? onLoadArticle;
  final Future<List<Album>> Function(int)? onLoadAlbum;
  final Future<List<User>> Function(int)? onLoadUser;

  @override
  State<SourceTabBarView> createState() => _SourceTabBarViewState();
}

class _SourceTabBarViewState extends State<SourceTabBarView> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      children: [
        if (widget.onLoadPost != null)
          CommonItemList<Post>(
            onLoad: widget.onLoadPost!,
            itemName: "动态",
            itemHeight: null,
            isGrip: false,
            gripAspectRatio: 1,
            enableScrollbar: true,
            itemBuilder: (ctx, post, postList, onFresh) {
              return PostListTile(
                key: ValueKey(post.id),
                post: post,
                onDeletePost: (deletedPost) {
                  if (postList != null) {
                    postList.remove(deletedPost);
                    setState(() {});
                  }
                },
                feedback: post.feedback ?? FeedFeedback(),
              );
            },
          ),
        if (widget.onLoadGallery != null)
          CommonItemList<Gallery>(
            onLoad: widget.onLoadGallery!,
            itemName: "图片",
            itemHeight: null,
            isGrip: true,
            gripAspectRatio: 1,
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
        if (widget.onLoadVideo != null)
          CommonItemList<Video>(
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
        if (widget.onLoadAudio != null)
          CommonItemList<Audio>(
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
        if (widget.onLoadArticle != null)
          CommonItemList<Article>(
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
        if (widget.onLoadAlbum != null)
          CommonItemList<Album>(
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
        if (widget.onLoadUser != null)
          CommonItemList<User>(
            onLoad: widget.onLoadUser!,
            itemName: "用户",
            itemHeight: null,
            isGrip: false,
            enableScrollbar: true,
            itemBuilder: (ctx, user, userList, onFresh) {
              return Container(
                color: colorScheme.surface,
                margin: const EdgeInsets.only(top: 2),
                child: ListTile(
                  key: ValueKey(user.id),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.avatarUrl ?? ""),
                  ),
                  onTap: () {},
                  title: Text(user.name ?? ""),
                  subtitle: Text(""),
                ),
              );
            },
          ),
      ],
    );
  }
}

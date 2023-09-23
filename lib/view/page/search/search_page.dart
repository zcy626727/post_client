import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:post_client/constant/source.dart';
import 'package:post_client/model/user/user.dart';
import 'package:post_client/service/message/post_service.dart';
import 'package:post_client/service/user/user_service.dart';

import '../../../model/media/article.dart';
import '../../../model/media/audio.dart';
import '../../../model/media/gallery.dart';
import '../../../model/media/video.dart';
import '../../../model/message/feed_feedback.dart';
import '../../../model/message/post.dart';
import '../../../service/media/article_service.dart';
import '../../../service/media/audio_service.dart';
import '../../../service/media/gallery_service.dart';
import '../../../service/media/video_service.dart';
import '../../component/media/list/article_list_tile.dart';
import '../../component/media/list/audio_list_tile.dart';
import '../../component/media/list/gallery_list_tile.dart';
import '../../component/media/list/video_list_tile.dart';
import '../../component/post/post_list.dart';
import '../../component/post/post_list_tile.dart';
import '../../widget/common_item_list.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool showSearchResult = false;

  String _keyword = "";
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        toolbarHeight: 45,
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        leading: IconButton(
          splashRadius: 20,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: colorScheme.onBackground,
            size: 20,
          ),
        ),
        titleSpacing: 0,
        title: Container(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: CupertinoSearchTextField(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            prefixInsets: const EdgeInsets.only(left: 10, top: 3),
            onChanged: (value) {
              _keyword = value;
            },
            focusNode: _focusNode,
            onSubmitted: (value) {
              if (!showSearchResult) showSearchResult = true;
              setState(() {});
            },
          ),
        ),
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(left: 5, right: 5),
              width: 50,
              height: 34,
              child: TextButton(
                onPressed: () {
                  if (!showSearchResult) showSearchResult = true;
                  setState(() {});
                },
                child: const Text("搜索"),
              ),
            ),
          )
        ],
      ),
      body: showSearchResult ? searchResultBuild() : recommendBuild(),
    );
  }

  Widget recommendBuild() {
    return Container();
  }

  Widget searchResultBuild() {
    var colorScheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 6,
      child: Container(
        color: colorScheme.surface,
        child: Column(
          children: [
            TabBar(
              labelPadding: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              tabs: [
                buildTab("动态"),
                buildTab("图片"),
                buildTab("视频"),
                buildTab("音频"),
                buildTab("文章"),
                buildTab("用户"),
              ],
            ),
            Expanded(
              child: buildTabBarView(),
            ),
          ],
        ),
      ),
    );
  }

  Tab buildTab(String title) {
    return Tab(
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        width: 65,
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
      ),
    );
  }

  Widget buildTabBarView() {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.background,
      padding: const EdgeInsets.only(left: 1, right: 1, top: 1),
      child: TabBarView(
        key: ValueKey(DateTime.now()),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          CommonItemList<Post>(
            onLoad: (int page) async {
              var postList = await PostService.searchPost(_keyword, page, 20);
              return postList;
            },
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
          CommonItemList<Gallery>(
            onLoad: (int page) async {
              var galleryList = await GalleryService.searchGallery(_keyword, page, 20);
              return galleryList;
            },
            itemName: "图片",
            itemHeight: null,
            isGrip: true,
            gripAspectRatio: 1,
            enableScrollbar: true,
            itemBuilder: (ctx, gallery, galleryList, onFresh) {
              return GalleryListTile(
                key: ValueKey(gallery.id),
                gallery: gallery,
                onUpdateMedia: (a) {
                  gallery.copyGallery(a);
                  setState(() {});
                },
                onDeleteMedia: (a) {
                  if (galleryList != null) {
                    galleryList.remove(a);
                    setState(() {});
                  }
                },
              );
            },
          ),
          CommonItemList<Video>(
            onLoad: (int page) async {
              var videoList = await VideoService.searchVideo(_keyword, page, 20);
              return videoList;
            },
            itemName: "视频",
            itemHeight: null,
            isGrip: false,
            enableScrollbar: true,
            itemBuilder: (ctx, video, videoList, onFresh) {
              return VideoListTile(
                key: ValueKey(video.id),
                video: video,
                onUpdateMedia: (v) {
                  video.copyGallery(v);
                  setState(() {});
                },
                onDeleteMedia: (v) {
                  if (videoList != null) {
                    videoList.remove(v);
                    setState(() {});
                  }
                },
              );
            },
          ),
          CommonItemList<Audio>(
            onLoad: (int page) async {
              var audioList = await AudioService.searchAudio(_keyword, page, 20);
              return audioList;
            },
            itemName: "音频",
            itemHeight: null,
            isGrip: false,
            enableScrollbar: true,
            itemBuilder: (ctx, audio, audioList, onFresh) {
              return AudioListTile(
                key: ValueKey(audio.id),
                audio: audio,
                onUpdateMedia: (a) {
                  audio.copyAudio(a);
                  setState(() {});
                },
                onDeleteMedia: (a) {
                  if (audioList != null) {
                    audioList.remove(a);
                    setState(() {});
                  }
                },
              );
            },
          ),
          CommonItemList<Article>(
            onLoad: (int page) async {
              var articleList = await ArticleService.searchArticle(_keyword, page, 20);
              return articleList;
            },
            itemName: "文章",
            itemHeight: null,
            isGrip: false,
            enableScrollbar: true,
            itemBuilder: (ctx, article, articleList, onFresh) {
              return ArticleListTile(
                key: ValueKey(article.id),
                article: article,
                onUpdateMedia: (a) {
                  article.copyArticle(a);
                  setState(() {});
                },
                onDeleteMedia: (a) {
                  if (articleList != null) {
                    articleList.remove(a);
                    setState(() {});
                  }
                },
              );
            },
          ),
          CommonItemList<User>(
            onLoad: (int page) async {
              var userList = await UserService.searchUser(_keyword, page, 20);
              return userList;
            },
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
      ),
    );
  }
}

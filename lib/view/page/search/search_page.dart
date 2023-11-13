import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:post_client/service/media/album_service.dart';
import 'package:post_client/service/message/post_service.dart';
import 'package:post_client/service/user/user_service.dart';

import '../../../service/media/article_service.dart';
import '../../../service/media/audio_service.dart';
import '../../../service/media/gallery_service.dart';
import '../../../service/media/video_service.dart';
import '../list/source_tab_bar_view.dart';

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
            style: TextStyle(color: colorScheme.onBackground),
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
      length: 7,
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
                buildTab("合集"),
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
      child: SourceTabBarView(
        onLoadPost: (pageIndex) async {
          var postList = await PostService.searchPost(_keyword, pageIndex, 20);
          return postList;
        },
        onLoadGallery: (pageIndex) async {
          var galleryList = await GalleryService.searchGallery(_keyword, pageIndex, 20);
          return galleryList;
        },
        onLoadVideo: (pageIndex) async {
          var videoList = await VideoService.searchVideo(_keyword, pageIndex, 20);
          return videoList;
        },
        onLoadAudio: (pageIndex) async {
          var audioList = await AudioService.searchAudio(_keyword, pageIndex, 20);
          return audioList;
        },
        onLoadArticle: (pageIndex) async {
          var articleList = await ArticleService.searchArticle(_keyword, pageIndex, 20);
          return articleList;
        },
        onLoadAlbum: (pageIndex) async {
          var userList = await AlbumService.searchAlbum(_keyword, pageIndex, 20);
          return userList;
        },
        onLoadUser: (pageIndex) async {
          var userList = await UserService.searchUser(_keyword, pageIndex, 20);
          return userList;
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:post_client/model/media/gallery.dart';
import 'package:post_client/service/media/gallery_service.dart';
import 'package:post_client/service/media/video_service.dart';
import 'package:post_client/util/responsive.dart';
import 'package:post_client/view/component/media/list/video_list_tile.dart';
import 'package:post_client/view/component/post/post_list.dart';
import 'package:post_client/view/widget/common_item_list.dart';
import 'package:post_client/view/widget/player/common_video_player.dart';
import 'package:provider/provider.dart';

import '../../../model/media/article.dart';
import '../../../model/media/audio.dart';
import '../../../model/media/video.dart';
import '../../../model/user/user.dart';
import '../../../service/media/article_service.dart';
import '../../../service/media/audio_service.dart';
import '../../../service/message/post_service.dart';
import '../../../state/user_state.dart';
import '../../component/media/list/article_list_tile.dart';
import '../../component/media/list/audio_list_tile.dart';
import '../../component/media/list/gallery_list_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Selector<UserState, User>(
      selector: (context, data) => data.user,
      shouldRebuild: (pre, next) => true,
      builder: (context, user, child) {
        return Responsive.isSmallWithDevice(context) ? buildMobile(user) : buildDesktop();
      },
    );
  }

  Widget buildMobile(User user) {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.background,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            //app bar
            SliverAppBar(
              // floating: true,
              // snap: true,
              backgroundColor: colorScheme.surface,
              leading: Container(),
              actions: [
                Container(
                  width: 50.0,
                  height: 50.0,
                  margin: const EdgeInsets.only(left: 5),
                  child: TextButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: CircleAvatar(
                      radius: 16.0,
                      backgroundImage: user.avatarUrl == null ? null : NetworkImage(user.avatarUrl!),
                    ),
                  ),
                )
              ],
            ),
          ];
        },
        body: DefaultTabController(
          length: 5,
          child: Column(
            children: [
              Divider(
                height: 2,
                color: colorScheme.background,
              ),
              //tab bar
              const HomeScreenTabBar(),
              //tab bar view list
              Expanded(
                child: buildTabBarView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDesktop() {
    return Container(
      child: CommonVideoPlayer(videoUrl: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"),
      // child: CommonAudioPlayerMini(audioUrl: "http://downsc.chinaz.net/Files/DownLoad/sound1/201906/11582.mp3"),
      // child: CommonAudioPlayerMini2(audioUrl: "http://archlinux:9000/file/public/3d234c392d1a5100214dcebf97c3991b"),
      // child: CommonAudioPlayerMini2(audioUrl: "http://192.168.239.148:9000/file/public/4444"),
    );
  }

  Widget buildTabBarView() {
    return Container(
      margin: const EdgeInsets.only(left: 3, right: 3, top: 1),
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          PostList(
            onLoad: (int page) async {
              var postList = await PostService.getPostListRandom(20);

              return postList;
            },
            enableRefresh: true,
            itemName: "动态",
            itemHeight: null,
            enableScrollbar: true,
          ),
          CommonItemList<Gallery>(
            onLoad: (int page) async {
              var galleryList = await GalleryService.getGalleryListRandom(20);
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
              var videoList = await VideoService.getVideoListRandom(20);
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
              var audioList = await AudioService.getAudioListRandom(20);
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
              var articleList = await ArticleService.getArticleListRandom(20);
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
        ],
      ),
    );
  }
}

class HomeScreenTabBar extends StatefulWidget {
  const HomeScreenTabBar({Key? key}) : super(key: key);

  @override
  State<HomeScreenTabBar> createState() => _HomeScreenTabBarState();
}

class _HomeScreenTabBarState extends State<HomeScreenTabBar> {
  static const double iconSize = 28;

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 50,
      width: double.infinity,
      color: colorScheme.surface,
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15.0),
      child: TabBar(
          onTap: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          //指示器大小设置为和label一致
          indicatorSize: TabBarIndicatorSize.label,
          //启动滚动(选项多时启用)
          isScrollable: true,
          //未选中内容颜色
          unselectedLabelColor: Colors.grey,
          //选中内容颜色
          labelColor: colorScheme.primary,
          //label间距
          labelPadding: const EdgeInsets.symmetric(horizontal: 3.0),
          indicator: BoxDecoration(
            color: colorScheme.primaryContainer,
            //形状
            borderRadius: BorderRadius.circular(50),
          ),
          splashBorderRadius: BorderRadius.circular(50),
          tabs: [
            tabBuild(0, Icons.topic, "动态"),
            tabBuild(1, Icons.image, "图片"),
            tabBuild(2, Icons.video_collection_sharp, "视频"),
            tabBuild(3, Icons.audiotrack, "音频"),
            tabBuild(4, Icons.article, "文章"),
          ]),
    );
  }

  Widget tabBuild(int index, IconData iconData, String title) {
    return Tab(
      iconMargin: EdgeInsets.zero,
      child: SizedBox(
        //高度会自动填充剩余部分，设置宽度以保证背景圆形
        width: 85,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: iconSize,
            ),
            const SizedBox(width: 5),
            if (_currentPage == index) Text(title),
          ],
        ),
      ),
    );
  }
}

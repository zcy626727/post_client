import 'package:flutter/material.dart';
import 'package:post_client/config/global.dart';
import 'package:post_client/config/page_config.dart';
import 'package:post_client/service/post/album_service.dart';
import 'package:post_client/service/post/gallery_service.dart';
import 'package:post_client/service/post/video_service.dart';
import 'package:post_client/util/responsive.dart';
import 'package:post_client/view/page/message/message_page.dart';
import 'package:post_client/view/widget/player/common_video_player.dart';
import 'package:provider/provider.dart';

import '../../../model/user/user.dart';
import '../../../service/post/article_service.dart';
import '../../../service/post/audio_service.dart';
import '../../../service/post/post_service.dart';
import '../../../state/user_state.dart';
import '../../page/list/source_tab_bar_view.dart';
import '../../page/search/search_page.dart';

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
              leadingWidth: 0,
              titleSpacing: 0,
              leading: Container(),
              title: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage()));
                  },
                  child: Container(
                    height: 35,
                    margin: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface.withAlpha(20),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 55,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 3),
                              child: Icon(
                                Icons.search,
                                color: colorScheme.onSurface.withAlpha(100),
                                size: 18,
                              ),
                            ),
                            Text(
                              "搜索",
                              style: TextStyle(color: colorScheme.onSurface.withAlpha(100), fontSize: 16),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                Container(
                  height: 40,
                  width: 40,
                  margin: const EdgeInsets.only(left: 5),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      if (Global.user.token == null) {
                        Navigator.pushNamed(context, "login");
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MessagePage()),
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.notifications_on,
                      size: 30,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(right: 5),
                  child: TextButton(
                    style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: CircleAvatar(
                      radius: 14.0,
                      backgroundColor: colorScheme.primaryContainer,
                      backgroundImage: user.avatarUrl == null ? null : NetworkImage(user.avatarUrl!),
                    ),
                  ),
                ),
              ],
            ),
          ];
        },
        body: DefaultTabController(
          length: 6,
          child: Column(
            children: [
              Divider(
                height: 1,
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
      child: const CommonVideoPlayer(videoUrl: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"),
      // child: CommonAudioPlayerMini(audioUrl: "http://downsc.chinaz.net/Files/DownLoad/sound1/201906/11582.mp3"),
      // child: CommonAudioPlayerMini2(audioUrl: "http://archlinux:9000/file/public/3d234c392d1a5100214dcebf97c3991b"),
      // child: CommonAudioPlayerMini2(audioUrl: "http://192.168.239.148:9000/file/public/4444"),
    );
  }

  Widget buildTabBarView() {
    return Container(
      margin: const EdgeInsets.only(top: 1),
      child: SourceTabBarView(
        onLoadPost: (pageIndex) async {
          var postList = await PostService.getPostListRandom(20);
          return postList;
        },
        onLoadGallery: (pageIndex) async {
          var galleryList = await GalleryService.getGalleryListRandom(PageConfig.commonPageSize);
          return galleryList;
        },
        onLoadVideo: (pageIndex) async {
          var videoList = await VideoService.getVideoListRandom(PageConfig.commonPageSize);
          return videoList;
        },
        onLoadAudio: (pageIndex) async {
          var audioList = await AudioService.getAudioListRandom(PageConfig.commonPageSize);
          return audioList;
        },
        onLoadArticle: (pageIndex) async {
          var articleList = await ArticleService.getArticleListRandom(PageConfig.commonPageSize);
          return articleList;
        },
        onLoadAlbum: (pageIndex) async {
          var albumList = await AlbumService.getAlbumListRandom(PageConfig.commonPageSize);
          return albumList;
        },
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
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: TabBar(
          onTap: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          tabAlignment: TabAlignment.center,
          //指示器大小设置为和label一致
          indicatorSize: TabBarIndicatorSize.label,
          //启动滚动(选项多时启用)
          isScrollable: true,
          dividerColor: Colors.transparent,
          //未选中内容颜色
          unselectedLabelColor: Colors.grey,
          //选中内容颜色
          labelColor: colorScheme.primary,
          //label间距
          labelPadding: const EdgeInsets.symmetric(horizontal: 5.0),
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
            tabBuild(5, Icons.album, "合集"),
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

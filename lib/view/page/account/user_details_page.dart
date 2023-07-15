import 'package:flutter/material.dart';
import 'package:post_client/config/global.dart';
import 'package:post_client/model/post.dart';
import 'package:post_client/service/post_service.dart';
import 'package:post_client/state/user_state.dart';
import 'package:post_client/view/component/post/post_list_tile.dart';
import 'package:post_client/view/component/post/post_list.dart';
import 'package:post_client/view/widget/common_item_list.dart';
import 'package:provider/provider.dart';

import '../../../config/constants.dart';
import '../../../model/article.dart';
import '../../../model/audio.dart';
import '../../../model/gallery.dart';
import '../../../model/user.dart';
import '../../../model/video.dart';
import '../../../service/article_service.dart';
import '../../../service/audio_service.dart';
import '../../../service/gallery_service.dart';
import '../../../service/video_service.dart';
import '../../component/media/article_list_tile.dart';
import '../../component/media/audio_list_tile.dart';
import '../../component/media/gallery_list_tile.dart';
import '../../component/media/video_list_tile.dart';

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({Key? key}) : super(key: key);

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  @override
  Widget build(BuildContext context) {
    var userState = Provider.of<UserState>(context);

    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: DefaultTabController(
        length: 5,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  backgroundColor: colorScheme.surface,
                  pinned: true,
                  //划到上面时标题栏是否隐藏
                  floating: false,
                  //向下滑动一点就显示全部
                  snap: false,
                  primary: true,
                  expandedHeight: 300,
                  toolbarHeight: 50,
                  leading: Center(
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Material(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                        clipBehavior: Clip.hardEdge,
                        color: colorScheme.surface.withAlpha(100),
                        child: IconButton(
                          splashRadius: 20,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: buildProfileCard(userState.user),
                  ),
                  bottom: PreferredSize(
                    //如果高度有问题就改这里的值
                    preferredSize: const Size(double.infinity, 30),
                    child: Container(
                      color: colorScheme.surface,
                      child: TabBar(
                        labelPadding: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        tabs: [
                          buildTab("动态"),
                          buildTab("图片"),
                          buildTab("视频"),
                          buildTab("音频"),
                          buildTab("文章"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: Container(
            margin: const EdgeInsets.only(top: 80),
            child: buildTabBarView(),
          ),
        ),
      ),
    );
  }

  final double backgroundImageHeight = 150;

  //用户资料
  Widget buildProfileCard(User user) {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          //背景图
          Image(
            image: NetworkImage(user.avatarUrl!),
            height: backgroundImageHeight,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          //个人信息等
          Container(
            margin: EdgeInsets.only(top: backgroundImageHeight),
            padding: const EdgeInsets.only(left: 20),
            width: double.infinity,
            color: colorScheme.surface,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //名字
                Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: Text(
                    Global.user.name ?? "未知",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: colorScheme.onSurface),
                  ),
                ),
              ],
            ),
          ),
          //头像、按钮
          Container(
            margin: EdgeInsets.only(left: 20, top: backgroundImageHeight - 35),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(user.avatarUrl!),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 40),
                  height: 30,
                  child: OutlinedButton(onPressed: () {}, child: const Text("编辑资料")),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTabBarView() {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.background,
      padding: const EdgeInsets.only(left: 1, right: 1, top: 1),
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          PostList(
            onLoad: (int page) async {
              var postList = await PostService.getPostListByUserId(Global.user, page, 20);
              return postList;
            },
            enableRefresh: true,
            itemName: "动态",
            itemHeight: null,
            enableScrollbar: true,
          ),
          CommonItemList<Gallery>(
            onLoad: (int page) async {
              var galleryList = await GalleryService.getGalleryListByUserId(Global.user, page, 20);
              return galleryList;
            },
            itemName: "图片",
            itemHeight: null,
            isGrip: true,
            gripAspectRatio: 1,
            enableScrollbar: true,
            itemBuilder: (ctx, gallery, galleryList, onFresh) {
              return GalleryListTile(gallery: gallery);
            },
          ),
          CommonItemList<Video>(
            onLoad: (int page) async {
              var videoList = await VideoService.getVideoListByUserId(Global.user, page, 20);
              return videoList;
            },
            itemName: "视频",
            itemHeight: null,
            isGrip: false,
            enableScrollbar: true,
            itemBuilder: (ctx, video, videoList, onFresh) {
              return VideoListTile(
                video: video,
                onDelete: (video) {
                  if (videoList != null) {
                    videoList.remove(video);
                  }
                },
              );
            },
          ),
          CommonItemList<Audio>(
            onLoad: (int page) async {
              var audioList = await AudioService.getAudioListByUserId(Global.user, page, 20);
              return audioList;
            },
            itemName: "音频",
            itemHeight: null,
            isGrip: false,
            enableScrollbar: true,
            itemBuilder: (ctx, audio, audioList, onFresh) {
              return AudioListTile(audio: audio);
            },
          ),
          CommonItemList<Article>(
            onLoad: (int page) async {
              var articleList = await ArticleService.getArticleListByUserId(Global.user, page, 20);
              return articleList;
            },
            itemName: "文章",
            itemHeight: null,
            isGrip: false,
            enableScrollbar: true,
            itemBuilder: (ctx, article, articleList, onFresh) {
              return ArticleListTile(article: article);
            },
          ),
        ],
      ),
    );
  }

  Tab buildTab(String title) {
    return Tab(
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
      ),
    );
  }
}

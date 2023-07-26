import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:post_client/config/global.dart';
import 'package:post_client/model/user/follow.dart';
import 'package:post_client/service/user/follow_service.dart';
import 'package:post_client/state/user_state.dart';
import 'package:post_client/view/component/post/post_list.dart';
import 'package:post_client/view/component/show/show_snack_bar.dart';
import 'package:post_client/view/page/account/user_profile_page.dart';
import 'package:post_client/view/widget/button/common_action_one_button.dart';
import 'package:post_client/view/widget/common_item_list.dart';
import 'package:provider/provider.dart';

import '../../../model/media/article.dart';
import '../../../model/media/audio.dart';
import '../../../model/media/gallery.dart';
import '../../../model/media/video.dart';
import '../../../model/user/user.dart';
import '../../../service/media/article_service.dart';
import '../../../service/media/audio_service.dart';
import '../../../service/media/gallery_service.dart';
import '../../../service/media/video_service.dart';
import '../../../service/message/post_service.dart';
import '../../component/media/list/article_list_tile.dart';
import '../../component/media/list/audio_list_tile.dart';
import '../../component/media/list/gallery_list_tile.dart';
import '../../component/media/list/video_list_tile.dart';

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  late Future _futureBuilderFuture;

  Follow? _follow;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
  }

  Future getData() async {
    var s = ScrollController();
    return Future.wait([getDataList()]);
  }

  Future<void> getDataList() async {
    try {
      _follow = await FollowService.getFollow(followerId: Global.user.id!, followeeId: widget.user.id!);
    } on DioException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var userState = Provider.of<UserState>(context);

    var colorScheme = Theme.of(context).colorScheme;
    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
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
                    widget.user.name ?? "未知",
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
                  width: 100,
                  child: widget.user.id != null && widget.user.id == Global.user.id
                      ? OutlinedButton(
                          onPressed: () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfilePage()));
                          },
                          child: const Text("编辑资料"))
                      : _follow == null
                          ? CommonActionOneButton(
                              title: "关注",
                              backgroundColor: colorScheme.primary,
                              textColor: colorScheme.onPrimary,
                              onTap: () async {
                                try {
                                  _follow = await FollowService.followUser(widget.user.id!);
                                  setState(() {});
                                } on Exception catch (e) {
                                  ShowSnackBar.exception(context: context, e: e);
                                }
                                return false;
                              },
                            )
                          : CommonActionOneButton(
                              title: "取消关注",
                              textColor: colorScheme.onSurface,
                              onTap: () async {
                                try {
                                  await FollowService.unfollowUser(
                                    followerId: Global.user.id!,
                                    followeeId: widget.user.id!,
                                  );
                                  _follow = null;
                                  setState(() {});
                                } on Exception catch (e) {
                                  ShowSnackBar.exception(context: context, e: e);
                                }
                                return false;
                              },
                            ),
                ),
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
              var postList = await PostService.getPostListByUserId(widget.user, page, 20);
              return postList;
            },
            enableRefresh: true,
            itemName: "动态",
            itemHeight: null,
            enableScrollbar: true,
          ),
          CommonItemList<Gallery>(
            onLoad: (int page) async {
              var galleryList = await GalleryService.getGalleryListByUserId(widget.user, page, 20);
              return galleryList;
            },
            itemName: "图片",
            itemHeight: null,
            isGrip: true,
            gripAspectRatio: 1,
            enableScrollbar: true,
            itemBuilder: (ctx, gallery, galleryList, onFresh) {
              return GalleryListTile(
                gallery: gallery,
                onUpdateMedia: (a) {
                  gallery.copyGallery(a);
                  setState(() {});
                },
                onDeleteMedia: (a) {
                  if (galleryList != null) {
                    galleryList.remove(gallery);
                    setState(() {});
                  }
                },
              );
            },
          ),
          CommonItemList<Video>(
            onLoad: (int page) async {
              var videoList = await VideoService.getVideoListByUserId(widget.user, page, 20);
              return videoList;
            },
            itemName: "视频",
            itemHeight: null,
            isGrip: false,
            enableScrollbar: true,
            itemBuilder: (ctx, video, videoList, onFresh) {
              return VideoListTile(
                video: video,
                onUpdateMedia: (a) {
                  video.copyGallery(a);
                  setState(() {});
                },
                onDeleteMedia: (a) {
                  if (videoList != null) {
                    videoList.remove(video);
                    setState(() {});
                  }
                },
              );
            },
          ),
          CommonItemList<Audio>(
            onLoad: (int page) async {
              var audioList = await AudioService.getAudioListByUserId(widget.user, page, 20);
              return audioList;
            },
            itemName: "音频",
            itemHeight: null,
            isGrip: false,
            enableScrollbar: true,
            itemBuilder: (ctx, audio, audioList, onFresh) {
              return AudioListTile(
                audio: audio,
                onUpdateMedia: (a) {
                  audio.copyAudio(a);
                  setState(() {});
                },
                onDeleteMedia: (a) {
                  if (audioList != null) {
                    audioList.remove(audio);
                    setState(() {});
                  }
                },
              );
            },
          ),
          CommonItemList<Article>(
            onLoad: (int page) async {
              var articleList = await ArticleService.getArticleListByUserId(widget.user, page, 20);
              return articleList;
            },
            itemName: "文章",
            itemHeight: null,
            isGrip: false,
            enableScrollbar: true,
            itemBuilder: (ctx, article, articleList, onFresh) {
              return ArticleListTile(
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

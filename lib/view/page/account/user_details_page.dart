import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:post_client/config/global.dart';
import 'package:post_client/model/user/follow.dart';
import 'package:post_client/service/message/user_message_service.dart';
import 'package:post_client/view/component/show/show_snack_bar.dart';
import 'package:post_client/view/page/account/user_profile_page.dart';
import 'package:post_client/view/page/chat/chat_page.dart';
import 'package:post_client/view/widget/button/common_action_one_button.dart';

import '../../../config/page_config.dart';
import '../../../model/user/user.dart';
import '../../../service/post/album_service.dart';
import '../../../service/post/article_service.dart';
import '../../../service/post/audio_service.dart';
import '../../../service/post/follow_service.dart';
import '../../../service/post/gallery_service.dart';
import '../../../service/post/post_service.dart';
import '../../../service/post/video_service.dart';
import '../list/source_tab_bar_view.dart';

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
    var colorScheme = Theme.of(context).colorScheme;
    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          return Scaffold(
            body: DefaultTabController(
              length: 6,
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
                          background: buildProfileCard(widget.user),
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
                                buildTab("合集"),
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
                    height: 35,
                    child: Row(
                      children: [
                        if (widget.user.id != null && widget.user.id != Global.user.id)
                          Container(
                            margin: const EdgeInsets.only(right: 5),
                            width: 35,
                            child: OutlinedButton(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(EdgeInsets.zero),
                                shape: MaterialStateProperty.all(
                                  const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                if (widget.user.id == null) return;

                                var inter = await UserMessageService.getInteraction(targetUserId: widget.user.id!);
                                inter.otherUser = widget.user;
                                await Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(userInteraction: inter)));
                              },
                              child: Icon(
                                Icons.chat_bubble,
                                size: 20,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        widget.user.id != null && widget.user.id == Global.user.id
                            ? OutlinedButton(
                                onPressed: () async {
                                  await Navigator.push(context, MaterialPageRoute(builder: (context) => const UserProfilePage()));
                                },
                                child: const Text("编辑资料"),
                              )
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
                                        if (mounted) ShowSnackBar.exception(context: context, e: e);
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
                      ],
                    )),
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
      child: SourceTabBarView(
        onLoadPost: (pageIndex) async {
          var postList = await PostService.getPostListByUserId(widget.user, pageIndex, 20);
          return postList;
        },
        onLoadGallery: (pageIndex) async {
          var galleryList = await GalleryService.getGalleryListByUserId(widget.user, pageIndex, 20);
          return galleryList;
        },
        onLoadVideo: (pageIndex) async {
          var videoList = await VideoService.getVideoListByUserId(widget.user, pageIndex, 20);
          return videoList;
        },
        onLoadAudio: (pageIndex) async {
          var audioList = await AudioService.getAudioListByUserId(widget.user, pageIndex, 20);
          return audioList;
        },
        onLoadArticle: (pageIndex) async {
          var articleList = await ArticleService.getArticleListByUserId(widget.user, pageIndex, 20);
          return articleList;
        },
        onLoadAlbum: (pageIndex) async {
          var albumList = await AlbumService.getAlbumListByUserId(widget.user, pageIndex, PageConfig.commonPageSize);
          return albumList;
        },
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

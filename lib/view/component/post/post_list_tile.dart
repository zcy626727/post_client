import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:intl/intl.dart';
import 'package:post_client/config/constants.dart';
import 'package:post_client/config/global.dart';
import 'package:post_client/model/media/gallery.dart';
import 'package:post_client/model/message/feed_feedback.dart';
import 'package:post_client/view/component/feedback/feed_feedback_bar.dart';
import 'package:post_client/view/component/media/list/video_list_tile.dart';
import 'package:post_client/view/component/quill/quill_editor.dart';

import '../../../constant/feed.dart';
import '../../../model/media/article.dart';
import '../../../model/media/audio.dart';
import '../../../model/media/video.dart';
import '../../../model/message/comment.dart';
import '../../../model/message/post.dart';
import '../../../service/message/post_service.dart';
import '../../page/account/user_details_page.dart';
import '../../page/comment/comment_page.dart';
import '../../widget/dialog/confirm_alert_dialog.dart';
import '../media/list/article_list_tile.dart';
import '../media/list/audio_list_tile.dart';
import '../media/list/gallery_list_tile.dart';
import '../show/show_snack_bar.dart';

class PostListTile extends StatefulWidget {
  final Post post;
  final FeedFeedback feedback;
  final Function(Post) onDeletePost;

  const PostListTile({
    Key? key,
    required this.post,
    required this.onDeletePost,
    required this.feedback,
  }) : super(key: key);

  @override
  State<PostListTile> createState() => _PostListTileState();
}

class _PostListTileState extends State<PostListTile> {
  int commentLen = 0;
  bool isLikeAnimating = false;
  final QuillController controller = QuillController.basic();

  @override
  void initState() {
    super.initState();
    if (!widget.post.isSourceMode()) {
      controller.document = Document.fromJson(json.decode(widget.post.content ?? ""));
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      // boundary needed for web
      color: colorScheme.surface,
      margin: const EdgeInsets.only(bottom: 1),
      padding: const EdgeInsets.only(left: 6.0, right: 6.0),
      child: Column(
        children: [
          // 用户信息
          buildUserInfo(),
          //文本
          buildText(),
          //图片列表
          if (!widget.post.isSourceMode() && widget.post.pictureUrlList != null && widget.post.pictureUrlList!.isNotEmpty) buildPictureList(),
          // 媒体
          if (widget.post.isSourceMode()) buildMediaCard(),
          // 点赞、收藏等
          buildOperation(),
          // 描述信息
          // if (widget.post.isSourceMode()) buildDescribe()
        ],
      ),
    );
  }

  Widget buildUserInfo() {
    var colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
      leading: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserDetailPage(user: widget.post.user!)),
          );
        },
        child: CircleAvatar(
          radius: 18,
          backgroundImage: NetworkImage(
            widget.post.user == null ? testImageUrl : widget.post.user!.avatarUrl!,
          ),
        ),
      ),
      title: Text(
        widget.post.user!.name!,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        DateFormat("yyyy-MM-dd").format(widget.post.createTime!),
        style: TextStyle(
          color: colorScheme.onSurface,
        ),
      ),
      trailing: Container(
        margin: const EdgeInsets.only(right: 3),
        width: 35,
        child: PopupMenuButton<String>(
          itemBuilder: (BuildContext context) {
            return [
              if (widget.post.user!.id! == Global.user.id!)
                PopupMenuItem(
                  height: 35,
                  value: 'delete',
                  child: Text(
                    '删除',
                    style: TextStyle(color: colorScheme.onBackground.withAlpha(200), fontSize: 14),
                  ),
                ),
            ];
          },
          icon: Icon(Icons.more_horiz, color: colorScheme.onSurface),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              width: 1,
              color: colorScheme.onSurface.withAlpha(30),
              style: BorderStyle.solid,
            ),
          ),
          color: colorScheme.surface,
          onSelected: (value) async {
            switch (value) {
              case "delete":
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmAlertDialog(
                      text: "是否确定删除？",
                      onConfirm: () async {
                        try {
                          await PostService.deletePost(widget.post.id!);
                          widget.onDeletePost(widget.post);
                        } on DioException catch (e) {
                          ShowSnackBar.exception(context: context, e: e, defaultValue: "删除失败");
                        } finally {
                          Navigator.pop(context);
                        }
                      },
                      onCancel: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                );
                break;
            }
          },
        ),
      ),
    );
  }

  Widget buildText() {
    return (!widget.post.isSourceMode())
        ? Container(
            margin: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
            width: double.infinity,
            child: PostQuillEditor(
              controller: controller,
              focusNode: FocusNode(),
              readOnly: true,
            ),
          )
        : widget.post.content != null && widget.post.content!.isNotEmpty
            ? Text(
                widget.post.content!,
              )
            : Container();
  }

  Widget buildPictureList() {
    var colorScheme = Theme.of(context).colorScheme;

    var picList = widget.post.pictureUrlList!;
    if (picList.length == 1) {
      return Image(image: NetworkImage(picList[0]));
    } else {
      int itemCount = picList.length <= 9 ? picList.length : 9;
      return GridView.builder(
        itemCount: itemCount,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          crossAxisSpacing: 2.0,
          mainAxisSpacing: 2.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          if (index == 8 && picList.length > 9) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: colorScheme.background,
              ),
              child: Center(
                child: Text(
                  '+${picList.length - 8}',
                  style: TextStyle(fontSize: 16.0, color: colorScheme.onBackground),
                ),
              ),
            );
          } else {
            return GestureDetector(
              onTap: () {
                // 点击图片的操作
                print('点击图片');
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: NetworkImage(picList[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          }
        },
      );
    }
  }

  Widget buildMediaCard() {
    Widget mediaCard = Container();
    var colorScheme = Theme.of(context).colorScheme;

    var media = widget.post.media;
    if (media == null) {
      return Text(
        "媒体获取失败",
        style: TextStyle(color: colorScheme.onSurface),
      );
    }
    if (media is Article) {
      mediaCard = ArticleListTile(
        article: media,
        isInner: true,
      );
    } else if (media is Audio) {
      mediaCard = AudioListTile(
        audio: media,
        isInner: true,
      );
    } else if (media is Gallery) {
      mediaCard = GalleryListTile(
        gallery: media,
        isInner: true,
      );
    } else if (media is Video) {
      mediaCard = VideoListTile(
        video: media,
        isInner: true,
      );
    }
    return GestureDetector(
      onDoubleTap: () {},
      child: Container(
        color: colorScheme.primaryContainer,
        padding: const EdgeInsets.only(left: 2, right: 2, top: 2, bottom: 2),
        width: double.infinity,
        child: mediaCard,
      ),
    );
  }

  Widget buildOperation() {
    var colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: [
            //评论
            IconButton(
              icon: const Icon(
                Icons.comment,
              ),
              color: colorScheme.onSurface,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CommentPage(
                            commentParentType: CommentParentType.post,
                            commentParentId: widget.post.id!,
                            parentUserId: widget.post.userId!,
                          )),
                );
              },
            ),
          ],
        ),
        FeedFeedbackBar(feedType: FeedType.post, feed: widget.post, feedFeedback: widget.feedback, feedId: widget.post.id!)
      ],
    );
  }

  Widget buildDescribe() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.only(top: 5, bottom: 8),
      width: double.infinity,
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.green),
          children: [
            const TextSpan(
              text: "路由器：",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: widget.post.content,
            ),
          ],
        ),
      ),
    );
  }
}

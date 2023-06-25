import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:intl/intl.dart';
import 'package:post_client/config/global.dart';
import 'package:post_client/model/post.dart';
import 'package:post_client/view/component/quill/quill_editor.dart';
import 'package:post_client/view/page/post/post_comment_page.dart';

import '../../../service/post_service.dart';
import '../../widget/dialog/confirm_alert_dialog.dart';
import '../show/show_snack_bar.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final Function(Post) onDeletePost;

  const PostCard({
    Key? key,
    required this.post,
    required this.onDeletePost,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLen = 0;
  bool isLikeAnimating = false;
  final QuillController controller = QuillController.basic();

  @override
  void initState() {
    super.initState();
    controller.document = Document.fromJson(json.decode(widget.post.content ?? ""));
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      // boundary needed for web
      color: colorScheme.surface,
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.only(left: 3.0, right: 3.0),
      child: Column(
        children: [
          // 用户信息
          buildUserInfo(),
          //文本
          if (!widget.post.isInnerMode()) buildText(),
          //图片列表
          if (!widget.post.isInnerMode() && widget.post.pictureUrlList != null && widget.post.pictureUrlList!.isNotEmpty) buildPictureList(),
          // 媒体
          if (widget.post.isInnerMode()) buildMediaCard(),
          // 点赞、收藏等
          buildOperation(),
          // 描述信息
          if (widget.post.isInnerMode()) buildDescribe()
        ],
      ),
    );
  }

  Widget buildUserInfo() {
    var colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
      leading: CircleAvatar(
        radius: 18,
        backgroundImage: NetworkImage(
          widget.post.user!.avatarUrl!,
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
    return Container(
      margin: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
      width: double.infinity,
      child: PostQuillEditor(
        controller: controller,
        focusNode: FocusNode(),
        readMode: true,
      ),
    );
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
    var colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onDoubleTap: () {},
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            width: double.infinity,
            child: Image.network(
              "https://pic1.zhimg.com/80/v2-64803cb7928272745eb2bb0203e03648_1440w.webp",
              fit: BoxFit.fill,
            ),
          ),
        ],
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
                    builder: (context) => PostCommentPage(
                      post: widget.post,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        Row(
          children: [
            //点赞
            IconButton(
              icon: const Icon(
                Icons.thumb_up_alt_outlined,
              ),
              color: colorScheme.onSurface,
              onPressed: () {},
            ),
            //收藏
            IconButton(
              icon: const Icon(
                Icons.bookmark_border,
                size: 27,
              ),
              color: colorScheme.onSurface,
              onPressed: () {},
            )
          ],
        )
      ],
    );
  }

  Widget buildDescribe() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.only(top: 5, bottom: 8),
      width: double.infinity,
      child: RichText(
        text: const TextSpan(
          style: TextStyle(color: Colors.green),
          children: [
            TextSpan(
              text: "路由器：",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: '这小娘子真好看',
            ),
          ],
        ),
      ),
    );
  }
}

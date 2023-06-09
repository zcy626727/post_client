import 'package:flutter/material.dart';
import 'package:post_client/model/comment.dart';

//评论或回复
class CommentCard extends StatelessWidget {
  const CommentCard({Key? key, required this.comment, this.onReply, this.onTap, this.onUp, this.onDown}) : super(key: key);

  final Comment comment;

  //回复内容
  final VoidCallback? onReply;
  final VoidCallback? onTap;
  final VoidCallback? onUp;
  final VoidCallback? onDown;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var isTop = comment.parentId == null || comment.parentId!<= 0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Material(
        color: colorScheme.surface,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //头像
            CircleAvatar(
              backgroundImage: NetworkImage(
                comment.user!.avatarUrl!,
              ),
              radius: 18,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 13),
                    height: 20,
                    child: Text(
                      comment.user!.name!,
                      style: TextStyle(color: colorScheme.onSurface.withAlpha(150), fontSize: 13),
                    ),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Container(
                      margin: const EdgeInsets.only(left: 13,bottom: 8),
                      width: double.infinity,
                      child: Text(
                        comment.text ?? "",
                        style: TextStyle(
                          fontSize: 15,
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        visualDensity: const VisualDensity(horizontal: -1, vertical: 0),
                        onPressed: onUp,
                        splashRadius: 20,
                        icon: Icon(
                          Icons.thumb_up_alt_outlined,
                          size: 20,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      IconButton(
                        visualDensity: const VisualDensity(horizontal: -1, vertical: 0),
                        onPressed: onDown,
                        splashRadius: 20,
                        icon: Icon(
                          Icons.thumb_down_alt_outlined,
                          size: 20,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      if (isTop)
                        IconButton(
                          visualDensity: const VisualDensity(horizontal: -1, vertical: 0),
                          onPressed: onReply,
                          splashRadius: 20,
                          icon: Icon(
                            Icons.comment,
                            size: 20,
                            color: colorScheme.onSurface,
                          ),
                        ),
                    ],
                  ),
                ],
              )
            ),
            //更多：举报、删除等
            IconButton(
              padding: EdgeInsets.zero,
              visualDensity: const VisualDensity(vertical: -4),
              onPressed: () {},
              icon: Icon(
                Icons.more_vert,
                color: colorScheme.onSurface,
              ),
              splashRadius: 16,
            )
          ],
        ),
      ),
    );
  }
}

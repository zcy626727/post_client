import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:post_client/config/global.dart';
import 'package:post_client/model/message/comment.dart';

import '../../../service/message/comment_service.dart';
import '../../widget/dialog/confirm_alert_dialog.dart';
import '../quill/quill_editor.dart';
import '../show/show_snack_bar.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({
    Key? key,
    required this.comment,
    this.onReply,
    this.onTap,
    this.onUp,
    this.onDown,
    this.isTop = false,
    required this.onDeleteComment, this.focusNode,
  }) : super(key: key);

  final Comment comment;
  final FocusNode? focusNode;
  final Function(Comment) onDeleteComment;

  //回复内容
  final VoidCallback? onReply;
  final VoidCallback? onTap;
  final VoidCallback? onUp;
  final VoidCallback? onDown;
  final bool isTop;

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  final QuillController controller = QuillController.basic();

  @override
  void initState() {
    super.initState();
    controller.document = Document.fromJson(json.decode(widget.comment.content ?? ""));
  }

  @override
  build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var isTop = widget.comment.parentId == null;

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
                widget.comment.user!.avatarUrl!,
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
                      widget.comment.user!.name!,
                      style: TextStyle(color: colorScheme.onSurface.withAlpha(150), fontSize: 13),
                    ),
                  ),
                  buildText(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        visualDensity: const VisualDensity(horizontal: -1, vertical: 0),
                        onPressed: widget.onUp,
                        splashRadius: 20,
                        icon: Icon(
                          Icons.thumb_up_alt_outlined,
                          size: 20,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      IconButton(
                        visualDensity: const VisualDensity(horizontal: -1, vertical: 0),
                        onPressed: widget.onDown,
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
                          onPressed: widget.onReply,
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
              ),
            ),
            //更多：举报、删除等
            PopupMenuButton<String>(
              itemBuilder: (BuildContext context) {
                return [
                  if (widget.comment.user!.id! == Global.user.id!)
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
              onOpened: (){
                if(widget.focusNode!=null){
                  widget.focusNode!.unfocus();
                }
              },
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
                              await CommentService.deleteComment(widget.comment.id!);
                              setState(() {});
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
                    widget.onDeleteComment(widget.comment);
                    break;
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget buildText() {
    return Container(
      margin: const EdgeInsets.only(left: 13),
      padding: const EdgeInsets.only(top: 2.0, right: 5.0),
      width: double.infinity,
      child: CommentQuillEditor(
        autoFocus: false,
        controller: controller,
        focusNode: FocusNode(),
        readOnly: true,
        onTap: widget.onTap,
      ),
    );
  }
}

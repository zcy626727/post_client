import 'package:flutter/material.dart';
import 'package:post_client/config/constants.dart';
import 'package:post_client/model/user/user.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({Key? key, required this.message, required this.isMe, required this.user}) : super(key: key);

  final String message;

  //为true则为右边
  final bool isMe;

  final User user;

  static const Radius _borderRadius = Radius.circular(15);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        //横向
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        //竖向
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) avatarBuild(user.avatarUrl ?? testImageUrl),
          Flexible(
            child: Container(
              margin: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.only(
                  bottomLeft: !isMe ? Radius.zero : _borderRadius,
                  bottomRight: isMe ? Radius.zero : _borderRadius,
                  topLeft: _borderRadius,
                  topRight: _borderRadius,
                ),
              ),
              child: Text(
                message,
                style: TextStyle(color: colorScheme.onPrimaryContainer),
              ),
            ),
          ),
          if (isMe) avatarBuild(user.avatarUrl ?? testImageUrl),
        ],
      ),
    );
  }

  Widget avatarBuild(String imageUrl) {
    return CircleAvatar(
      //头像半径
      radius: 20,
      backgroundImage: NetworkImage(imageUrl),
    );
  }
}

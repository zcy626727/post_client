import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({Key? key, required this.message, required this.isMe}) : super(key: key);

  final String message;

  //为true则为右边
  final bool isMe;

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
          if (!isMe) avatarBuild('assets/images/bai.png'),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isMe) Text("名字", style: TextStyle(color: colorScheme.primary, fontSize: 12)),
                  Text(
                    message,
                    style: TextStyle(color: colorScheme.onPrimaryContainer),
                  )
                ],
              ),
            ),
          ),
          if (isMe) avatarBuild('assets/images/hei.jpg'),
        ],
      ),
    );
  }

  Widget avatarBuild(String imageUrl) {
    return CircleAvatar(
      //头像半径
      radius: 20,
      backgroundImage: AssetImage(imageUrl),
    );
  }
}

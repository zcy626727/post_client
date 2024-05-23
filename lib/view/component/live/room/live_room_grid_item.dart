import 'package:flutter/material.dart';
import 'package:post_client/config/constants.dart';
import 'package:post_client/model/live/live_room.dart';

import '../../../page/live/room/live_room_page.dart';

class LiveRoomGridItem extends StatelessWidget {
  const LiveRoomGridItem({super.key, required this.liveRoom});

  final LiveRoom liveRoom;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: colorScheme.surface,
      ),
      child: TextButton(
          style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero), shape: commonButtonShape),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LiveRoomPage(liveRoom: LiveRoom.one())),
            );
          },
          child: Column(
            children: [
              //封面
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: colorScheme.primaryContainer,
                  child: Image(
                    image: NetworkImage(testImageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              //信息
              Container(
                height: 45,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  visualDensity: const VisualDensity(horizontal: -2, vertical: -4),
                  leading: CircleAvatar(radius: 14, backgroundImage: NetworkImage(testImageUrl)),
                  title: Text(
                    "直播间名",
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 12,
                    ),
                  ),
                  subtitle: Text("这是一个直播间", style: TextStyle(color: colorScheme.onSurface, fontSize: 10)),
                ),
              )
            ],
          )),
    );
  }
}

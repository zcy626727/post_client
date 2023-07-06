import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:post_client/model/audio.dart';
import 'package:post_client/view/component/media/detail/audio_detail_page.dart';

import '../../../config/global.dart';

class AudioListTile extends StatefulWidget {
  const AudioListTile({super.key, required this.audio});

  final Audio audio;

  @override
  State<AudioListTile> createState() => _AudioListTileState();
}

class _AudioListTileState extends State<AudioListTile> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      color: colorScheme.surface,
      // height: 100,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AudioDetailPage(audio: widget.audio);
              },
            ),
          );
        },
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
          leading: CircleAvatar(radius: 18, backgroundImage: NetworkImage(widget.audio.user!.avatarUrl!)),
          title: Text(
            widget.audio.title!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          subtitle: Text(
            widget.audio.introduction!,
            style: TextStyle(
              color: colorScheme.onSurface,
            ),
          ),
          trailing: PopupMenuButton<String>(
            padding: const EdgeInsets.only(left: 10),
            splashRadius: 1,
            icon: Icon(Icons.more_vert, color: colorScheme.onSurface),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                width: 1,
                color: colorScheme.onSurface.withAlpha(30),
                style: BorderStyle.solid,
              ),
            ),
            color: colorScheme.surface,
            itemBuilder: (BuildContext context) {
              return [
                if (widget.audio.user!.id! == Global.user.id!)
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
            onSelected: (value) async {
              switch (value) {
                case "delete":
                  break;
              }
            },
          ),
        ),
      ),
    );
  }
}

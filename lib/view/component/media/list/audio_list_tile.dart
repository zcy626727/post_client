import 'package:flutter/material.dart';
import 'package:post_client/view/page/audio/audio_detail_page.dart';

import '../../../../config/global.dart';
import '../../../../model/media/audio.dart';

class AudioListTile extends StatefulWidget {
  const AudioListTile({super.key, required this.audio, this.isInner = false, this.onDeleteMedia, this.onUpdateMedia});

  final Audio audio;
  final bool isInner;
  final Function(Audio)? onDeleteMedia;
  final Function(Audio)? onUpdateMedia;

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
                return AudioDetailPage(
                  audio: widget.audio,
                  onUpdateMedia: widget.onUpdateMedia,
                  onDeleteMedia: widget.onDeleteMedia,
                );
              },
            ),
          );
        },
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
          leading: widget.isInner
              ? Container(
                  margin: const EdgeInsets.only(left: 10),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Icon(
                    Icons.audiotrack_outlined,
                    color: colorScheme.onSurface,
                  ),
                )
              : CircleAvatar(radius: 18, backgroundImage: NetworkImage(widget.audio.coverUrl!)),
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
          trailing: widget.isInner
              ? null
              : PopupMenuButton<String>(
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
                      // if (widget.audio.user!.id! == Global.user.id!)
                      //   PopupMenuItem(
                      //     height: 35,
                      //     value: 'delete',
                      //     child: Text(
                      //       '删除',
                      //       style: TextStyle(color: colorScheme.onBackground.withAlpha(200), fontSize: 14),
                      //     ),
                      //   ),
                    ];
                  },
                  onSelected: (value) async {
                    // switch (value) {
                    //   case "delete":
                    //     break;
                    // }
                  },
                ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:post_client/model/post/album.dart';
import 'package:post_client/view/component/album/select_album_dialog.dart';

import '../../../domain/task/single_upload_task.dart';
import 'common_info_card.dart';

class MediaInfoCard extends StatefulWidget {
  const MediaInfoCard({
    super.key,
    required this.coverUploadImage,
    required this.titleController,
    required this.introductionController,
    this.onWithPost,
    required this.mediaType,
    this.onSelectedAlbum,
    this.initAlbum,
    this.onClearAlbum,
  });

  final SingleUploadTask coverUploadImage;
  final TextEditingController titleController;
  final TextEditingController introductionController;
  final int mediaType;
  final Function(bool)? onWithPost;
  final Function(Album)? onSelectedAlbum;
  final Function? onClearAlbum;
  final Album? initAlbum;

  @override
  State<MediaInfoCard> createState() => _MediaInfoCardState();
}

class _MediaInfoCardState extends State<MediaInfoCard> {
  bool _withPost = true;
  Album? _selectedAlbum;

  @override
  void initState() {
    super.initState();
    _selectedAlbum = widget.initAlbum;
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        CommonInfoCard(
          coverUploadImage: widget.coverUploadImage,
          titleController: widget.titleController,
          introductionController: widget.introductionController,
        ),
        if (widget.onWithPost != null)
          Container(
            color: colorScheme.surface,
            padding: const EdgeInsets.symmetric(horizontal: 1),
            margin: const EdgeInsets.only(top: 1, bottom: 1),
            child: ListTile(
              leading: Text(
                '同时发布动态',
                style: TextStyle(color: colorScheme.onSurface),
              ),
              trailing: Checkbox(
                fillColor: MaterialStateProperty.all(_withPost ? colorScheme.primary : colorScheme.onSurface),
                checkColor: colorScheme.onPrimary,
                value: _withPost,
                onChanged: (bool? value) {
                  setState(() {
                    _withPost = value!;
                    widget.onWithPost!(_withPost);
                  });
                },
              ),
            ),
          ),
        if (widget.onSelectedAlbum != null)
          Container(
            color: colorScheme.surface,
            height: 45,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 1),
            margin: const EdgeInsets.only(bottom: 1),
            child: TextButton(
                onPressed: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return SelectAlbumDialog(
                        onSelected: (album) async {
                          _selectedAlbum = album;
                          widget.onSelectedAlbum!(album);
                          setState(() {});
                        },
                        onClear: () {
                          _selectedAlbum = null;
                          if (widget.onClearAlbum != null) {
                            widget.onClearAlbum!();
                          }
                          setState(() {});
                        },
                        mediaType: widget.mediaType,

                      );
                    },
                  );
                },
                child: Text(_selectedAlbum == null ? "选择合集" : "${_selectedAlbum!.title}")),
          ),
      ],
    );
  }
}

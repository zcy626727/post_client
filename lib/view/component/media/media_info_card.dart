import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../domain/task/upload_media_task.dart';
import 'image_upload_card.dart';

class MediaInfoCard extends StatefulWidget {
  const MediaInfoCard({super.key, required this.coverUploadImage, required this.titleController, required this.introductionController, this.onRefresh});

  final UploadMediaTask coverUploadImage;
  final TextEditingController titleController;
  final TextEditingController introductionController;
  final Function? onRefresh;

  @override
  State<MediaInfoCard> createState() => _MediaInfoCardState();
}

class _MediaInfoCardState extends State<MediaInfoCard> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 1, top: 1),
          padding: const EdgeInsets.only(top: 15, bottom: 5, left: 5, right: 5),
          color: colorScheme.surface,
          height: 140,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: widget.titleController,
                  maxLines: 4,
                  maxLength: 50,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "标题不能为空";
                    }
                    return null;
                  },
                  style: TextStyle(
                    color: colorScheme.onSurface,
                  ),
                  strutStyle: const StrutStyle(fontSize: 16),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    //防止文本溢出时被白边覆盖
                    contentPadding: const EdgeInsets.only(left: 10.0, right: 2, bottom: 10, top: 10),
                    border: OutlineInputBorder(
                      //添加边框
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    labelText: "标题",
                    alignLabelWithHint: true,
                    errorStyle: const TextStyle(fontSize: 10),
                    counterStyle: TextStyle(color: colorScheme.onSurface),
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(left: 5, right: 5, bottom: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: colorScheme.background,
                  ),
                  height: 95,
                  width: 95,
                  child: widget.coverUploadImage.srcPath == null
                      ? IconButton(
                          onPressed: () async {
                            //打开file picker
                            FilePickerResult? result = await FilePicker.platform.pickFiles(
                              type: FileType.image,
                            );
                            if (result != null) {
                              RandomAccessFile? read;
                              try {
                                var file = result.files.single;
                                read = await File(result.files.single.path!).open();
                                var data = await read.read(16);
                                //消息接收器
                                widget.coverUploadImage.srcPath = file.path;
                                widget.coverUploadImage.totalSize = file.size;
                                widget.coverUploadImage.status = UploadTaskStatus.uploading.index;
                                widget.coverUploadImage.mediaType = MediaType.image;
                                widget.coverUploadImage.magicNumber = data;
                              } catch (e) {
                                widget.coverUploadImage.clear();
                              } finally {
                                read?.close();
                              }
                              setState(() {});
                            } else {
                              // User canceled the picker
                            }
                          },
                          icon: const Icon(Icons.upload),
                        )
                      : ImageUploadCard(key: ValueKey(widget.coverUploadImage.srcPath), task: widget.coverUploadImage)),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 1),
          padding: const EdgeInsets.only(top: 15, bottom: 5, left: 2, right: 2),
          color: colorScheme.surface,
          height: 150,
          child: TextFormField(
            controller: widget.introductionController,
            maxLines: 3,
            maxLength: 100,
            style: TextStyle(
              color: colorScheme.onSurface,
            ),
            strutStyle: const StrutStyle(fontSize: 21),
            decoration: InputDecoration(
              isCollapsed: true,
              //防止文本溢出时被白边覆盖
              contentPadding: const EdgeInsets.only(left: 10.0, right: 2, bottom: 10, top: 10),
              border: OutlineInputBorder(
                //添加边框
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: "简介",
              alignLabelWithHint: true,
              counterStyle: TextStyle(color: colorScheme.onSurface),
            ),
          ),
        ),
      ],
    );
  }
}

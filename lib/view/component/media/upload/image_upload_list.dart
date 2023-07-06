import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../../domain/task/upload_media_task.dart';
import '../../show/show_snack_bar.dart';
import 'image_upload_card.dart';

class ImageUploadList extends StatefulWidget {
  const ImageUploadList({super.key, required this.imageUploadTaskList, required this.maxUploadNum});

  final List<UploadMediaTask> imageUploadTaskList;
  final int maxUploadNum;

  @override
  State<ImageUploadList> createState() => _ImageUploadListState();
}

class _ImageUploadListState extends State<ImageUploadList> {
  final double imagePadding = 5.0;
  final double imageWidth = 100;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Container(
        height: imageWidth,
        width: double.infinity,
        margin: EdgeInsets.all(imagePadding),
        child: ListView.builder(
          itemCount: widget.imageUploadTaskList.length + 1,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          // physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            if (index >= widget.imageUploadTaskList.length) {
              return GestureDetector(
                onTap: () async {
                  if (index >= widget.maxUploadNum) {
                    ShowSnackBar.error(context: context, message: "图片最多上传${widget.maxUploadNum}个");
                    return;
                  }
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
                      var task =
                          UploadMediaTask.all(srcPath: file.path, totalSize: file.size, status: UploadTaskStatus.uploading.index, mediaType: MediaType.image, magicNumber: data);
                      widget.imageUploadTaskList.add(task);
                    } finally {
                      read?.close();
                    }
                    setState(() {});
                  } else {
                    // User canceled the picker
                  }
                },
                child: Container(
                  width: imageWidth,
                  height: imageWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: colorScheme.background,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: colorScheme.onBackground,
                    ),
                  ),
                ),
              );
            } else {
              return ImageUploadCard(key: ValueKey(widget.imageUploadTaskList[index].srcPath), task: widget.imageUploadTaskList[index],);
            }
          },
        ),
      ),
    );
  }
}

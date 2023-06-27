import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:post_client/config/media_config.dart';

import '../../../config/post_config.dart';
import '../../../domain/task/upload_media_task.dart';
import '../../component/media/image_upload_card.dart';
import '../../component/media/image_upload_list.dart';
import '../../component/show/show_snack_bar.dart';

class GalleryEditPage extends StatefulWidget {
  const GalleryEditPage({super.key});

  @override
  State<GalleryEditPage> createState() => _GalleryEditPageState();
}

class _GalleryEditPageState extends State<GalleryEditPage> {
  var imageUploadTaskList = <UploadMediaTask>[];
  final double imagePadding = 5.0;
  final double imageWidth = 100;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 50,
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        leading: IconButton(
          splashRadius: 20,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: colorScheme.onBackground,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 1),
              color: colorScheme.surface,
              child: ImageUploadList(imageUploadTaskList: imageUploadTaskList, maxUploadNum: MediaConfig.maxGalleryUploadImageNum),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              color: colorScheme.surface,
              height: 120,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: TextEditingController(),
                      maxLines: 3,
                      maxLength: 100,
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
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground.withAlpha(150),
                        ),
                        hintText: "标题",
                        counterStyle: TextStyle(color: colorScheme.onSurface),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      // image: DecorationImage(
                      //   image: FileImage(file),
                      //   fit: BoxFit.cover,
                      // ),
                      color: colorScheme.background,
                    ),
                    height: 92,
                    width: 92,
                    child: const Icon(Icons.upload),
                  ),
                ],
              ),
            ),
            // Container(
            //   color: colorScheme.surface,
            //   child: Column(
            //     children: [
            //       ListTile(
            //         title: Text("权限",style: TextStyle(color: colorScheme.onSurface,fontSize: 15),),
            //         trailing: SizedBox(
            //           width: 100,
            //           child: Row(
            //             children: [
            //               Checkbox(value: false, onChanged: (b){}),
            //               Checkbox(value: true, onChanged: (b){}),
            //             ],
            //           ),
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
              color: colorScheme.surface,
              height: 120,
              child: TextField(
                controller: TextEditingController(),
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
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground.withAlpha(150),
                  ),
                  hintText: "简介",
                  counterStyle: TextStyle(color: colorScheme.onSurface),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

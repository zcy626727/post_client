import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widget/player/common_video_player.dart';

class VideoEditPage extends StatefulWidget {
  const VideoEditPage({super.key});

  @override
  State<VideoEditPage> createState() => _VideoEditPageState();
}

class _VideoEditPageState extends State<VideoEditPage> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
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
              margin: const EdgeInsets.only(top: 2),
              padding: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 5.0),
              height: 200,
              color: colorScheme.surface,
              child: const CommonVideoPlayer(videoUrl: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              color: colorScheme.surface,
              height: 120,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: TextEditingController(),
                      maxLines: 4,
                      maxLength: 50,
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
                  labelText: "简介",
                  alignLabelWithHint: true,
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

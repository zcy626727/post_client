import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        child: Column(
          children: [Text("data")],
        ),
      ),
    );
  }
}

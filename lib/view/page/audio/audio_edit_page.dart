import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioEditPage extends StatefulWidget {
  const AudioEditPage({super.key});

  @override
  State<AudioEditPage> createState() => _AudioEditPageState();
}

class _AudioEditPageState extends State<AudioEditPage> {
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
          children: [
            Text("上传进度"),
            Row(
              children: [
                Text("标题"),
                Text("  封面"),
              ],
            ),
            Text("选项1"),
            Text("选项2"),
          ],
        ),
      ),
    );
  }
}

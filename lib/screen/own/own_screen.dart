import 'package:flutter/material.dart';

class OwnScreen extends StatefulWidget {
  const OwnScreen({super.key});

  @override
  State<OwnScreen> createState() => _OwnScreenState();
}

class _OwnScreenState extends State<OwnScreen> {
  @override
  Widget build(BuildContext context) {
    return Text("历史记录、收藏、稍后再看、创作中心");
  }
}

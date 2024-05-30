import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:post_client/model/message/live_category.dart';
import 'package:post_client/model/message/live_room.dart';
import 'package:post_client/model/message/live_topic.dart';
import 'package:post_client/service/message/live_category_service.dart';
import 'package:post_client/service/message/live_room_service.dart';
import 'package:post_client/service/message/live_topic_service.dart';
import 'package:post_client/view/component/show/show_snack_bar.dart';

import '../../../widget/button/common_action_two_button.dart';
import '../../../widget/input_text_field.dart';

class RoomInfoDialog extends StatefulWidget {
  const RoomInfoDialog({Key? key, required this.liveRoom, required this.onSaved}) : super(key: key);
  final LiveRoom? liveRoom;
  final Function(LiveRoom)? onSaved;

  @override
  State<RoomInfoDialog> createState() => _RoomInfoDialogState();
}

class _RoomInfoDialogState extends State<RoomInfoDialog> {
  late Future _futureBuilderFuture;
  final _textController = TextEditingController();
  var topicList = <LiveTopic>[];
  var categoryList = <LiveCategory>[];

  LiveCategory? _currentCategory;
  LiveTopic? _currentTopic;

  Future getData() async {
    return Future.wait([loadTopicList(), loadCategoryList()]);
  }

  Future<void> loadTopicList() async {
    try {
      // 获取全部主题
      topicList = await LiveTopicService.getLiveTopicList();
      // 设置房间的主题和分类
      if (widget.liveRoom?.categoryId == null) return;
      // 获取该房间的分类的主题
      var (category, topic) = await LiveCategoryService.getCategoryWithTopic(categoryId: widget.liveRoom!.categoryId!);
      for (var t in topicList) {
        if (t.id == topic.id) {
          _currentTopic = t;
          break;
        }
      }
      categoryList = await LiveCategoryService.getCategoryListByTopic(topicId: topic.id!);
      for (var c in categoryList) {
        if (c.id == category.id) {
          _currentCategory = c;
          break;
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> loadCategoryList() async {
    try {} catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    _futureBuilderFuture = getData();
    super.initState();
    if (widget.liveRoom != null) {
      _textController.text = widget.liveRoom!.name ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          return _buildDialog();
        } else {
          // 请求未结束，显示loading
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildDialog() {
    var colorScheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
        child: AlertDialog(
      contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20, bottom: 10),
      backgroundColor: colorScheme.surface,
      titlePadding: const EdgeInsets.only(top: 15.0, left: 10.0),
      title: Text("直播间信息", style: TextStyle(color: colorScheme.onSurface)),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SizedBox(
            width: 250,
            // height: 220,
            child: Column(
              children: [
                // 名字
                InputTextField(
                  controller: _textController,
                  title: "房间名",
                  enable: true,
                  maxLength: 50,
                  showCounter: false,
                ),
                // 主题下拉框
                DropdownMenu<LiveTopic>(
                  width: 260,
                  label: Text("主题", style: TextStyle(color: colorScheme.onSurface)),
                  onSelected: _onSelectTopic,
                  initialSelection: _currentTopic,
                  dropdownMenuEntries: topicList.map((LiveTopic topic) {
                    return DropdownMenuEntry<LiveTopic>(value: topic, label: topic.name ?? "未知");
                  }).toList(),
                ),
                const SizedBox(height: 8),
                // 类别下拉框，主题选择后才能选
                DropdownMenu<LiveCategory>(
                  width: 260,
                  label: Text("类别", style: TextStyle(color: colorScheme.onSurface)),
                  onSelected: _onSelectCategory,
                  initialSelection: _currentCategory,
                  dropdownMenuEntries: categoryList.map((LiveCategory category) {
                    return DropdownMenuEntry<LiveCategory>(value: category, label: category.name ?? "未知");
                  }).toList(),
                )
              ],
            ),
          );
        },
      ),
      actions: [
        CommonActionTwoButton(
          rightTitle: "确定",
          leftTitle: "取消",
          rightTextColor: colorScheme.onPrimary,
          backgroundRightColor: colorScheme.primary,
          onRightTap: () {
            _onSaveRoomInfo();
          },
          onLeftTap: () {
            Navigator.pop(context);
          },
        )
      ],
    ));
  }

  void _onSelectTopic(LiveTopic? topic) async {
    try {
      if (topic?.id != null) {
        categoryList = await LiveCategoryService.getCategoryListByTopic(topicId: topic!.id!);
        setState(() {});
      }
    } catch (e) {}
  }

  void _onSelectCategory(LiveCategory? category) {
    _currentCategory = category;
  }

  void _onSaveRoomInfo() async {
    try {
      if (_currentCategory?.id == null) throw Exception("未选择类别");
      if (_textController.text.isEmpty) throw Exception("房间名为空");
      var newRoom = await LiveRoomService.saveRoom(categoryId: _currentCategory!.id!, name: _textController.text);
      if (widget.onSaved != null) widget.onSaved!(newRoom);
      if (mounted) Navigator.pop(context);
    } on Exception catch (e) {
      if (mounted) ShowSnackBar.exception(context: context, e: e);
    }
  }
}

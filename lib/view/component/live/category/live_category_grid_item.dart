import 'package:flutter/material.dart';
import 'package:post_client/config/constants.dart';
import 'package:post_client/model/live/live_category.dart';
import 'package:post_client/view/page/live/room/live_room_list_of_category_page.dart';

class LiveCategoryGridItem extends StatelessWidget {
  const LiveCategoryGridItem({super.key, required this.category});

  final LiveCategory category;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return TextButton(
      style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero), shape: commonButtonShape),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LiveRoomListOfCategoryPage(category: category)),
        );
      },
      child: Column(
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: Image(image: NetworkImage(testImageUrl)),
          ),
          Text("英雄联盟", style: TextStyle(fontSize: 10, color: colorScheme.onSurface))
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //头像
          CircleAvatar(
            backgroundImage: NetworkImage(
              "https://pic1.zhimg.com/80/v2-64803cb7928272745eb2bb0203e03648_1440w.webp",
            ),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 20,
                    child: Text("你滴名字",style: TextStyle(color: colorScheme.onSurface.withAlpha(150)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "为什么我",
                      style:  TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          IconButton(onPressed: (){}, icon: Icon(
              Icons.favorite,
              size: 20,
              color: colorScheme.onSurface,
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CommonHeaderBar extends StatelessWidget {
  const CommonHeaderBar({Key? key, required this.title, this.trailing})
      : super(key: key);

  final String title;

  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      height: 40,
      //分割线
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        width: 1,
        color: colorScheme.outline.withAlpha(20),
      ))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (trailing != null) trailing!
        ],
      ),
    );
  }
}

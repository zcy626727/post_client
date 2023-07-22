import 'package:flutter/material.dart';

class FeedFeedbackButton extends StatelessWidget {
  const FeedFeedbackButton({
    super.key,
    required this.iconData,
    this.iconSize,
    required this.text,
    this.fontSize,
    this.selected = false,
    this.onPressed,
  });

  final IconData iconData;
  final double? iconSize;
  final String text;
  final double? fontSize;
  final bool selected;
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      child: TextButton(
        onPressed: () {
          if (onPressed != null) {
            onPressed!();
          }
        },
        style: const ButtonStyle(
          visualDensity: VisualDensity.compact,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              iconData,
              color: selected ? Colors.red : colorScheme.onSurface,
              size: iconSize,
            ),
            const SizedBox(width: 5),
            Text(
              text,
              style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.w300, fontSize: fontSize),
            ),
          ],
        ),
      ),
    );
  }
}

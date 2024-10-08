import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../config/constants.dart';

class CommonActionOneButton extends StatefulWidget {
  const CommonActionOneButton({
    Key? key,
    this.onTap,
    this.title = "取消",
    this.backgroundColor,
    this.textColor,
    this.height = 40,
    this.radius = 10,
  }) : super(key: key);

  //返回值代表是否调用pop
  final Function? onTap;

  final String title;

  final Color? backgroundColor;
  final Color? textColor;
  final double radius;

  //高度
  final double height;

  @override
  State<CommonActionOneButton> createState() => _CommonActionOneButtonState();
}

class _CommonActionOneButtonState extends State<CommonActionOneButton> {
  bool _leftLoading = false;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: TextButton(
        style: ButtonStyle(
          shape: commonButtonShape,
          backgroundColor: widget.backgroundColor == null ? null : MaterialStateProperty.all(widget.backgroundColor!),
        ),
        onPressed: _leftLoading
            ? null
            : () async {
                if (widget.onTap == null) {
                  return;
                }
                setState(() {
                  _leftLoading = true;
                });
                var isPop = await widget.onTap!();

                if (isPop == true) {
                  if (mounted) Navigator.pop(context);
                }

                setState(() {
                  _leftLoading = false;
                });
              },
        child: _leftLoading ? CupertinoActivityIndicator(color: widget.textColor ?? colorScheme.onPrimary) : Text(widget.title, style: TextStyle(color: widget.textColor)),
      ),
    );
  }
}

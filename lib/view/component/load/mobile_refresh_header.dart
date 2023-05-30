import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class MobileRefreshHeader extends StatelessWidget {
  const MobileRefreshHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return WaterDropHeader(
      refresh: CupertinoActivityIndicator(
        color: colorScheme.onSurface,
      ),
      complete: Text("刷新成功", style: TextStyle(color: colorScheme.onSurface)),
      failed: Text("刷新失败", style: TextStyle(color: colorScheme.onSurface)),
    );
  }
}

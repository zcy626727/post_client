import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class MobileRefreshFooter extends StatelessWidget {
  const MobileRefreshFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return ClassicFooter(
      loadStyle: LoadStyle.ShowWhenLoading,
      textStyle: TextStyle(color: colorScheme.onSurface),
      idleText: "查看更多",
      failedText: "加载失败",
      canLoadingText: "松开加载",
      loadingText: "加载中",
      loadingIcon: CupertinoActivityIndicator(
        color: colorScheme.onSurface,
      ),
      noDataText: "到底了",
    );
  }
}

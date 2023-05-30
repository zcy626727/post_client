import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../config/constants.dart';
import '../../config/global.dart';
import '../../state/user_state.dart';

class LightDarkSwitch extends StatefulWidget {
  const LightDarkSwitch({Key? key, required this.isLarge, required this.width}) : super(key: key);
  final bool isLarge;
  final double width;

  @override
  State<LightDarkSwitch> createState() => _LightDarkSwitchState();
}

class _LightDarkSwitchState extends State<LightDarkSwitch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      margin: const EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.isLarge)
            Icon(Icons.light_mode,
                color: Theme.of(context).colorScheme.onBackground),
          Selector<UserState, UserState>(
            selector: (context, userState) => userState,
            //模式不同则重新构建
            shouldRebuild: (pre, next) =>
            pre.currentBrightness != next.currentBrightness,
            builder: (ctx, userState, child) {
              Brightness currentBrightness = userState.currentBrightness;
              return Flexible(
                child: Switch(
                  splashRadius: 3,
                  value: currentBrightness == Brightness.dark,
                  onChanged: (value) {
                    if (value) {
                      //变为暗模式
                      userState.currentBrightness = Brightness.dark;
                      SystemChrome.setSystemUIOverlayStyle(systemUILight);
                    } else {
                      userState.currentBrightness = Brightness.light;
                      SystemChrome.setSystemUIOverlayStyle(systemUIDark);
                    }
                    //保存到sqlite
                    Global.userProvider.update(userState.user);
                  },
                ),
              );
            },
          ),
          if (widget.isLarge)
            Icon(
              Icons.dark_mode,
              color: Theme.of(context).colorScheme.onBackground,
            ),
        ],
      ),
    );
  }
}


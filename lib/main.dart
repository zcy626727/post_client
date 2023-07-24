import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:post_client/state/screen_state.dart';
import 'package:post_client/state/user_state.dart';
import 'package:post_client/theme/color_schemes.g.dart';
import 'package:post_client/view/main_screen.dart';
import 'package:post_client/view/page/account/sign_in_or_up_page.dart';
import 'package:provider/provider.dart';

import 'config/global.dart';

void main() {
  //初始化全局变量后启动项目
  Global.init().then((e) => runApp(MultiProvider(
          //声明全局状态信息
          providers: [
            //用户状态
            ChangeNotifierProvider(create: (ctx) => UserState()),
            ChangeNotifierProvider(create: (ctx) => ScreenNavigatorState()),
          ],
          child: const MyApp())));
}

//初始化app：读取数据
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future _futureBuilderFuture;

  @override
  void initState() {
    _futureBuilderFuture = init(context);
    super.initState();
  }

  Future<String?> init(BuildContext context) async {
    String? message = await Global.openDBAndInitData();

    return message;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          //有错误信息
          if (snapShot.hasData) {
            log("错误信息：${snapShot.data.toString()}");
          }
          return Selector<UserState, ThemeMode>(
            selector: (context, userState) => userState.currentMode,
            //主题改变时才需要更新所有ui
            //只是用户信息改变了的话只需要更改用户信息相关的ui
            shouldRebuild: (pre, next) => pre != next,
            builder: (context, currentThemeMode, child) {
              log("更新全局ui");
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: "file",
                //正常模式主题
                theme: Theme.of(context).copyWith(
                  brightness: Brightness.light,
                  colorScheme: lightColorScheme,
                ),
                //暗模式主题
                darkTheme: Theme.of(context).copyWith(
                  brightness: Brightness.light,
                  colorScheme: darkColorScheme,
                ),
                routes: {
                  "login": (context) => const SignInOrUpPage(),
                },
                //全局状态获取主题模式
                themeMode: currentThemeMode,
                //国际化
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('zh', 'CH'),
                  Locale('en', 'US'),
                ],
                locale: const Locale('zh'),
                home: const MainScreen(),
              );
            },
          );
        } else {
          // 请求未结束，显示loading
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    Global.close();
    super.dispose();
  }
}

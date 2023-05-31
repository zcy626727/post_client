import 'package:flutter/cupertino.dart';

//界面状态
class ScreenNavigatorState extends ChangeNotifier {
  //桌面索引
  int _firstNav = FirstNav.home;

  int get firstNavIndex {
    return _firstNav;
  }

  set firstNavIndex(int firstNav) {
    _firstNav = firstNav;
    notifyListeners();
  }
}

class FirstNav {
  static const int home = 0;
  static const int follow = 1;
  static const int notice = 3;
  static const int media = 4;
  static const int account = 5;
}

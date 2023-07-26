import 'package:flutter/foundation.dart';

import '../../api/client/user/user_api.dart';
import '../../api/client/user_http_config.dart';
import '../../config/global.dart';
import '../../model/user/user.dart';

class UserService {
  static Future<User> signIn(String phoneNumber, String password) async {
    //查询当前id的用户在本机是否有数据
    User user = await UserApi.signIn(phoneNumber, password);
    //最新登录时间
    user.lastLoginTime = DateTime.now();
    user.phoneNumber = phoneNumber;
    if (kIsWeb) {
    } else {
      //插入或更新到数据库
      await Global.userProvider.insertOrUpdate(user);
    }
    return user;
  }

  static Future<User> signInByToken(String phoneNumber) async {
    var user = await UserApi.signInByToken(phoneNumber);
    //最新登录时间
    user.lastLoginTime = DateTime.now();
    if (kIsWeb) {
    } else {
      //插入或更新到数据库
      await Global.userProvider.insertOrUpdate(user);
    }

    return user;
  }

  static Future<User> signUp(String phoneNumber, String password, String name) async {
    var user = await UserApi.signUp(phoneNumber, password, name);
    //最新登录时间
    user.lastLoginTime = DateTime.now();
    //这里返回user用于让回显到用户登录文本中
    return user;
  }

  static Future<void> signOut() async {
    User oldUser = Global.user;
    User user = User(
      id: oldUser.id,
      phoneNumber: oldUser.phoneNumber,
      lastLoginTime: oldUser.lastLoginTime,
      token: null,
      avatarUrl: oldUser.avatarUrl,
      name: oldUser.name,
      themeMode: oldUser.themeMode,
    );
    await Global.userProvider.update(user);
  }

  static copyFromUser(User user, User target) {
    target.phoneNumber = user.phoneNumber;
    target.id = user.id;
    target.avatarUrl = user.avatarUrl;
    target.name = user.name;
    target.token = user.token;
  }

  static Future<void> updateUsername(String newUsername) async {
    await UserApi.updateUsername(newUsername);
  }

  static Future<void> updateAvatarUrl(String? avatarUrl) async {
    if (avatarUrl == null) return;
    await UserApi.updateAvatarUrl(avatarUrl);
  }

  static Future<void> updatePassword(
    String newPassword,
    String oldPassword,
  ) async {
    await UserApi.updatePassword(newPassword, oldPassword);
  }
}

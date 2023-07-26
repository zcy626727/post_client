import '../../../model/user/user.dart';
import '../user_http_config.dart';

class UserApi {
  static Future<User> signIn(String phoneNumber, String password) async {
    var r = await UserHttpConfig.dio.post(
      "/user/signIn",
      data: {
        "phoneNumber": phoneNumber,
        "password": password,
      },
      options: UserHttpConfig.options.copyWith(extra: {"noCache": true}),
    );

    //获取数据
    User user = User.fromJson(r.data["user"]);
    user.token = r.data["token"];
    return user;
  }

  static Future<User> signInByToken(String phoneNumber) async {
    var r = await UserHttpConfig.dio.post(
      "/user/signInByToken",
      data: {
        "phoneNumber": phoneNumber,
      },
      options: UserHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    //获取数据
    User user = User.fromJson(r.data["user"]);
    user.token = r.data["token"] ?? "";
    return user;
  }

  static Future<User> signUp(String phoneNumber, String password, String name) async {
    var r = await UserHttpConfig.dio.post(
      "/user/signUp",
      data: {
        "phoneNumber": phoneNumber,
        "password": password,
        "name": name,
      },
      options: UserHttpConfig.options.copyWith(extra: {"noCache": true}),
    );

    //获取数据
    User user = User.fromJson(r.data["user"]);
    user.token = r.data["token"] ?? "";
    return user;
  }

  static Future<void> updateUsername(String newUsername) async {
    var r = await UserHttpConfig.dio.post(
      "/user/updateUsername",
      data: {
        "newUsername": newUsername,
      },
      options: UserHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<void> updatePassword(
    String newPassword,
    String oldPassword,
  ) async {
    var r = await UserHttpConfig.dio.post(
      "/user/updatePassword",
      data: {
        "newPassword": newPassword,
        "oldPassword": oldPassword,
      },
      options: UserHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<void> updateAvatarUrl(String avatarUrl) async {
    var r = await UserHttpConfig.dio.post(
      "/user/updateAvatarUrl",
      data: {
        "avatarUrl": avatarUrl,
      },
      options: UserHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }
}

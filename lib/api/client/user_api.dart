
import 'package:dio/dio.dart';

import '../../../config/global.dart';
import '../../../model/user.dart';
import '../../config/net_config.dart';

class UserHttpConfig {

  //当前接口的选项
  static Options options = Options();

  static Dio dio = Dio(BaseOptions(
    baseUrl: NetConfig.userApiUrl,
  ));

  static void init() {
    // 添加拦截器
    dio.interceptors.add(Global.netCacheInterceptor);
    dio.interceptors.add(Global.netCommonInterceptor);
  }
}

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

  static Future<User> signUp(
      String phoneNumber, String password, String name) async {
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
}

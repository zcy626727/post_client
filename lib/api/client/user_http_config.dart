
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



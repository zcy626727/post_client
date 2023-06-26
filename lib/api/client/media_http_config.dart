import 'package:dio/dio.dart';
import 'package:post_client/domain/multipart_info.dart';

import '../../config/global.dart';
import '../../config/net_config.dart';

class MediaHttpConfig {
  static Options options = Options();

  static Dio dio = Dio(BaseOptions(
    baseUrl: NetConfig.mediaApiUrl,
  ));

  static void init() {
    // 添加拦截器
    dio.interceptors.add(Global.netCacheInterceptor);
    dio.interceptors.add(Global.netCommonInterceptor);
  }
}





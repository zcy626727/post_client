import 'package:dio/dio.dart';
import 'package:post_client/model/comment.dart';
import 'package:post_client/model/post.dart';
import 'package:post_client/model/user.dart';

import '../../config/global.dart';
import '../../config/net_config.dart';

class MessageHttpConfig {
  static Options options = Options();

  static Dio dio = Dio(BaseOptions(
    baseUrl: NetConfig.messageApiUrl,
  ));

  static void init() {
    // 添加拦截器
    dio.interceptors.add(Global.netCacheInterceptor);
    dio.interceptors.add(Global.netCommonInterceptor);
  }
}




class NetConfig{
  NetConfig({this.enable = false, this.maxAge = 3600,this.maxCount = 100});

  //是否开启缓存
  bool enable;
  //最大过期时间
  int maxAge;
  //最大连接数
  int maxCount;

  //用户服务
  static String userApiUrl = 'http://192.168.43.233:26101';

  static String postApiUrl = 'http://192.168.43.233:26111';

  static String mediaApiUrl = 'http://192.168.43.233:26121';

}

class NetConfig {
  NetConfig({this.enable = false, this.maxAge = 3600, this.maxCount = 100});

  //是否开启缓存
  bool enable;

  //最大过期时间Xxian
  int maxAge;

  //最大连接数
  int maxCount;

  //用户服务
  static String userApiUrl = 'http://192.168.200.148:26101';

  static String messageApiUrl = 'http://192.168.200.148:26121';
  static String liveChatUrl = 'ws://192.168.200.148:26121/chat/liveRoom';
  static String liveKitUrl = 'ws://192.168.200.148:7880';
  static String userChatUrl = 'ws://192.168.200.148:26121/chat/user';

  static String postApiUrl = 'http://192.168.200.148:26111';
}

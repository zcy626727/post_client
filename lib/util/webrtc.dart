import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

// 确保rtc
Future<void> enableRTC({required Function onEnable, required Function onError}) async {
  bool enable = false;
  // 屏幕录制需要，允许前台服务，安卓屏幕录制使用
  if (WebRTC.platformIsAndroid) {
    enable = await startForegroundService();
  } else {
    enable = true;
  }
  if (enable) {
    onEnable();
  } else {
    onError();
  }
}

Future<bool> startForegroundService() async {
  const androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: 'Title of the notification',
    notificationText: 'Text of the notification',
    notificationImportance: AndroidNotificationImportance.Default,
    notificationIcon: AndroidResource(name: 'background_icon', defType: 'drawable'), // Default is ic_launcher from folder mipmap
  );
  bool b = await FlutterBackground.initialize(androidConfig: androidConfig);
  if (!b) return false;
  return FlutterBackground.enableBackgroundExecution();
}

class LiveMediaMode {
  static const int screenShare = 1;
  static const int frontFacingCamera = 2;
  static const int backFacingCamera = 3;

  static Map<String, dynamic> getMediaConstraints({bool enableMic = true, required int liveMediaMode}) {
    switch (liveMediaMode) {
      case screenShare:
        return {
          'audio': enableMic ? true : false,
          'video': true,
        };
      case frontFacingCamera:
        return {
          'audio': enableMic ? true : false,
          'video': {"facingMode": "user"},
        };
      case backFacingCamera:
        return {
          'audio': enableMic ? true : false,
          'video': {"facingMode": "environment"}
        };
      default:
        return {
          'audio': enableMic ? true : false,
          'video': true,
        };
    }
  }
}

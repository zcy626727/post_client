import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:post_client/view/widget/button/common_action_one_button.dart';

import '../../../../constant/live.dart';

class CreateLivePage extends StatefulWidget {
  const CreateLivePage({super.key});

  @override
  State<CreateLivePage> createState() => _CreateLivePageState();
}

class _CreateLivePageState extends State<CreateLivePage> {
  // 共享屏幕，否则摄像头
  int liveMediaMode = LiveMediaMode.backFacingCamera;

  // 横屏或竖屏
  bool started = false;

  // facingMode
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();

  @override
  void initState() {
    super.initState();
    initRenderers();
    localLocalVideo();
  }

  initRenderers() async {
    await _localRenderer.initialize();
  }

  @override
  deactivate() {
    super.deactivate();
    print('调用dispose');
    _localRenderer.srcObject?.dispose();
    _localRenderer.dispose();
  }

  // 本地数据
  Future<void> localLocalVideo() async {
    MediaStream stream;
    if (liveMediaMode == LiveMediaMode.screenShare) {
      //获取屏幕共享
      stream = await navigator.mediaDevices.getDisplayMedia(LiveMediaMode.getMediaConstraints(liveMediaMode: liveMediaMode));
    } else {
      //获取摄像头
      stream = await navigator.mediaDevices.getUserMedia(LiveMediaMode.getMediaConstraints(liveMediaMode: liveMediaMode));
    }
    _localRenderer.srcObject?.dispose();
    _localRenderer.srcObject = stream;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            RTCVideoView(
              _localRenderer,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            ),
            if (!started)
              Positioned(
                bottom: 80,
                left: 50,
                right: 50,
                child: Container(
                  child: CommonActionOneButton(
                    backgroundColor: colorScheme.primaryContainer,
                    title: '开启直播',
                    onTap: () {
                      setState(() {
                        started = true;
                      });
                    },
                  ),
                ),
              ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 50,
                color: colorScheme.primaryContainer,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (!started)
                      IconButton(
                        tooltip: "离开",
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(colorScheme.primaryContainer)),
                        icon: const Icon(Icons.exit_to_app),
                        iconSize: 30,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    if (started)
                      IconButton(
                        tooltip: "关闭直播",
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(colorScheme.primaryContainer)),
                        icon: const Icon(Icons.stop_circle),
                        iconSize: 30,
                        onPressed: () {
                          setState(() {
                            started = false;
                          });
                        },
                      ),
                    //翻转屏幕
                    if (liveMediaMode != LiveMediaMode.screenShare)
                      IconButton(
                        tooltip: "翻转摄像头",
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(colorScheme.primaryContainer)),
                        icon: const Icon(Icons.cameraswitch),
                        iconSize: 30,
                        onPressed: () {
                          switch (liveMediaMode) {
                            case LiveMediaMode.frontFacingCamera:
                              liveMediaMode = LiveMediaMode.backFacingCamera;
                            case LiveMediaMode.backFacingCamera:
                              liveMediaMode = LiveMediaMode.frontFacingCamera;
                          }
                          localLocalVideo();
                        },
                      ),
                    //屏幕分享
                    if (liveMediaMode != LiveMediaMode.screenShare)
                      IconButton(
                        tooltip: "分享屏幕",
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(colorScheme.primaryContainer)),
                        icon: const Icon(Icons.screen_share),
                        iconSize: 30,
                        onPressed: () {
                          liveMediaMode = LiveMediaMode.screenShare;
                          localLocalVideo();
                        },
                      ),
                    if (liveMediaMode == LiveMediaMode.screenShare)
                      IconButton(
                        tooltip: "摄像头",
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(colorScheme.primaryContainer)),
                        icon: const Icon(Icons.camera),
                        iconSize: 30,
                        onPressed: () {
                          liveMediaMode = LiveMediaMode.frontFacingCamera;
                          localLocalVideo();
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:post_client/util/time.dart';

class CommonAudioPlayerMini2 extends StatefulWidget {
  const CommonAudioPlayerMini2({Key? key, required this.audioUrl})
      : super(key: key);

  final String audioUrl;

  @override
  State<CommonAudioPlayerMini2> createState() => _CommonAudioPlayerMini2State();
}

class _CommonAudioPlayerMini2State extends State<CommonAudioPlayerMini2> {
  bool _isPlaying = false;

  // final player = AudioPlayer();
  final player = AudioPlayer();
  // final url =
  //     'http://59.110.45.28/m/api/url/yqb/id/26ced8UIbqRJ_nmX6xO0BZuDeKU6O9CXDeh-dGFaJ86SQ98/format/320kmp3';
  // final file = 'sounds/111.mp3';
  Duration? _duration;
  Duration? _position;
  PlayerState _playerState = PlayerState.stopped;

  @override
  void initState() {
    super.initState();
    player.setSourceUrl(widget.audioUrl);
    player.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    player.onPositionChanged.listen((p) {
      setState(() {
        _position = p;
      });
    });

    player.onPlayerComplete.listen((event) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration.zero;
        _isPlaying = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      elevation: 0,
      color: colorScheme.secondaryContainer,
      child: Container(
        padding: const EdgeInsets.only(left: 5.0),
        height: 60,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 5.0),
              child: IconButton(
                color: colorScheme.onSecondaryContainer,
                splashRadius: 10,
                onPressed: () {
                  setState(() {
                    if (_isPlaying) {
                      _isPlaying = false;
                      player.pause();
                    } else {
                      _isPlaying = true;
                      player.resume();
                    }
                  });
                },
                icon: Icon(_isPlaying ? Icons.pause_circle : Icons.play_circle,
                    size: 35),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    height: 20,
                    child: Slider(
                      min: 0.0,
                      max: _duration != null ? _duration!.inSeconds * 1.0 : 0.0,
                      value:
                      _position != null ? _position!.inSeconds * 1.0 : 0.0,
                      onChanged: (double v) {
                        player.seek(Duration(seconds: v.floor()));
                      },
                      onChangeStart: (double v) {},
                      onChangeEnd: (double v) {},
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 23.0, right: 23.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_position != null
                            ? DateTimeUtil.durationTimeFormat(_position!)
                            : DateTimeUtil.durationZeroTimeFormat(false)),
                        Text(_duration != null
                            ? DateTimeUtil.durationTimeFormat(_duration!)
                            : DateTimeUtil.durationZeroTimeFormat(false)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

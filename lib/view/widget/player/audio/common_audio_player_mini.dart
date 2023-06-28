import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'audio_manager.dart';
import 'notifiers/play_button_notifier.dart';
import 'notifiers/progress_notifier.dart';

class CommonAudioPlayerMini extends StatefulWidget {
  const CommonAudioPlayerMini({Key? key, required this.audioUrl}) : super(key: key);

  final String audioUrl;

  @override
  State<CommonAudioPlayerMini> createState() => _CommonAudioPlayerMiniState();
}

class _CommonAudioPlayerMiniState extends State<CommonAudioPlayerMini> {
  final _pageManager = AudioManager();

  @override
  void initState() {
    // _pageManager.addSong(widget.audioUrl);
    _pageManager.setInitialPlaylist(<String>[widget.audioUrl]);
    super.initState();
  }

  @override
  void dispose() {
    _pageManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      padding: const EdgeInsets.only(left: 5.0),
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            child: ValueListenableBuilder<ButtonState>(
              valueListenable: _pageManager.playButtonNotifier,
              builder: (_, value, __) {
                switch (value) {
                  case ButtonState.loading:
                    return const Center(
                      child: SizedBox(
                        width: 25.0,
                        height: 25.0,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  case ButtonState.paused:
                    return IconButton(
                      icon: const Icon(Icons.play_arrow),
                      splashRadius: 10,
                      iconSize: 32.0,
                      onPressed: _pageManager.play,
                    );
                  case ButtonState.playing:
                    return IconButton(
                      icon: const Icon(Icons.pause),
                      splashRadius: 10,
                      iconSize: 32.0,
                      onPressed: _pageManager.pause,
                    );
                }
              },
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 5,right: 10.0,top: 10),
              child: ValueListenableBuilder<ProgressBarState>(
                valueListenable: _pageManager.progressNotifier,
                builder: (_, value, __) {
                  return ProgressBar(
                    progress: value.current,
                    buffered: value.buffered,
                    total: value.total,
                    onSeek: _pageManager.seek,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


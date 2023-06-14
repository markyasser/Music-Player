import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Controls extends StatelessWidget {
  final AudioPlayer? audioPlayer;
  final String? url;
  const Controls({super.key, this.audioPlayer, this.url});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: audioPlayer!.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;
        if (!(playing ?? false)) {
          return IconButton(
            onPressed: () {
              audioPlayer!.setUrl(url!);
              audioPlayer!.play();
            },
            color: Colors.white,
            icon: const Icon(Icons.play_arrow),
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
          );
        } else if (processingState != ProcessingState.completed) {
          return IconButton(
            onPressed: () => audioPlayer!.pause(),
            color: Colors.white,
            icon: const Icon(Icons.pause),
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
          );
        }
        return Container();
      },
    );
  }
}

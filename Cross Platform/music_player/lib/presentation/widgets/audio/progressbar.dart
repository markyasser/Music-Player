import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/presentation/widgets/audio/controller.dart';
import 'package:music_player/presentation/widgets/home.dart';

class ProgressBarWidget extends StatelessWidget {
  // final MusicModel music;
  final Stream<PositionData> positionDataStream;
  final AudioPlayer audioPlayer;
  const ProgressBarWidget({
    super.key,
    required this.positionDataStream,
    required this.audioPlayer,
    // required this.music
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      width: double.infinity,
      height: 80,
      child: Column(
        children: [
          Controls(audioPlayer: audioPlayer),
          SizedBox(
            width: 500,
            child: StreamBuilder<PositionData>(
                stream: positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  return ProgressBar(
                      barHeight: 8,
                      baseBarColor: Colors.grey[600],
                      bufferedBarColor: Colors.grey,
                      progressBarColor: Colors.white,
                      thumbColor: Colors.white,
                      timeLabelTextStyle: const TextStyle(color: Colors.white),
                      progress: positionData?.position ?? Duration.zero,
                      total: positionData?.duration ?? Duration.zero,
                      buffered: positionData?.bufferedPosition ?? Duration.zero,
                      onSeek: (value) => audioPlayer.seek(value));
                }),
          ),
        ],
      ),
    );
  }
}

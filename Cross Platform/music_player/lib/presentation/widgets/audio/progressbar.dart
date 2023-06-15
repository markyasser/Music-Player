import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/business_logic/music/play_pause_cubit.dart';
import 'package:music_player/data/model/music_model.dart';
import 'package:music_player/presentation/widgets/audio/controller.dart';
import 'package:music_player/presentation/widgets/home.dart';

class ProgressBarWidget extends StatelessWidget {
  final Stream<PositionData> positionDataStream;
  final AudioPlayer audioPlayer;
  const ProgressBarWidget({
    super.key,
    required this.positionDataStream,
    required this.audioPlayer,
  });

  Widget progressBar(MusicModel music) {
    return Container(
      color: Colors.black,
      width: double.infinity,
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder<SequenceState?>(
              stream: audioPlayer.sequenceStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                if (state?.sequence.isEmpty ?? true) return const SizedBox();
                final metadata = state!.currentSource!.tag as MediaItem;
                return ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    metadata.artUri.toString(),
                    width: 50,
                    height: 50,
                  ),
                );
              }),
          const SizedBox(width: 15),
          Column(
            children: [
              Controls(audioPlayer: audioPlayer, music: music),
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
                          timeLabelTextStyle:
                              const TextStyle(color: Colors.white),
                          progress: positionData?.position ?? Duration.zero,
                          total: positionData?.duration ?? Duration.zero,
                          buffered:
                              positionData?.bufferedPosition ?? Duration.zero,
                          onSeek: (value) => audioPlayer.seek(value));
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayPauseCubit, PlayPauseState>(
      builder: (context, state) {
        if (state is MusicPlaying) {
          return progressBar(state.musicPlaying);
        }
        return Container();
      },
    );
  }
}

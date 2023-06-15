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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StreamBuilder<SequenceState?>(
              stream: audioPlayer.sequenceStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                if (state?.sequence.isEmpty ?? true) return const SizedBox();
                final metadata = state!.currentSource!.tag as MediaItem;
                return Row(
                  children: [
                    const SizedBox(width: 25),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        metadata.artUri.toString(),
                        width: 50,
                        height: 50,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 14),
                        Text(metadata.title,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        Text(metadata.artist!,
                            style: const TextStyle(
                                fontSize: 13, color: Colors.grey))
                      ],
                    )
                  ],
                );
              }),
          Row(
            children: [
              Column(
                children: [
                  Controls(audioPlayer: audioPlayer, music: music),
                  SizedBox(
                    width: 400,
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
                              buffered: positionData?.bufferedPosition ??
                                  Duration.zero,
                              onSeek: (value) => audioPlayer.seek(value));
                        }),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.volume_up, color: Colors.white))
            ],
          ),
          const SizedBox(width: 140),
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

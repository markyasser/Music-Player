import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/business_logic/music/play_pause_cubit.dart';
import 'package:music_player/data/model/music_model.dart';

class Controls extends StatelessWidget {
  final AudioPlayer? audioPlayer;
  final MusicModel? music;
  const Controls({super.key, this.audioPlayer, this.music});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            audioPlayer!.seekToPrevious();
            audioPlayer!.play();
            // BlocProvider.of<PlayPauseCubit>(context).setMusicInstance(music!);
          },
          color: Colors.white,
          icon: const Icon(Icons.skip_previous_rounded),
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        StreamBuilder<PlayerState>(
          stream: audioPlayer!.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (!(playing ?? false)) {
              return IconButton(
                onPressed: () {
                  BlocProvider.of<PlayPauseCubit>(context)
                      .setMusicInstance(music!);
                  // audioPlayer!.setUrl(music!.musicUrl!);
                  audioPlayer!.play();
                },
                color: Colors.white,
                icon: const Icon(Icons.play_arrow_rounded),
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                onPressed: () => audioPlayer!.pause(),
                color: Colors.white,
                icon: const Icon(Icons.pause_rounded),
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
              );
            }
            return Container();
          },
        ),
        IconButton(
          onPressed: () {
            audioPlayer!.seekToNext();
            audioPlayer!.play();
            // BlocProvider.of<PlayPauseCubit>(context).setMusicInstance(music!);
          },
          color: Colors.white,
          icon: const Icon(Icons.skip_next_rounded),
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
      ],
    );
  }
}

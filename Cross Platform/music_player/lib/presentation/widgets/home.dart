import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/business_logic/music/music_cubit.dart';
import 'package:music_player/business_logic/music/play_pause_cubit.dart';
import 'package:music_player/data/model/music_model.dart';
import 'package:music_player/presentation/widgets/audio/controller.dart';
import 'package:music_player/presentation/widgets/audio/progressbar.dart';
import 'package:rxdart/rxdart.dart';

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
  PositionData(
      {required this.position,
      required this.bufferedPosition,
      required this.duration});
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late AudioPlayer _audioPlayer;
  bool isPLaying = false;
  String currentPLayingUrl = "";
  Duration pausedDuration = Duration.zero;
  MusicModel? currentPLaying;

  late ConcatenatingAudioSource playlist;

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _audioPlayer.positionStream,
          _audioPlayer.bufferedPositionStream,
          _audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position: position,
              bufferedPosition: bufferedPosition,
              duration: duration ?? Duration.zero));

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MusicCubit>(context).getPosts();
    _audioPlayer = AudioPlayer();
    // _init();
  }

  Future<void> _init() async {
    await _audioPlayer.setAudioSource(playlist);
    await _audioPlayer.setLoopMode(LoopMode.all);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void like() {}

  Widget card(MusicModel item) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  item.imageUrl!,
                  width: 120,
                  height: 120,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.musicTitle!,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 7),
                  Text("${item.likes!} likes"),
                  const SizedBox(height: 20),
                  IconButton(
                    onPressed: () => like(),
                    icon: Icon(Icons.favorite,
                        color: item.isLiked! ? Colors.red : Colors.black),
                  ),
                  const SizedBox(height: 5),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget musicCardInstance(music) {
    return StreamBuilder<PlayerState>(
      stream: _audioPlayer.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;
        if (!(playing ?? false)) {
          return InkWell(
              onTap: () {
                BlocProvider.of<PlayPauseCubit>(context)
                    .setMusicInstance(music!);
                _audioPlayer.play();
              },
              child: card(music));
        } else if (processingState != ProcessingState.completed) {
          return InkWell(onTap: () => _audioPlayer.pause(), child: card(music));
        }
        return Container();
      },
    );
  }

  Widget homeBody() {
    return BlocBuilder<MusicCubit, MusicState>(
      builder: (context, state) {
        if (state is MusicLoaded) {
          playlist = ConcatenatingAudioSource(
              children: state.musicList.map((item) {
            return AudioSource.uri(Uri.parse(item.musicUrl!),
                tag: MediaItem(
                    id: item.id!,
                    title: item.musicTitle!,
                    artist: 'Mark',
                    artUri: Uri.parse(item.imageUrl!)));
          }).toList());
          _init();
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    children: state.musicList
                        .map((item) => musicCardInstance(item))
                        .toList(),
                  ),
                ),
              ),
              ProgressBarWidget(
                  positionDataStream: _positionDataStream,
                  audioPlayer: _audioPlayer),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return homeBody();
  }
}

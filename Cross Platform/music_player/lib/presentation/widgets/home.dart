import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/business_logic/music/music_cubit.dart';
import 'package:music_player/business_logic/music/play_pause_cubit.dart';
import 'package:music_player/data/model/music_model.dart';
import 'package:music_player/presentation/widgets/audio/progressbar.dart';
import 'package:music_player/presentation/widgets/left_navbar.dart';
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

  void like(postId) {
    BlocProvider.of<MusicCubit>(context).like(postId);
  }

  Widget card(MusicModel item) {
    return SizedBox(
      height: 115,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    item.imageUrl!,
                    width: 88,
                    height: 88,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 10),
                    Text(item.musicTitle!,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    // const SizedBox(height: 5),
                    Text(item.musicSinger!,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                    // const SizedBox(height: 7),
                    Text("${item.likes!} likes"),
                    // const SizedBox(height: 5),
                    IconButton(
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      splashRadius: 0.1,
                      onPressed: () => like(item.id!),
                      icon: Icon(Icons.favorite,
                          color: item.isLiked! ? Colors.red : Colors.black,
                          size: 20),
                    ),
                    const SizedBox(height: 5),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget musicCardInstance(music, index) {
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
                _audioPlayer.seek(Duration.zero, index: index);
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
          int i = -1;
          if (state.musicList.isNotEmpty) {
            playlist = ConcatenatingAudioSource(
                children: state.musicList.map((item) {
              return AudioSource.uri(Uri.parse(item.musicUrl!),
                  tag: MediaItem(
                      id: i.toString(),
                      title: item.musicTitle!,
                      artist: item.musicSinger!,
                      artUri: Uri.parse(item.imageUrl!)));
            }).toList());

            _init();
          }
          i = 0;
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Row(
                children: [
                  const Expanded(flex: 1, child: LeftNavBar()),
                  state.musicList.isNotEmpty
                      ? Expanded(
                          flex: 10,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: SingleChildScrollView(
                              child: Column(
                                children: state.musicList.map((item) {
                                  return musicCardInstance(item, i++);
                                }).toList(),
                              ),
                            ),
                          ))
                      : const Expanded(
                          flex: 10,
                          child: Center(
                              child: Text('Liked Music List is Empty',
                                  style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold)))),
                ],
              ),
              ProgressBarWidget(
                  positionDataStream: _positionDataStream,
                  audioPlayer: _audioPlayer),
            ],
          );
        } else if (state is LikeSuccess) {
          int i = -1;
          if (state.musicList.isNotEmpty) {
            playlist = ConcatenatingAudioSource(
                children: state.musicList.map((item) {
              i++;
              return AudioSource.uri(Uri.parse(item.musicUrl!),
                  tag: MediaItem(
                      id: i.toString(),
                      title: item.musicTitle!,
                      artist: 'Mark',
                      artUri: Uri.parse(item.imageUrl!)));
            }).toList());

            _init();
          }
          i = 0;
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Row(
                children: [
                  const Expanded(flex: 1, child: LeftNavBar()),
                  state.musicList.isNotEmpty
                      ? Expanded(
                          flex: 10,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: SingleChildScrollView(
                              child: Column(
                                children: state.musicList
                                    .map((item) => musicCardInstance(item, i++))
                                    .toList(),
                              ),
                            ),
                          ),
                        )
                      : const Expanded(
                          flex: 10,
                          child: Center(
                              child: Text('Liked Music List is Empty',
                                  style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold)))),
                ],
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

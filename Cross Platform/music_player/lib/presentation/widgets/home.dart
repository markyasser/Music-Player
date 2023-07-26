import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/business_logic/music/music_cubit.dart';
import 'package:music_player/business_logic/music/play_pause_cubit.dart';
import 'package:music_player/data/model/music_model.dart';
import 'package:music_player/data/model/user_model.dart';
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
  List<MusicModel> currmusicList = [];
  List<dynamic> playlists = [];
  String _selectedPlaylist = '';
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
    _selectedPlaylist = UserData.user!.playlists!.first['name'];
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

  void delete(postId) {
    BlocProvider.of<MusicCubit>(context).delete(postId);
  }

  void _showDeleteDialog(BuildContext context, String postId, String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Music'),
          content: Text('Are you sure you want to delete $name?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              // red color
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                delete(postId);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showAddToPlaylistDialog(
      BuildContext context, String postId, String name) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(' Add Music to Playlist'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return DropdownButtonFormField<String>(
                value: _selectedPlaylist,
                items: UserData.user!.playlists!.map((playlist) {
                  return DropdownMenuItem<String>(
                    value: playlist['name'],
                    child: Text(playlist['name'],
                        style: const TextStyle(fontSize: 15)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPlaylist = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Select Playlist',
                  border: OutlineInputBorder(),
                ),
                itemHeight: 50,
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              // red color
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                // delete(postId);
                BlocProvider.of<MusicCubit>(context)
                    .addToPlayList(_selectedPlaylist, postId);
                setState(() {});
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        item.imageUrl!,
                        width: 88,
                        height: 88,
                        fit: BoxFit.cover,
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
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
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
                Column(
                  children: [
                    UserData.user!.userId == item.creatorId
                        ? IconButton(
                            onPressed: () => _showDeleteDialog(
                                context, item.id!, item.musicTitle!),
                            splashRadius: 2,
                            icon: const Icon(Icons.delete_outline))
                        : Container(),
                    IconButton(
                        onPressed: () => _showAddToPlaylistDialog(
                            context, item.id!, item.musicTitle!),
                        splashRadius: 2,
                        icon: const Icon(Icons.playlist_add))
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

  Widget content() {
    int i = -1;
    if (currmusicList.isNotEmpty) {
      playlist = ConcatenatingAudioSource(
          children: currmusicList.map((item) {
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
            currmusicList.isNotEmpty
                ? Expanded(
                    flex: 10,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: SingleChildScrollView(
                        child: Column(
                          children: currmusicList.map((item) {
                            return musicCardInstance(item, i++);
                          }).toList(),
                        ),
                      ),
                    ))
                : const Expanded(
                    flex: 10,
                    child: Center(
                        child: Text('Music List is Empty',
                            style: TextStyle(
                                fontSize: 23, fontWeight: FontWeight.bold)))),
          ],
        ),
        ProgressBarWidget(
            positionDataStream: _positionDataStream, audioPlayer: _audioPlayer),
      ],
    );
  }

  Widget playlistContent() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Row(
          children: [
            const Expanded(flex: 1, child: LeftNavBar()),
            playlists.isNotEmpty
                ? Expanded(
                    flex: 10,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: SingleChildScrollView(
                        child: Column(
                          children: playlists.map((item) {
                            return InkWell(
                              onTap: () {
                                BlocProvider.of<MusicCubit>(context)
                                    .getPlaylistMusic(item['id']);
                              },
                              child: SizedBox(
                                height: 115,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 7, vertical: 3),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: Container(
                                                  color: Colors.black12,
                                                  width: 96,
                                                  height: 96,
                                                  child: const Icon(
                                                      Icons.music_note_sharp,
                                                      color: Colors.black26,
                                                      size: 84),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 10),
                                                  Text(item['name']),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                      '${item['number']} songs',
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey)),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ))
                : const Expanded(
                    flex: 10,
                    child: Center(
                        child: Text('Playlist is Empty',
                            style: TextStyle(
                                fontSize: 23, fontWeight: FontWeight.bold)))),
          ],
        ),
        ProgressBarWidget(
            positionDataStream: _positionDataStream, audioPlayer: _audioPlayer),
      ],
    );
  }

  Widget homeBody() {
    return BlocBuilder<MusicCubit, MusicState>(
      builder: (context, state) {
        if (state is MusicLoaded) {
          currmusicList = state.musicList;
          return content();
        } else if (state is LikeSuccess) {
          currmusicList = state.musicList;
          return content();
        } else if (state is UploadLoading || state is UploadFailed) {
          currmusicList = [];
          return content();
        } else if (state is PlaylistSuccess) {
          playlists = state.playlists;
          return playlistContent();
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

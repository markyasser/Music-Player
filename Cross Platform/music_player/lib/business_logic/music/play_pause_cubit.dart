import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:music_player/data/model/music_model.dart';

part 'play_pause_state.dart';

class PlayPauseCubit extends Cubit<PlayPauseState> {
  PlayPauseCubit() : super(PlayPauseInitial());
  MusicModel? musicPlaying;
  void setMusicInstance(MusicModel musicModel) {
    musicPlaying = musicModel;
    emit(MusicPlaying(musicPlaying!));
  }

  void getMusicInstance() {
    if (musicPlaying != null) {
      emit(MusicNotPlaying());
    } else {
      emit(MusicPlaying(musicPlaying!));
    }
  }
}

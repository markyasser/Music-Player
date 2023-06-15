part of 'play_pause_cubit.dart';

@immutable
abstract class PlayPauseState {}

class PlayPauseInitial extends PlayPauseState {}

class MusicNotPlaying extends PlayPauseState {}

class MusicPlaying extends PlayPauseState {
  final MusicModel musicPlaying;
  MusicPlaying(this.musicPlaying);
}

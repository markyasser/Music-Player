part of 'music_cubit.dart';

@immutable
abstract class MusicState {}

class MusicInitial extends MusicState {}

class MusicLoading extends MusicState {}

class MusicLoaded extends MusicState {
  final List<MusicModel> musicList;
  MusicLoaded(this.musicList);
}

class MusicFaild extends MusicState {}

class LikeSuccess extends MusicState {
  final List<MusicModel> musicList;
  LikeSuccess(this.musicList);
}

class LikeFailed extends MusicState {}

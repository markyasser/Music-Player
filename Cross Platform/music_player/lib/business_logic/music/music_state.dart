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

// upload states
class UploadSuccess extends MusicState {}

class UploadLoading extends MusicState {}

class UploadFailed extends MusicState {
  final String errorMessage;
  UploadFailed(this.errorMessage);
}

// delete states
class DeleteFailed extends MusicState {}

class DeleteLoading extends MusicState {}

class DeleteSuccess extends MusicState {
  final List<MusicModel> musicList;
  DeleteSuccess(this.musicList);
}

// playlsit state
class PlaylistFaild extends MusicState {}

class PlaylistLoading extends MusicState {}

class PlaylistSuccess extends MusicState {
  final List<dynamic> playlists;
  PlaylistSuccess(this.playlists);
}

// add to playlist state
class AddToPlaylistFailed extends MusicState {}

class AddToPlaylistLoading extends MusicState {}

class AddToPlaylistSuccess extends MusicState {}

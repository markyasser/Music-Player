import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:music_player/data/model/music_model.dart';
import 'package:music_player/data/repository/music_repo.dart';
part 'music_state.dart';

class MusicCubit extends Cubit<MusicState> {
  final MusicRepository musicRepo;
  MusicCubit(this.musicRepo) : super(MusicInitial());

  void getPosts() async {
    if (isClosed) return;
    emit(MusicLoading());
    musicRepo.getPosts().then((value) {
      if (value != null) {
        emit(MusicLoaded(value));
      } else {
        emit(MusicFaild());
      }
    });
  }

  void getLikedPosts() async {
    if (isClosed) return;
    emit(MusicLoading());
    musicRepo.getLikedPosts().then((value) {
      if (value != null) {
        emit(MusicLoaded(value));
      } else {
        emit(MusicFaild());
      }
    });
  }

  void getPlaylistMusic(String playlistId) async {
    if (isClosed) return;
    emit(MusicLoading());
    musicRepo.getPlaylistMusic(playlistId).then((value) {
      if (value != null) {
        emit(MusicLoaded(value));
      } else {
        emit(MusicFaild());
      }
    });
  }

  void getPlaylist() async {
    if (isClosed) return;
    emit(PlaylistLoading());
    musicRepo.getPlaylist().then((value) {
      if (value != null) {
        emit(PlaylistSuccess(value));
      } else {
        emit(PlaylistFaild());
      }
    });
  }

  void like(String postId) async {
    if (isClosed) return;
    musicRepo.like(postId).then((value) {
      if (value != null) {
        emit(LikeSuccess(value));
      } else {
        emit(LikeFailed());
      }
    });
  }

  void addToPlayList(String playlistName, String musicId) async {
    if (isClosed) return;
    emit(AddToPlaylistLoading());
    musicRepo.addToPlayList(playlistName, musicId).then((value) {
      if (value != null) {
        emit(AddToPlaylistSuccess());
      } else {
        emit(AddToPlaylistFailed());
      }
    });
  }

  void delete(String postId) async {
    if (isClosed) return;
    emit(DeleteLoading());
    musicRepo.delete(postId).then((value) {
      if (value != null) {
        emit(MusicLoaded(value));
      } else {
        emit(DeleteFailed());
      }
    });
  }

  void upload(
      String title, String creator, Uint8List? img, Uint8List? audio) async {
    if (isClosed) return;
    emit(UploadLoading());
    if (title == '') {
      emit(UploadFailed('Title is required'));
      return;
    }
    if (creator == '') {
      emit(UploadFailed('Creator is required'));
      return;
    }
    if (img == null) {
      emit(UploadFailed('Image is required'));
      return;
    }
    if (audio == null) {
      emit(UploadFailed('Audio File is required'));
      return;
    }
    musicRepo.upload(title, creator, img, audio).then((value) {
      if (value == 'success') {
        emit(UploadSuccess());
      } else {
        emit(UploadFailed(value));
      }
    });
  }
}

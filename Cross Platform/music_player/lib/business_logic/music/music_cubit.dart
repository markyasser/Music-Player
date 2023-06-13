import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
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
}

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:music_player/data/repository/auth_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepo;
  AuthCubit(this.authRepo) : super(AuthInitial());

  void signup(String password, String username, String phonenumber,
      String email, String collegeId, String img) async {
    if (isClosed) return;
    emit(SignUpLoading());
    authRepo.signup(password, username, email).then((value) {
      if (value == 'success') {
        emit(SignUpSuccessfully());
      } else {
        emit(SignUpFailed(value!));
      }
    });
  }

  void login(String username, String password) async {
    if (isClosed) return;
    emit(LoginLoading());
    authRepo.login(password, username).then((value) {
      if (value == 'success') {
        emit(LoginSuccessfully());
      } else {
        emit(LoginFailed(value!));
      }
    });
  }

  void getUser(token) async {
    if (isClosed) return;
    emit(LoginLoading());
    authRepo.getUser(token).then((value) {
      if (value == 'success') {
        emit(LoginSuccessfully());
      } else {
        emit(LoginFailed(value!));
      }
    });
  }
}

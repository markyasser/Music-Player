import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:music_player/data/model/user_model.dart';
import 'package:music_player/data/repository/auth_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepo;
  AuthCubit(this.authRepo) : super(AuthInitial());

  void signup(String password, String username, String email) async {
    if (isClosed) return;
    emit(SignUpLoading());
    // print('test');
    authRepo.signup(password, username, email).then((value) {
      if (value!['status'] == 'pending') {
        emit(SignUpSuccessfully(value['data']['userId']));
      } else {
        emit(SignUpFailed(value['message']));
      }
    });
  }

  void verifyOTP(String userId, String otp) async {
    if (isClosed) return;
    emit(VerifyOTPLoading());
    // print('test');
    authRepo.verifyOTP(userId, otp).then((value) {
      if (value == 'success') {
        emit(VerifyOTPSuccessfully());
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

  void logout() {
    if (isClosed) return;
    emit(LogoutLoading());
    UserData.user = null;
    UserData.isLoggedIn = false;
    SharedPreferences.getInstance()
        .then((value) => value.setString('token', ''))
        .then((value) => emit(LogoutSuccessfully()));
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

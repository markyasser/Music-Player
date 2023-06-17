part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class SignUpFailed extends AuthState {
  final String errorMessage;
  SignUpFailed(this.errorMessage);
}

class SignUpSuccessfully extends AuthState {
  SignUpSuccessfully();
}

class SignUpLoading extends AuthState {
  SignUpLoading();
}

class LoginFailed extends AuthState {
  final String errorMessage;
  LoginFailed(this.errorMessage);
}

class LoginSuccessfully extends AuthState {}

class LoginLoading extends AuthState {}

class LogoutSuccessfully extends AuthState {}

class LogoutLoading extends AuthState {}

class GetUserFailed extends AuthState {
  final String errorMessage;
  GetUserFailed(this.errorMessage);
}

class GetUserSuccessfully extends AuthState {
  GetUserSuccessfully();
}

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

class LoginFailed extends AuthState {
  final String errorMessage;
  LoginFailed(this.errorMessage);
}

class LoginSuccessfully extends AuthState {
  LoginSuccessfully();
}

class LoginLoading extends AuthState {
  LoginLoading();
}

class SignUpLoading extends AuthState {
  SignUpLoading();
}

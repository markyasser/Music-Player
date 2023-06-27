part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class SignUpFailed extends AuthState {
  final String errorMessage;
  SignUpFailed(this.errorMessage);
}

class SignUpSuccessfully extends AuthState {
  final String id;
  final String email;
  SignUpSuccessfully(this.id, this.email);
}

class SignUpLoading extends AuthState {}

class VerifyOTPSuccessfully extends AuthState {}

class VerifyOTPLoading extends AuthState {}

class VerifyOTPFailed extends AuthState {
  final String errorMessage;
  VerifyOTPFailed(this.errorMessage);
}

class ResendOTPSuccessfully extends AuthState {}

class ResendOTPLoading extends AuthState {}

class ResendOTPFailed extends AuthState {
  final String errorMessage;
  ResendOTPFailed(this.errorMessage);
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

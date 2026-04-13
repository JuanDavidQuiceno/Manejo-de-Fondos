part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthInitialEvent extends AuthEvent {}

class AuthChangeEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

class AuthValidateEvent extends AuthEvent {
  const AuthValidateEvent();
}

class AuthLoginEvent extends AuthEvent {
  const AuthLoginEvent({this.model});
  final UserModel? model;
}

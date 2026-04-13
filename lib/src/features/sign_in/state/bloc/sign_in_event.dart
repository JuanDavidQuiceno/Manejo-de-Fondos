part of 'sign_in_bloc.dart';

sealed class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

final class SignInInitializeEvent extends SignInEvent {
  const SignInInitializeEvent();
}

final class SignInEmailChangedEvent extends SignInEvent {
  const SignInEmailChangedEvent({required this.email});
  final String email;

  @override
  List<Object> get props => [email];
}

final class SignInPasswordChangedEvent extends SignInEvent {
  const SignInPasswordChangedEvent({required this.password});
  final String password;

  @override
  List<Object> get props => [password];
}

final class SignInRememberMeChangedEvent extends SignInEvent {
  const SignInRememberMeChangedEvent({required this.rememberMe});
  final bool rememberMe;

  @override
  List<Object> get props => [rememberMe];
}

final class SignInRequestedEvent extends SignInEvent {}

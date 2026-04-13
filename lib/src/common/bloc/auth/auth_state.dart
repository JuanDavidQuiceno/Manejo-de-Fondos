part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState({required this.authStatus, required this.user});
  final UserModel user;
  final AuthStatus authStatus;

  @override
  List<Object> get props => [authStatus];
}

class AuthInitial extends AuthState {
  const AuthInitial({required super.authStatus, required super.user});
}

class AuthInitialState extends AuthState {
  const AuthInitialState({required super.authStatus, required super.user});
}

class AuthLoadingState extends AuthState {
  const AuthLoadingState({required super.authStatus, required super.user});
}

class AuthNotificatedChangeState extends AuthState {
  const AuthNotificatedChangeState({
    required super.authStatus,
    required super.user,
  });
}

class AuthAccountValidateState extends AuthState {
  const AuthAccountValidateState({
    required super.authStatus,
    required super.user,
  });
}

final class AuthUserUpdateState extends AuthState {
  const AuthUserUpdateState({required super.authStatus, required super.user});
  @override
  List<Object> get props => [user];
}

final class AuthProfileUpdateState extends AuthState {
  const AuthProfileUpdateState({
    required super.authStatus,
    required super.user,
  });

  @override
  List<Object> get props => [user];
}

class AuthCompleteProfileState extends AuthState {
  const AuthCompleteProfileState({
    required super.authStatus,
    required super.user,
  });
}

class AuthCheckingState extends AuthState {
  const AuthCheckingState({required super.authStatus, required super.user});
}

class AuthenticatedState extends AuthState {
  const AuthenticatedState({required super.authStatus, required super.user});
}

class AuthNoAuthenticatedState extends AuthState {
  const AuthNoAuthenticatedState({
    required super.authStatus,
    required super.user,
    this.message,
  });
  final String? message;
}

class AuthMessageState extends AuthState {
  const AuthMessageState({
    required this.title,
    required super.authStatus,
    required super.user,
    this.image,
    this.subTitle,
  });
  final String? image;
  final String title;
  final String? subTitle;
}

class AuthFinishWithError extends AuthState {
  const AuthFinishWithError({
    required super.authStatus,
    required super.user,
    this.image,
    this.title,
    this.content,
    this.textButton,
    // this.type,
  });
  final String? image;
  final String? title;
  final String? content;
  // final AlertType? type;
  final String? textButton;

  // @override
  // List<Object> get props => [title, message];
}

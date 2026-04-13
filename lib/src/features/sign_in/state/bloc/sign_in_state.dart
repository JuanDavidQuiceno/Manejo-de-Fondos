part of 'sign_in_bloc.dart';

sealed class SignInState extends Equatable {
  const SignInState({required this.model});
  final LoginModel model;

  @override
  List<Object> get props => [];
}

final class SignInInitial extends SignInState {
  const SignInInitial({required super.model});
}

final class SignInInitialState extends SignInState {
  const SignInInitialState({required super.model});
}

final class SignInInitializeState extends SignInState {
  const SignInInitializeState({required super.model});
}

final class SignInChangeState extends SignInState {
  const SignInChangeState({required super.model});
}

final class SignInLoadingState extends SignInState {
  const SignInLoadingState({required super.model});
}

final class SignInSuccessState extends SignInState {
  const SignInSuccessState({
    required super.model,
    required this.userModel,
    // required this.navigationRoute,
    // this.metadata = const {},
  });
  final UserModel userModel;
  // final String navigationRoute;
  // final Map<String, dynamic>? metadata;
}

final class SignInFailureState extends SignInState {
  const SignInFailureState({required super.model, required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}

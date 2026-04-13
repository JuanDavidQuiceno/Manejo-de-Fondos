import 'dart:async';

import 'package:dashboard/src/common/models/user/user_model.dart';
import 'package:dashboard/src/core/config/secure_storage_services.dart';
import 'package:dashboard/src/core/config/storage_service.dart';
import 'package:dashboard/src/core/utils/mixin/form_validation_mixin.dart';
import 'package:dashboard/src/features/sign_in/domain/models/signin_model.dart';
import 'package:dashboard/src/features/sign_in/domain/repository/signin_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState>
    with FormValidationMixin {
  SignInBloc({
    required SignInRepository signInRepository,
    required StorageService localStorage,
  }) : _signInRepository = signInRepository,
       _localStorage = localStorage,
       super(SignInInitial(model: LoginModel())) {
    on<SignInInitializeEvent>(_initializeLocalStorage);
    on<SignInEmailChangedEvent>(_onSignInEmailChangedEvent);
    on<SignInPasswordChangedEvent>(_onSignInPasswordChangedEvent);
    on<SignInRememberMeChangedEvent>(_onSignInRememberMeChangedEvent);
    on<SignInRequestedEvent>(_onSignInRequestedEvent);
  }
  final SignInRepository _signInRepository;
  final StorageService _localStorage;

  // inicializacion de localStoreage
  FutureOr<void> _initializeLocalStorage(
    SignInInitializeEvent event,
    Emitter<SignInState> emit,
  ) async {
    final email = await _localStorage.read(
      SecureStorageKeys.rememberedEmail.key,
    );
    final pass = await _localStorage.read(
      SecureStorageKeys.rememberedPassword.key,
    );

    if (email != null && pass != null) {
      emit(
        SignInInitializeState(
          model: state.model.copyWith(
            email: email,
            password: pass,
            rememberMe: true,
          ),
        ),
      );
    }

    return;
  }

  FutureOr<void> _onSignInEmailChangedEvent(
    SignInEmailChangedEvent event,
    Emitter<SignInState> emit,
  ) {
    emit(SignInInitialState(model: state.model.copyWith(email: event.email)));
    emit(SignInChangeState(model: state.model));
  }

  FutureOr<void> _onSignInPasswordChangedEvent(
    SignInPasswordChangedEvent event,
    Emitter<SignInState> emit,
  ) {
    emit(
      SignInInitialState(model: state.model.copyWith(password: event.password)),
    );
    emit(SignInChangeState(model: state.model));
  }

  FutureOr<void> _onSignInRememberMeChangedEvent(
    SignInRememberMeChangedEvent event,
    Emitter<SignInState> emit,
  ) {
    emit(
      SignInInitialState(
        model: state.model.copyWith(rememberMe: event.rememberMe),
      ),
    );
    if (!event.rememberMe) {
      deleteSavedCredentials();
    }
    emit(SignInChangeState(model: state.model));
  }

  FutureOr<void> _onSignInRequestedEvent(
    SignInRequestedEvent event,
    Emitter<SignInState> emit,
  ) async {
    emit(SignInLoadingState(model: state.model));
    try {
      final response = await _signInRepository.signIn(state.model);
      // guardar credenciales si rememberMe esta activo
      if (state.model.rememberMe) {
        await saveCredentials(
          email: state.model.email,
          password: state.model.password,
        );
      }

      emit(SignInSuccessState(model: state.model, userModel: response));
    } on Object catch (e) {
      emit(SignInFailureState(model: state.model, message: e.toString()));
    }
  }

  Future<void> saveCredentials({
    required String email,
    required String password,
  }) async {
    await _localStorage.write(SecureStorageKeys.rememberedEmail.key, email);
    await _localStorage.write(
      SecureStorageKeys.rememberedPassword.key,
      password,
    );
  }

  // delete saved credentials
  Future<void> deleteSavedCredentials() async {
    await _localStorage.delete(SecureStorageKeys.rememberedEmail.key);
    await _localStorage.delete(SecureStorageKeys.rememberedPassword.key);
  }
}

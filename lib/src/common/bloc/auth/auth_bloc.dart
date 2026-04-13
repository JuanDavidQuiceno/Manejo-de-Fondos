import 'dart:async';

import 'package:dashboard/src/common/auth/repository/auth_repository.dart';
import 'package:dashboard/src/common/models/user/user_model.dart';
import 'package:dashboard/src/config/inyection/global_locator.dart';
import 'package:dashboard/src/core/config/secure_storage_services.dart';
import 'package:dashboard/src/core/config/storage_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// AuthStatus enum verificar el estado del usuario
/// [checking] - The user is being checked
/// [authenticated] - The user is authenticated
/// [notAuthenticated] - The user is not authenticated
enum AuthStatus {
  /// Checing: verificando el estado del usuario
  checking,

  /// Authenticated: El usuario está autenticado
  authenticated,

  /// NotAuthenticated: El usuario no está autenticado
  notAuthenticated,
}

/// Role enum verificar el rol del usuario
/// [distributor] - El usuario es un distribuidor
enum Role {
  ///
  distributor,
}

/// AuthBloc - Bloc para manejar la autenticación del usuario y el estado de la
/// aplicación en general, cambio de rutas y logout
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  ///
  AuthBloc({
    required AuthRepository repository,
    required StorageService secureStorage,
  }) : _repository = repository,
       _secureStorage = secureStorage,

       super(
         AuthInitial(
           authStatus: AuthStatus.checking,
           user: UserModel.fromJson({}),
         ),
       ) {
    on<AuthInitialEvent>(
      (event, emit) => emit(
        AuthInitialState(authStatus: AuthStatus.checking, user: state.user),
      ),
    );
    on<AuthChangeEvent>(_changeState);
    on<AuthValidateEvent>(_validateState);
    on<AuthLoginEvent>(_onLoginEvent);
    on<LogoutEvent>(_logout);
    _repository.status.listen((status) {
      if (status == AuthStatus.notAuthenticated) {
        add(const LogoutEvent());
      }
    });
  }
  final AuthRepository _repository;
  final StorageService _secureStorage;

  void _changeState(AuthChangeEvent event, Emitter<AuthState> emit) {
    emit(
      AuthNotificatedChangeState(
        authStatus: AuthStatus.checking,
        user: state.user,
      ),
    );
    emit(AuthInitialState(authStatus: AuthStatus.checking, user: state.user));
  }

  Future<void> _validateState(
    AuthValidateEvent event,
    Emitter<AuthState> emit,
  ) async {
    // obtenemos le store el access token
    final accessToken = await _secureStorage.read(
      SecureStorageKeys.accessToken.key,
    );
    // final intro = await _secureStorage.read(
    //   SecureStorageKeys.onboardingCompleted.key,
    // );

    // final isOnboardingCompleted = bool.tryParse(intro ?? 'false') ?? false;

    // if (!isOnboardingCompleted) {
    //   emit(
    //     AuthOnboardingState(
    //       authStatus: AuthStatus.notAuthenticated,
    //       user: state.user,
    //     ),
    //   );
    //   return;
    // }

    // Si el token es nulo o vacío, el usuario no está autenticado
    if (accessToken == null || accessToken.isEmpty) {
      emit(
        AuthNoAuthenticatedState(
          authStatus: AuthStatus.notAuthenticated,
          user: state.user,
        ),
      );
      return;
    }

    // Si llegamos aquí, el usuario está autenticado pero consultamos los datos
    // del usuario
    try {
      final response = await _repository.validateToken();

      // Consultar desde backend si el usuario saltó el onboarding profile
      // Si el endpoint devuelve 404, significa que no existe la interacción
      // (false)

      return emit(
        AuthenticatedState(
          authStatus: AuthStatus.authenticated,
          user: response,
        ),
      );
    } on Object catch (e) {
      emit(
        AuthNoAuthenticatedState(
          authStatus: AuthStatus.notAuthenticated,
          user: state.user,
          message: e.toString(),
        ),
      );
      return;
    }
  }

  Future<void> _logout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(
      AuthLoadingState(
        authStatus: AuthStatus.notAuthenticated,
        user: UserModel.fromJson({}),
      ),
    );
    final storage = global<StorageService>();
    await storage.delete(SecureStorageKeys.accessToken.key);
    await storage.delete(SecureStorageKeys.refreshToken.key);
    emit(
      AuthNoAuthenticatedState(
        authStatus: AuthStatus.notAuthenticated,
        user: state.user,
      ),
    );
  }

  FutureOr<void> _onLoginEvent(AuthLoginEvent event, Emitter<AuthState> emit) {
    emit(AuthLoadingState(authStatus: state.authStatus, user: state.user));
    emit(
      AuthenticatedState(
        authStatus: AuthStatus.authenticated,
        user: event.model ?? state.user,
      ),
    );
  }
}

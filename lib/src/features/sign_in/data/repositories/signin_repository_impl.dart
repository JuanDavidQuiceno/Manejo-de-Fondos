import 'dart:async';

import 'package:dashboard/src/common/models/user/user_model.dart';
import 'package:dashboard/src/core/api/api_client.dart';
import 'package:dashboard/src/core/config/secure_storage_services.dart';
import 'package:dashboard/src/core/config/storage_service.dart';
import 'package:dashboard/src/core/utils/app_logger.dart';
import 'package:dashboard/src/features/sign_in/domain/models/signin_model.dart';
import 'package:dashboard/src/features/sign_in/domain/repository/signin_repository.dart';

// Implementa la interfaz (contrato) del dominio
class SignInRepositoryImpl implements SignInRepository {
  //  Recibe el ApiClient por inyección de dependencias
  SignInRepositoryImpl({
    required ApiClient apiClient,
    required StorageService storage,
  }) : _apiClient = apiClient,
       _storage = storage;
  //  Depende del ApiClient (viene de la capa /core)
  final ApiClient _apiClient;
  final StorageService _storage;

  @override
  Future<UserModel> signIn(LoginModel loginModel) async {
    final response = await _apiClient.post(
      path: '/v1/auth/login',
      body: {'email': loginModel.email, 'password': loginModel.password},
    );

    if (response.data is! Map<String, dynamic>) {
      AppLogger.error(
        'Invalid response data type: ${response.data.runtimeType}',
        tag: 'SignInRepository',
      );
      throw Exception('Invalid response data');
    }

    final data = response.data as Map<String, dynamic>;

    // Extraer tokens del objeto 'tokens' en la respuesta
    AppLogger.info(
      'Response data keys: ${data.keys.toList()}',
      tag: 'SignInRepository',
    );

    final tokens = data['tokens'] as Map<String, dynamic>?;
    if (tokens != null) {
      final accessToken = tokens['accessToken'] as String?;
      final refreshToken = tokens['refreshToken'] as String?;

      AppLogger.info(
        'Tokens found: access=${accessToken != null}, '
        'refresh=${refreshToken != null}',
        tag: 'SignInRepository',
      );

      if (accessToken != null) {
        try {
          await _saveTokens(
            accessToken: accessToken,
            refreshToken: refreshToken,
          );
          AppLogger.success(
            'Tokens saved successfully',
            tag: 'SignInRepository',
          );
        } on Object catch (e) {
          AppLogger.error('Error saving tokens: $e', tag: 'SignInRepository');
          rethrow;
        }
      }
    } else {
      AppLogger.warning(
        'No tokens object found in response',
        tag: 'SignInRepository',
      );
    }

    // Verificar que existan los datos del usuario
    AppLogger.info('Verificando userData...', tag: 'SignInRepository');
    AppLogger.info(
      'Response data keys: ${data.keys.toList()}',
      tag: 'SignInRepository',
    );

    final userData = data['data'];
    if (userData == null) {
      AppLogger.error(
        'User data is null. Response keys: ${data.keys.toList()}',
        tag: 'SignInRepository',
      );
      throw Exception('User data not found in response');
    }

    if (userData is! Map<String, dynamic>) {
      AppLogger.error(
        'User data is not a Map: ${userData.runtimeType}',
        tag: 'SignInRepository',
      );
      throw Exception('Invalid user data format');
    }

    AppLogger.info('Creando UserModel...', tag: 'SignInRepository');
    AppLogger.info(
      'userData keys: ${userData.keys.toList()}',
      tag: 'SignInRepository',
    );

    try {
      final user = UserModel.fromJson(userData);
      AppLogger.success(
        'UserModel creado exitosamente',
        tag: 'SignInRepository',
      );
      return user;
    } on Object catch (e) {
      AppLogger.error('Error creando UserModel: $e', tag: 'SignInRepository');
      rethrow;
    }
  }

  // Método privado para guardar tokens
  Future<void> _saveTokens({String? accessToken, String? refreshToken}) async {
    AppLogger.info(
      'Saving tokens - access: ${accessToken?.substring(0, 20)}...',
      tag: 'SignInRepository',
    );

    if (accessToken != null) {
      await _storage.write(SecureStorageKeys.accessToken.key, accessToken);
      // Verificar que se guardó correctamente
      final saved = await _storage.read(SecureStorageKeys.accessToken.key);
      AppLogger.info(
        'Token saved and verified: ${saved != null}',
        tag: 'SignInRepository',
      );
    }
    if (refreshToken != null) {
      await _storage.write(SecureStorageKeys.refreshToken.key, refreshToken);
    }
  }
}

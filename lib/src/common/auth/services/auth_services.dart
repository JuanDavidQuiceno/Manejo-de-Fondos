import 'dart:async'; // Para 'unawaited'

import 'package:dashboard/src/common/auth/repository/auth_repository.dart';
import 'package:dashboard/src/common/bloc/auth/auth_bloc.dart';
import 'package:dashboard/src/common/models/user/user_model.dart';
import 'package:dashboard/src/core/api/api_client.dart';
import 'package:dashboard/src/core/config/secure_storage_services.dart';
import 'package:dashboard/src/core/config/storage_service.dart';
import 'package:dashboard/src/core/environments.dart';
import 'package:dashboard/src/core/models/api_response_model.dart';
import 'package:dashboard/src/core/utils/app_logger.dart';
import 'package:dio/dio.dart';

class AuthService implements AuthRepository {
  AuthService({required ApiClient apiClient, required StorageService storage})
    : _apiClient = apiClient,
      _storage = storage;
  final ApiClient _apiClient;
  final StorageService _storage;

  final _controller = StreamController<AuthStatus>();

  @override
  Stream<AuthStatus> get status async* {
    yield AuthStatus.checking;
    yield* _controller.stream;
  }

  // Cliente Dio *simple* SÓLO para el refresh token (evita bucles)
  // No tiene interceptores de token.
  final Dio _dioRefreshClient = Dio(BaseOptions(baseUrl: Environment.urlApi));

  // --- MÉTODOS DE TOKENS (usados por ApiClient) ---

  @override
  Future<String?> getAccessToken() async {
    final token = await _storage.read(SecureStorageKeys.accessToken.key);
    AppLogger.info(
      'getAccessToken called - token exists: ${token != null}',
      tag: 'AuthService',
    );
    return token;
  }

  static const int _maxRefreshAttempts = 2;

  /// Lógica para refrescar el token (usada por el interceptor de ApiClient)
  @override
  Future<bool> handleTokenRefresh() async {
    final refreshToken = await _storage.read(
      SecureStorageKeys.refreshToken.key,
    );
    if (refreshToken == null) {
      _controller.add(AuthStatus.notAuthenticated);
      return false;
    }

    var attempts = 0;

    while (attempts < _maxRefreshAttempts) {
      try {
        final response = await _dioRefreshClient.post<dynamic>(
          '/v1/auth/refresh',
          data: {'refresh_token': refreshToken},
        );

        if (response.statusCode == 200) {
          final data = response.data as Map<String, dynamic>;
          final tokens = data['tokens'] as Map<String, dynamic>?;

          if (tokens != null) {
            await _saveTokens(
              tokens['accessToken'] as String,
              tokens['refreshToken'] as String,
            );
            return true;
          }
          // Tokens no encontrados en respuesta
          await _clearTokensAndNotify();
          return false;
        } else {
          // Error del servidor (no de red) → cerrar sesión inmediato
          await _clearTokensAndNotify();
          return false;
        }
      } on DioException catch (e) {
        // Solo reintentar en errores de red/timeout
        if (_isNetworkError(e)) {
          attempts++;
          AppLogger.warning(
            'Token refresh network error, attempt $attempts/$_maxRefreshAttempts',
            tag: 'AuthService',
          );
          if (attempts < _maxRefreshAttempts) {
            await Future<void>.delayed(const Duration(seconds: 1));
            continue;
          }
        }
        // Error no recuperable o máximo de intentos alcanzado
        AppLogger.error('Token refresh failed: $e', tag: 'AuthService');
        await _clearTokensAndNotify();
        return false;
      } on Exception catch (e) {
        AppLogger.error('Token refresh failed: $e', tag: 'AuthService');
        await _clearTokensAndNotify();
        return false;
      }
    }

    await _clearTokensAndNotify();
    return false;
  }

  /// Verifica si es un error de red que vale la pena reintentar
  bool _isNetworkError(DioException e) {
    return e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout;
  }

  /// Limpia tokens localmente sin hacer llamadas API (evita loops en 401)
  Future<void> _clearTokensAndNotify() async {
    await _storage.delete(SecureStorageKeys.accessToken.key);
    await _storage.delete(SecureStorageKeys.refreshToken.key);
    _controller.add(AuthStatus.notAuthenticated);
  }

  /// Cierra sesión y borra todos los datos seguros
  @override
  Future<void> logout() async {
    try {
      // Optional: Call logout endpoint if authenticated
      final token = await getAccessToken();
      if (token != null) {
        unawaited(_apiClient.post(path: '/v1/auth/logout'));
      }
    } on Object catch (_) {
      // Ignore logout errors
    } finally {
      await _storage.deleteAll();
      _controller.add(AuthStatus.notAuthenticated);
    }
  }

  // Método privado para guardar tokens
  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(SecureStorageKeys.accessToken.key, accessToken);
    await _storage.write(SecureStorageKeys.refreshToken.key, refreshToken);
  }

  @override
  Future<UserModel> validateToken() async {
    final response = await _apiClient.get(path: '/v1/auth/me');

    if (response.data is! Map<String, dynamic>) {
      throw Exception('Invalid response data');
    }

    final data = response.data as Map<String, dynamic>;

    if (data['data'] == null) {
      throw Exception('User data not found in response');
    }

    return UserModel.fromJson(data['data'] as Map<String, dynamic>);
  }

  @override
  Future<ApiResponseModel<String>> resendValidationCode(
    String emailOrPhone,
  ) async {
    final response = await _apiClient.post(
      path: '/api/v1/auth/resend-verification',
      body: {'identifier': emailOrPhone},
    );
    final data = response.data as Map<String, dynamic>? ?? {};
    final message = data['message'] as String? ?? 'Code resent successfully';
    return ApiResponseModel<String>(
      data: message,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      isSuccess: response.statusCode == 200,
    );
  }

  @override
  Future<void> validateAccount(String code) {
    return _apiClient.post(
      path: '/api/v1/auth/verify-code',
      body: {'code': code},
    );
  }

  @override
  Future<UserModel> authenticateWithFirebase({
    required String firebaseToken,
    String? fcmToken,
    String? deviceType,
  }) async {
    // Use the simple Dio client to avoid token interceptor issues
    final response = await _dioRefreshClient.post<dynamic>(
      '/api/v1/auth/firebase',
      data: {
        'firebase_token': firebaseToken,
        if (fcmToken != null) 'fcm_token': fcmToken,
        if (deviceType != null) 'device_type': deviceType,
      },
    );

    // Extract JWT token from Authorization header
    if (response.headers.map.containsKey('authorization')) {
      final token = response.headers.map['authorization']?.first;
      if (token != null) {
        // Extract access token (format: "Bearer <token>" or just "<token>")
        final accessToken = token.startsWith('Bearer ')
            ? token.substring(7)
            : token;
        await _storage.write(SecureStorageKeys.accessToken.key, accessToken);
      }
    }

    // Extract refresh token from response body if available
    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      if (data.containsKey('refreshToken')) {
        await _storage.write(
          SecureStorageKeys.refreshToken.key,
          data['refreshToken'] as String,
        );
      }
    }

    if (response.data is! Map<String, dynamic>) {
      throw Exception('Invalid response data');
    }

    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  void dispose() => _controller.close();
}

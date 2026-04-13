import 'dart:async';
import 'dart:io';

import 'package:dashboard/src/core/api/api_exception.dart';
import 'package:dashboard/src/core/environments.dart';
import 'package:dashboard/src/core/utils/app_logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Un cliente de API robusto que utiliza Dio para la red.
///
/// Maneja la inyección de tokens, la renovación de tokens y la
/// transformación de errores de Dio a [ApiException] personalizadas
/// de forma transparente a través de interceptores.
class ApiClient {
  ApiClient({
    Dio? dio,
    String? baseUrl,
    Future<String?> Function()? getToken,
    Future<bool> Function()? onRefreshToken,
  }) : _dio = dio ?? Dio(),
       _getToken = getToken,
       _onRefreshToken = onRefreshToken {
    // Configuración base de Dio
    final apiUrl = baseUrl ?? Environment.urlApi;

    // Validar que la URL del API esté configurada
    if (apiUrl.isEmpty) {
      throw Exception(
        'API_URL no está configurada. '
        'Ejecuta la app con --dart-define-from-file=api-key-dev.json',
      );
    }

    // Usar AppLogger para que funcione también en release con ENABLE_LOGS=true
    AppLogger.info('API URL configurada: $apiUrl', tag: 'ApiClient');

    _dio.options = BaseOptions(
      baseUrl: apiUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.acceptHeader: 'application/json',
        // plataforma ios o android (con soporte web)
        'X-Platform': kIsWeb ? 'web' : (Platform.isIOS ? 'ios' : 'android'),
      },
    );

    // Añade los interceptores en orden
    _dio.interceptors.add(
      _TokenInterceptor(
        dio: _dio,
        getToken: _getToken,
        onRefreshToken: _onRefreshToken,
      ),
    );

    _dio.interceptors.add(_ErrorInterceptor());

    // Opcional: Añadir un interceptor de logs en modo debug
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
  }
  final Dio _dio;
  final Future<String?> Function()? _getToken;
  final Future<bool> Function()? _onRefreshToken;

  /// Lanza una [ApiException] en caso de error.
  Future<Response<dynamic>> get({
    required String path,
    // T Function(dynamic json)? fromJson,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParams,
        options: Options(headers: headers),
      );
      return response;
      // Dio decodifica el JSON automáticamente
      // return fromJson != null ? fromJson(response.data) : response.data as
      // T?;
    } on DioException catch (e) {
      final error = e.error;
      if (error is ApiException) {
        throw error;
      }
      rethrow;
    } on Object catch (_) {
      rethrow;
    }
  }

  /// Lanza una [ApiException] en caso de error.
  // Future<Response<dynamic>> post<T>({
  /// POST request. Acepta [Map<String, dynamic>] o [FormData] como body.
  Future<Response<dynamic>> post({
    required String path,
    Map<String, String>? queryParams,
    dynamic body,
    Map<String, String>? headers,
  }) async {
    try {
      _debugBody('POST', path, body);
      final response = await _dio.post<dynamic>(
        path,
        queryParameters: queryParams,
        data: body,
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      final error = e.error;
      if (error is ApiException) {
        throw error;
      }
      rethrow;
    } on Object catch (_) {
      rethrow;
    }
  }

  /// PUT request. Acepta [Map<String, dynamic>] o [FormData] como body.
  Future<Response<dynamic>> put({
    required String path,
    Map<String, String>? queryParams,
    dynamic body,
    Map<String, String>? headers,
  }) async {
    try {
      _debugBody('PUT', path, body);
      final response = await _dio.put<dynamic>(
        path,
        queryParameters: queryParams,
        data: body,
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      final error = e.error;
      if (error is ApiException) {
        throw error;
      }
      rethrow;
    } on Object catch (_) {
      rethrow;
    }
  }

  /// PATCH request with support for multipart/form-data
  ///
  /// Use [FormData] from Dio for multipart requests (file uploads)
  Future<Response<dynamic>> patch({
    required String path,
    Map<String, String>? queryParams,
    dynamic data, // Can be Map<String, dynamic> or FormData
    Map<String, String>? headers,
  }) async {
    try {
      _debugBody('PATCH', path, data);
      final response = await _dio.patch<dynamic>(
        path,
        queryParameters: queryParams,
        data: data,
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      final error = e.error;
      if (error is ApiException) {
        throw error;
      }
      rethrow;
    } on Object catch (_) {
      rethrow;
    }
  }

  Future<Response<dynamic>> delete({
    required String path,
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.delete<dynamic>(
        path,
        queryParameters: queryParams,
        data: body,
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      final error = e.error;
      if (error is ApiException) {
        throw error;
      }
      rethrow;
    } on Object catch (_) {
      rethrow;
    }
  }

  /// Debug: imprime el contenido de FormData en modo debug.
  void _debugBody(String method, String path, dynamic body) {
    if (kDebugMode) {
      if (!kDebugMode || body is! FormData) return;
      print('\n=== 📦 FormData ($method $path) ===');
      for (final field in body.fields) {
        print('  📝 ${field.key} = ${field.value}');
      }
      for (final file in body.files) {
        print(
          '  📎 ${file.key} = ${file.value.filename} '
          '(${file.value.length} bytes)',
        );
      }
      print('=== End FormData ===\n');
    }
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.error is ApiException) {
      return handler.reject(err);
    }

    // 1. Intentamos extraer el mensaje del servidor PRIMERO
    final serverMessage = _extractServerMessage(err.response);

    final ApiException apiException;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        apiException = ApiException(
          type: ExceptionType.requestTimeout,
          message: 'Tiempo de conexión agotado',
        );
      case DioExceptionType.connectionError:
        apiException = ApiException(
          type: ExceptionType.noInternetConnection,
          message: '¡Ups! Algo salió mal. Verifica tu conexión a internet.',
        );
      case DioExceptionType.unknown:
        if (err.error is SocketException) {
          apiException = ApiException(
            type: ExceptionType.noInternetConnection,
            message: 'Verifica tu conexión a internet.',
          );
        } else {
          apiException = ApiException(
            type: ExceptionType.unexpectedError,
            message: err.message ?? 'Error desconocido',
          );
        }
      case DioExceptionType.badResponse:
        // Aquí pasamos el serverMessage extraído a la excepción
        switch (err.response?.statusCode) {
          case 400:
            apiException = ApiException(
              type: ExceptionType.badRequest,
              message: serverMessage ?? 'Solicitud incorrecta',
            ); // <--- AQUI ESTABA EL ERROR
          case 401:
          case 403:
            apiException = ApiException(
              type: ExceptionType.unauthorisedRequest,
              message: serverMessage ?? 'No autorizado',
            );
          case 404:
            apiException = ApiException(
              type: ExceptionType.notFound,
              message: serverMessage ?? 'No encontrado',
            );
          case 409:
            apiException = ApiException(
              type: ExceptionType.conflict,
              message: serverMessage ?? 'Conflicto',
            );
          case 500:
          case 502:
            apiException = ApiException(
              type: ExceptionType.internalServerError,
              message: 'Error interno del servidor',
            );
          case 503:
            apiException = ApiException(
              type: ExceptionType.serviceUnavailable,
              message: 'Servicio no disponible',
            );
          default:
            apiException = ApiException(
              type: ExceptionType.unexpectedError,
              message: serverMessage ?? 'Error inesperado',
            );
        }
      case DioExceptionType.cancel:
        apiException = ApiException(
          type: ExceptionType.requestCancelled,
          message: 'Solicitud cancelada',
        );
      case DioExceptionType.badCertificate:
        apiException = ApiException(
          type: ExceptionType.unexpectedError,
          message: 'Certificado inválido',
        );
    }

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: apiException,
        response: err.response,
        type: err.type,
      ),
    );
  }

  /// Función auxiliar para reutilizar la lógica de extracción de mensaje
  /// dentro del interceptor
  String? _extractServerMessage(Response<dynamic>? response) {
    final data = response?.data;
    if (data != null && data is Map<String, dynamic>) {
      if (data.containsKey('message') && data['message'] != null) {
        final message = data['message'];
        if (message is String) return message;
        if (message is List && message.isNotEmpty) {
          return message.first.toString();
        }
        return message.toString();
      } else if (data.containsKey('error') && data['error'] != null) {
        final error = data['error'];
        if (error is String) return error;
        if (error is List && error.isNotEmpty) return error.first.toString();
        return error.toString();
      } else if (data.containsKey('detail') && data['detail'] != null) {
        final detail = data['detail'];
        if (detail is String) return detail;
        if (detail is List && detail.isNotEmpty) return detail.first.toString();
        return detail.toString();
      }
    }
    return null;
  }
}

/// Interceptor para inyectar el token y manejar la lógica de "refresh token"
/// Interceptor para inyectar el token y manejar la lógica de "refresh token"
class _TokenInterceptor extends QueuedInterceptorsWrapper {
  _TokenInterceptor({
    required Dio dio,
    Future<String?> Function()? getToken,
    Future<bool> Function()? onRefreshToken,
  }) : _dio = dio,
       _getToken = getToken,
       _onRefreshToken = onRefreshToken;
  final Dio _dio;
  final Future<String?> Function()? _getToken;
  final Future<bool> Function()? _onRefreshToken;

  /// Intercepta la petición ANTES de que se envíe
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // if (_getToken != null) {
    //   final token = await _getToken();
    //   if (token != null && token.isNotEmpty) {
    //     options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    //   }
    // }
    // return handler.next(options);
    if (_getToken != null) {
      // --- FIX CRÍTICO ---
      // Verificamos si el header de autorización YA existe en la petición
      // actual.
      // Búsqueda insensible a mayúsculas/minúsculas para detectar
      // 'Authorization', 'authorization', etc.
      final headers = options.headers;
      final hasAuthHeader = headers.keys.any(
        (k) => k.toLowerCase() == HttpHeaders.authorizationHeader.toLowerCase(),
      );

      // Solo inyectamos el token si NO se ha proporcionado un header de
      // autorización manualmente.
      if (!hasAuthHeader) {
        final token = await _getToken();
        if (token != null && token.isNotEmpty) {
          options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
        } else {
          if (kDebugMode) {
            // Ayuda a diagnosticar errores tipo "user required"
            //(token faltante).
            // Solo imprime la ruta; no imprime tokens.
            print(
              '⚠️ ApiClient: no access token available for request:'
              ' ${options.method} ${options.uri}',
            );
          }
        }
      }
    }
    return handler.next(options);
  }

  /// Intercepta la respuesta de ERROR
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Si es un error 401 y tenemos una función de refresh, intentamos renovar
    if (err.response?.statusCode == 401 && _onRefreshToken != null) {
      final opts = err.requestOptions;

      // Prevent infinite retry loops
      if (opts.extra['is_retry'] == true) {
        return handler.next(err);
      }

      try {
        final refreshSuccess = await _onRefreshToken();

        if (refreshSuccess) {
          // Si el refresh fue exitoso, reintenta la petición original
          opts.extra['is_retry'] = true;

          // Crear un cliente temporal para el reintento evita un Deadlock
          // dentro de la cola del QueuedInterceptorsWrapper si este falla.
          final retryDio = Dio(_dio.options);
          retryDio.interceptors.add(_ErrorInterceptor());

          final newToken = await _getToken?.call();
          if (newToken != null) {
            // Elimina header anterior (case-insensitive)
            opts.headers.removeWhere(
              (k, v) =>
                  k.toLowerCase() ==
                  HttpHeaders.authorizationHeader.toLowerCase(),
            );
            opts.headers[HttpHeaders.authorizationHeader] = 'Bearer $newToken';
          }

          final response = await retryDio.fetch<dynamic>(opts);
          return handler.resolve(response);
        } else {
          // Si el refresh falló, pasa el error 401 original
          return handler.next(err);
        }
      } on DioException catch (e) {
        // Si el reintento falló (ej. retornó un 500), debemos rechazarlo aquí
        // para preservar el error real (ya procesado por _ErrorInterceptor).
        return handler.reject(e);
      } on Exception catch (e) {
        // Fallos de ejecución puros durante el refresh.
        final apiException = ApiException(
          type: ExceptionType.unauthorisedRequest,
          message: e.toString(),
        );
        return handler.reject(
          DioException(requestOptions: err.requestOptions, error: apiException),
        );
      }
    }

    // Si no es un 401 o no hay refresh, deja que el ErrorInterceptor lo maneje
    return handler.next(err);
  }
}

import 'package:dashboard/src/core/api/api_exception.dart';
import 'package:dashboard/src/core/models/api_response_error_model.dart';
import 'package:dio/dio.dart';

mixin ApiResponseErrorMixin {
  /// Extrae un mensaje de error legible desde una excepción de API.
  ///
  /// Busca un [DioException] y, si lo encuentra, intenta
  /// extraer el campo 'message' del JSON de respuesta.
  /// Si falla, devuelve un mensaje genérico.
  String extractApiErrorMessage(Object error) {
    var errorMessage = 'An unknown error occurred';
    // 1. Si el error es directamente una ApiException
    // (raro en Dio, pero posible)
    if (error is ApiException) {
      return error.message;
    }

    // 2. Si es DioException, miramos si el interceptor ya lo procesó
    if (error is DioException) {
      final apiError = error.error;

      // Si el interceptor ya convirtió el error a ApiException, usamos
      // SU mensaje
      if (apiError is ApiException) {
        return apiError.message;
      }

      // Extraer mensaje del JSON de respuesta
      final data = error.response?.data;
      if (data != null && data is Map<String, dynamic>) {
        if (data.containsKey('message')) {
          final message = data['message'];
          if (message is String) {
            errorMessage = message;
          } else if (message is List && message.isNotEmpty) {
            errorMessage = message.first.toString();
          }
        } else if (data.containsKey('error')) {
          final errorData = data['error'];
          if (errorData is String) {
            errorMessage = errorData;
          } else if (errorData is List && errorData.isNotEmpty) {
            errorMessage = errorData.first.toString();
          }
        } else if (data.containsKey('detail')) {
          final detail = data['detail'];
          if (detail is String) {
            errorMessage = detail;
          } else if (detail is List && detail.isNotEmpty) {
            errorMessage = detail.first.toString();
          }
        }
      } else if (error.message != null) {
        errorMessage = error.message!;
      }
    } else {
      errorMessage = error.toString();
    }

    return errorMessage;
  }

  /// Extrae el tipo de excepción desde un error
  ExceptionType? extractExceptionType(Object error) {
    if (error is DioException) {
      final apiError = error.error;
      if (apiError is ApiException) {
        return apiError.type;
      }
    }
    return null;
  }

  /// Obtiene el modelo completo de error con statusCode, message y type
  ApiResponseErrorModel extractErrorModel(Object error) {
    var statusCode = 0;
    ExceptionType? exceptionType;
    final errorMessage = error.toString();

    if (error is DioException) {
      statusCode = error.response?.statusCode ?? 0;
      final apiError = error.error;
      if (apiError is ApiException) {
        exceptionType = apiError.type;
      }
    }

    return ApiResponseErrorModel(
      statusCode: statusCode,
      message: errorMessage,
      type: exceptionType,
    );
  }

  bool isNotFoundError(Object error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode ?? 0;
      return statusCode == 404;
    }
    return false;
  }
}

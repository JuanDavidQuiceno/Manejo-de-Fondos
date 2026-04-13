import 'package:dio/dio.dart';

/// Un modelo genérico para estandarizar las respuestas de la API.
/// [T] es el tipo de dato que esperas recibir ya parseado
/// (ej. User, List, etc).
class ApiResponseModel<T> {
  // 2. Constructor Constante
  const ApiResponseModel({
    this.data,
    this.statusCode,
    this.statusMessage,
    this.extra,
    this.isSuccess = false,
  });
  // 3. Factory: De Dio -> Tu Modelo
  // Aquí es donde ocurre la magia de la transformación.
  //
  // [response]: La respuesta cruda de Dio.
  // [parser]: Una función opcional que toma el JSON y devuelve el objeto T.
  //           Si T es un tipo primitivo o Map, no es necesario enviarlo.
  factory ApiResponseModel.fromDioResponse(
    Response<dynamic> response, {
    T Function(dynamic json)? parser,
  }) {
    final code = response.statusCode ?? 0;
    // Consideramos éxito típicamente entre 200 y 299
    final success = code >= 200 && code < 300;

    T? parsedData;

    try {
      if (success && response.data != null) {
        if (parser != null) {
          // Si nos dieron un parser, lo usamos para transformar el Map/List a T
          parsedData = parser(response.data);
        } else {
          // Si no hay parser, asumimos que T es el tipo crudo
          // (dynamic, Map, List, etc.)
          parsedData = response.data as T?;
        }
      }
    } on Exception catch (_) {
      // Si falla el parsing, podrías manejarlo aquí o dejarlo null
      // print('Error parseando data: $e');
      parsedData = null;
    }

    return ApiResponseModel<T>(
      data: parsedData,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      extra: response.extra as Map<String, dynamic>?,
      isSuccess: success,
    );
  }

  // 4. Factory: Para errores manuales (catch blocs)
  factory ApiResponseModel.error({
    int statusCode = 500,
    String message = 'Error desconocido',
    T? data,
  }) {
    return ApiResponseModel<T>(
      statusCode: statusCode,
      statusMessage: message,
      data: data,
    );
  }
  // 1. Propiedades (Inmutables)
  final T? data;
  final int? statusCode;
  final String? statusMessage;
  final Map<String, dynamic>? extra;
  final bool isSuccess;

  // 5. CopyWith
  ApiResponseModel<T> copyWith({
    T? data,
    int? statusCode,
    String? statusMessage,
    Map<String, dynamic>? extra,
    bool? isSuccess,
  }) {
    return ApiResponseModel<T>(
      data: data ?? this.data,
      statusCode: statusCode ?? this.statusCode,
      statusMessage: statusMessage ?? this.statusMessage,
      extra: extra ?? this.extra,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  String toString() {
    return 'ApiResponseModel(success: $isSuccess, status: $statusCode, '
        'message: $statusMessage, data: $data)';
  }
}

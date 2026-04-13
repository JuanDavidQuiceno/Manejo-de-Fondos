// Clase para encapsular los errores de la API de forma controlada
class ApiException implements Exception {
  ApiException({
    required this.type,
    this.message = 'Ocurrió un error inesperado.',
    this.statusCode,
  });
  final String message;
  final int? statusCode;
  final ExceptionType type;

  @override
  String toString() => message;
}

// Tipos de errores para identificarlos fácilmente en la UI
enum ExceptionType {
  requestCancelled,
  unauthorisedRequest,
  badRequest,
  notFound,
  methodNotAllowed,
  notAcceptable,
  requestTimeout,
  conflict,
  internalServerError,
  serviceUnavailable,
  noInternetConnection,
  formatException,
  unableToProcess,
  unexpectedError,
}

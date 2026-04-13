import 'package:dashboard/src/core/api/api_exception.dart';

class ApiResponseErrorModel {
  ApiResponseErrorModel({
    required this.statusCode,
    required this.message,
    this.type,
  });
  final int statusCode;
  final String message;
  final ExceptionType? type;

  bool get isNoInternetConnection => type == ExceptionType.noInternetConnection;
  bool get isTimeout => type == ExceptionType.requestTimeout;
  bool get isUnauthorized => type == ExceptionType.unauthorisedRequest;
  bool get isServerError => type == ExceptionType.internalServerError;
}

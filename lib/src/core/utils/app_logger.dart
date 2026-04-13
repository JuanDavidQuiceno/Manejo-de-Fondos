import 'package:flutter/foundation.dart';

/// Logger que permite habilitar logs incluso en modo release
class AppLogger {
  AppLogger._();

  /// Variable de entorno para habilitar logs en release
  static const bool _enableLogsInRelease = bool.fromEnvironment('ENABLE_LOGS');

  /// Verifica si los logs están habilitados
  static bool get _shouldLog => kDebugMode || _enableLogsInRelease;

  /// Imprime un mensaje si los logs están habilitados
  static void log(String message, {String? tag}) {
    if (_shouldLog) {
      final prefix = tag != null ? '[$tag]' : '';
      debugPrint('$prefix $message');
    }
  }

  /// Imprime un mensaje de información
  static void info(String message, {String? tag}) {
    if (_shouldLog) {
      final prefix = tag != null ? '[$tag]' : '';
      debugPrint('ℹ️ $prefix $message');
    }
  }

  /// Imprime un mensaje de advertencia
  static void warning(String message, {String? tag}) {
    if (_shouldLog) {
      final prefix = tag != null ? '[$tag]' : '';
      debugPrint('⚠️ $prefix $message');
    }
  }

  /// Imprime un mensaje de error
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (_shouldLog) {
      final prefix = tag != null ? '[$tag]' : '';
      debugPrint('❌ $prefix $message');
      if (error != null) {
        debugPrint('   Error: $error');
      }
      if (stackTrace != null) {
        debugPrint('   StackTrace: $stackTrace');
      }
    }
  }

  /// Imprime un mensaje de éxito
  static void success(String message, {String? tag}) {
    if (_shouldLog) {
      final prefix = tag != null ? '[$tag]' : '';
      debugPrint('✅ $prefix $message');
    }
  }

  /// Imprime un mensaje de debug (solo en modo debug)
  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag]' : '';
      debugPrint('🐛 $prefix $message');
    }
  }
}

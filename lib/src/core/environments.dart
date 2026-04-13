import 'package:dashboard/src/core/utils/app_logger.dart';

class Environment {
  const Environment._();

  static Map<String, String> get headers => const {
    'x-api-key': String.fromEnvironment('x-api-key'),
  };

  static String get urlApi {
    const url = String.fromEnvironment('API_URL');
    if (url.isEmpty) {
      AppLogger.warning(
        'API_URL está vacía. Verifica que ejecutaste la app con:',
        tag: 'Environment',
      );
      AppLogger.info(
        '   --dart-define-from-file=api-key-dev.json',
        tag: 'Environment',
      );
      AppLogger.info(
        '   O con: --dart-define=API_URL=http://localhost:8001',
        tag: 'Environment',
      );
    }
    return url;
  }

  static String get termOfServiceUrl {
    return const String.fromEnvironment('TERMS_OF_SERVICE_URL');
  }
}

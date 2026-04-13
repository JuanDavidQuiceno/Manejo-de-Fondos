import 'package:dashboard/src/core/utils/app_logger.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// Utilidad para manejar la apertura de enlaces externos usando url_launcher.
class AppUrlLauncher {
  const AppUrlLauncher._();

  /// Intenta abrir un [url] utilizando el paquete `url_launcher`.
  ///
  /// Recibe un [url] que puede ser cualquier enlace válido, un número de
  /// teléfono ('tel:+123'), correo electrónico ('mailto:test@test.com'), etc.
  ///
  /// Por defecto usa [LaunchMode.externalApplication] para abrir en el
  /// navegador o la aplicación nativa por defecto del sistema.
  ///
  /// Retorna `true` si se pudo abrir correctamente, `false` en caso contrario.
  static Future<bool> openUrl(
    String url, {
    LaunchMode mode = LaunchMode.externalApplication,
  }) async {
    try {
      if (await canLaunchUrlString(url)) {
        return await launchUrlString(url, mode: mode);
      } else {
        AppLogger.warning(
          'No se pudo lanzar la URL: $url',
          tag: 'AppUrlLauncher',
        );
        return false;
      }
    } on Exception catch (e, st) {
      AppLogger.error(
        'Error al intentar abrir la URL: $url',
        error: e,
        stackTrace: st,
        tag: 'AppUrlLauncher',
      );
      return false;
    }
  }
}

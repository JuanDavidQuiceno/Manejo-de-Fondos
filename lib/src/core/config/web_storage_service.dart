import 'package:dashboard/src/core/config/storage_service.dart';
import 'package:dashboard/src/core/utils/app_logger.dart';
import 'package:web/web.dart' as web;

/// Servicio de almacenamiento para Web usando localStorage directamente.
/// Este servicio se usa en web donde flutter_secure_storage tiene problemas.
/// Usa window.localStorage nativo del navegador para máxima compatibilidad.
class WebStorageService implements StorageService {
  @override
  Future<void> write(String key, String value) async {
    try {
      AppLogger.info('WebStorage: escribiendo key=$key', tag: 'WebStorage');
      web.window.localStorage.setItem(key, value);
      AppLogger.success('WebStorage: escrito exitosamente', tag: 'WebStorage');
    } on Object catch (e) {
      AppLogger.error('WebStorage: error escribiendo: $e', tag: 'WebStorage');
      rethrow;
    }
  }

  @override
  Future<String?> read(String key) async {
    try {
      final value = web.window.localStorage.getItem(key);
      AppLogger.info(
        'WebStorage: leyendo key=$key, found=${value != null}',
        tag: 'WebStorage',
      );
      return value;
    } on Object catch (e) {
      AppLogger.error(
        'WebStorage: error leyendo key=$key: $e',
        tag: 'WebStorage',
      );
      return null;
    }
  }

  @override
  Future<void> delete(String key) async {
    try {
      web.window.localStorage.removeItem(key);
      AppLogger.info('WebStorage: borrado key=$key', tag: 'WebStorage');
    } on Object catch (e) {
      AppLogger.error(
        'WebStorage: error borrando key=$key: $e',
        tag: 'WebStorage',
      );
    }
  }

  @override
  Future<void> deleteAll() async {
    try {
      web.window.localStorage.clear();
      AppLogger.info('WebStorage: borrado todo', tag: 'WebStorage');
    } on Object catch (e) {
      AppLogger.error('WebStorage: error borrando todo: $e', tag: 'WebStorage');
    }
  }
}

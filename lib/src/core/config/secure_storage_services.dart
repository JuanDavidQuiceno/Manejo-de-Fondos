import 'package:dashboard/src/core/config/storage_service.dart';
import 'package:dashboard/src/core/utils/app_logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Un wrapper simple alrededor de FlutterSecureStorage para
/// centralizar la lectura/escritura de datos sensibles (móvil).
class SecureStorageService implements StorageService {
  final _storage = const FlutterSecureStorage(
    // Opciones para Android (opcional pero recomendado)
    // Esto asegura que se use el SharedPreferences encriptado.
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    // Opciones para Web
    webOptions: WebOptions(
      dbName: 'dashboard_secure_storage',
      publicKey: 'dashboard_public_key',
    ),
  );

  @override
  Future<void> write(String key, String value) async {
    try {
      AppLogger.info('SecureStorage: escribiendo key=$key', tag: 'Storage');
      await _storage.write(key: key, value: value);
      AppLogger.success('SecureStorage: escrito exitosamente', tag: 'Storage');
    } on Object catch (e) {
      AppLogger.error('SecureStorage: error escribiendo: $e', tag: 'Storage');
      rethrow;
    }
  }

  @override
  Future<String?> read(String key) async {
    return _storage.read(key: key);
  }

  @override
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  @override
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}

enum SecureStorageKeys {
  accessToken._('accessToken'),
  refreshToken._('refreshToken'),
  onboardingCompleted._('onboardingCompleted'),
  rememberedEmail._('rememberedEmail'),
  rememberedPassword._('rememberedPassword'),
  themeMode._('themeMode');

  const SecureStorageKeys._(this.key);
  final String key;
}

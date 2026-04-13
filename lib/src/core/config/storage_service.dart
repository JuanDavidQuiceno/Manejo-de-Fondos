/// Interfaz abstracta para servicios de almacenamiento.
/// Implementada por SecureStorageService (móvil) y WebStorageService (web).
abstract class StorageService {
  /// Escribe un valor en el almacenamiento.
  Future<void> write(String key, String value);

  /// Lee un valor del almacenamiento.
  Future<String?> read(String key);

  /// Borra un valor del almacenamiento.
  Future<void> delete(String key);

  /// Borra todos los valores del almacenamiento.
  Future<void> deleteAll();
}

import 'package:dashboard/src/core/config/secure_storage_services.dart';
import 'package:dashboard/src/core/config/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._secureStorage) : super(ThemeMode.light) {
    _loadTheme();
  }
  // Inyectamos la instancia de tu almacenamiento
  final StorageService _secureStorage;

  /// Carga el tema desde Secure Storage al inicializar
  Future<void> _loadTheme() async {
    try {
      final savedTheme = await _secureStorage.read(
        SecureStorageKeys.themeMode.key,
      );

      if (savedTheme != null) {
        // Buscamos el match en el enum ThemeMode (light, dark, system)
        final mode = ThemeMode.values.firstWhere(
          (e) => e.name == savedTheme,
          orElse: () => ThemeMode.light,
        );
        emit(mode);
      }
    } on Object catch (e) {
      // Si hay error, nos quedamos en el estado inicial (light)
      debugPrint('Error cargando tema: $e');
    }
  }

  /// Guarda el ThemeMode actual (usamos .name para guardar el string 'light' o
  /// 'dark')
  Future<void> _saveTheme(ThemeMode themeMode) async {
    await _secureStorage.write(SecureStorageKeys.themeMode.key, themeMode.name);
  }

  /// Cambia el tema actual al opuesto y lo persiste
  void toggleTheme() {
    final newTheme = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;

    // Emitimos el cambio inmediatamente para la UI
    emit(newTheme);

    // Guardamos en segundo plano
    _saveTheme(newTheme);
  }
}

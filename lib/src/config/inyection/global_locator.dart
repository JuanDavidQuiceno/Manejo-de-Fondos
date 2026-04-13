import 'package:dashboard/src/common/auth/services/auth_services.dart';
import 'package:dashboard/src/core/api/api_client.dart';
import 'package:dashboard/src/core/config/secure_storage_services.dart';
import 'package:dashboard/src/core/config/storage_service.dart';
import 'package:dashboard/src/core/config/web_storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

late GetIt global;

void setUpGlobalLocator() {
  global = GetIt.I;
  // --- 1. SERVICIOS CORE (Sin dependencias) ---

  // Almacenamiento: WebStorageService para web, SecureStorageService para móvil
  global
    ..registerLazySingleton<StorageService>(
      () => kIsWeb ? WebStorageService() : SecureStorageService(),
    )
    // --- 2. API CLIENT (Dependencia diferida de AuthService) ---
    ..registerLazySingleton<ApiClient>(
      () => ApiClient(
        // Dio se crea y configura internamente dentro de ApiClient

        // Inyecta la FUNCIÓN 'getToken'
        // Esta función no se ejecuta ahora, sino cuando el interceptor
        // la llama. Para entonces, 'global<AuthService>()' ya estará
        // registrado.
        getToken: () async {
          // Resuelve AuthService en el momento de la llamada
          return global<AuthService>().getAccessToken();
        },

        // Inyecta la FUNCIÓN 'onRefreshToken'
        onRefreshToken: () async {
          // Resuelve AuthService y llama al refresh
          return global<AuthService>().handleTokenRefresh();
        },
      ),
    )
    // --- 3. SERVICIOS DE FEATURES (Dependen de ApiClient y Storage) ---
    // Servicio de Autenticación
    ..registerLazySingleton<AuthService>(
      () => AuthService(
        apiClient: global<ApiClient>(),
        storage: global<StorageService>(),
      ),
    );
}

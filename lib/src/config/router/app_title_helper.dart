import 'package:dashboard/src/common/navigation/app_routes_private_.dart';

/// Devuelve el título de la app según la ruta actual [location].
String getAppTitleFromLocation(String location) {
  // ── Sub-rutas profundas (antes del match por módulo) ──

  // ── Fallback estático para módulos (cuando no hay modules cargados) ──
  return _staticRouteTitle(location);
}

/// Fallback estático para cuando los módulos dinámicos todavía no se cargaron.
String _staticRouteTitle(String location) {
  if (location.startsWith(AppRoutesPrivate.homePath)) return 'Inicio';

  return 'Admin Panel';
}

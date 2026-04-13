import 'package:dashboard/src/common/navigation/app_routes_private_.dart';

/// Devuelve el título de la app según la ruta actual [location].
String getAppTitleFromLocation(String location) {
  if (location.startsWith(AppRoutesPrivate.fundsPath)) return 'Fondos BTG';
  return 'Admin Panel';
}

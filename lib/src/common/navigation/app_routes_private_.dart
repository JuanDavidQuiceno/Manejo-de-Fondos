/// Clase que centraliza todas las constantes de rutas (path y name)
/// para la navegación con GoRouter.
/// Cada ruta privada (requiere autenticación) debe tener su
/// correspondiente constante aquí.
/// example:
// Ejemplo de sub-ruta
// NOTA: Para sub-rutas, el path NO lleva el '/' inicial.
// static const String editProfilePath = 'edit-profile';
// static const String editProfileName = 'editProfile';
class AppRoutesPrivate {
  static const List<String> privatePaths = [homePath, rolesManagementPath];

  // Dashboard Routes
  static const String homeName = 'home';
  static const String homePath = '/home';

  static const String rolesManagementName = 'rolesManagement';
  static const String rolesManagementPath = '/roles-management';
}

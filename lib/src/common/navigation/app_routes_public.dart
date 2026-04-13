/// Clase que centraliza todas las constantes de rutas (path y name)
/// para la navegación con GoRouter.
/// Cada ruta pública (accesible sin autenticación) debe tener su
/// correspondiente constante aquí.
/// example:
// Ejemplo de sub-ruta
// NOTA: Para sub-rutas, el path NO lleva el '/' inicial.
// static const String editProfilePath = 'edit-profile';
// static const String editProfileName = 'editProfile';
class AppRoutesPublic {
  static const List<String> publicPaths = [splashPath, signInPath];
  // splash
  static const String splashPath = '/validate';
  static const String splashName = 'validate';

  static const String loadingPath = '/loading';
  static const String loadingName = 'loading';

  // Auth
  static const String signInName = 'signIn';
  static const String signInPath = '/signin';
}

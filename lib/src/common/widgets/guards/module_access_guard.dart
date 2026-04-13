import 'package:dashboard/src/common/widgets/custom_error.dart';
import 'package:flutter/material.dart';

/// Widget que protege una sección verificando si el módulo está habilitado
/// para la empresa seleccionada del usuario.
///
/// Si el módulo (por su `slug`) está activo en la empresa, muestra
/// el `child`. Si no, muestra una pantalla de acceso restringido.
///
/// Uso:
/// ```dart
/// ModuleAccessGuard(
///   moduleSlug: 'inventory',
///   child: InventoryScreen(),
/// )
/// ```
class ModuleAccessGuard extends StatelessWidget {
  const ModuleAccessGuard({
    required this.moduleSlug,
    required this.child,
    super.key,
  });

  /// Slug del módulo requerido (ej. 'inventory', 'sales', 'dashboard').
  final String moduleSlug;

  /// Widget a mostrar si el usuario tiene acceso al módulo.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CustomError(
        title: 'Acceso restringido',
        message:
            'Tu empresa no tiene acceso a esta sección.\n'
            'Contacta al administrador para habilitar este módulo.',
        imagePath: 'assets/icons/menu_setting.svg',
      ),
    );
  }
}

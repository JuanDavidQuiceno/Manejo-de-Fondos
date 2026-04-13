import 'package:dashboard/src/common/models/role/role_model.dart';

/// Slugs de roles conocidos del backend.
/// Centraliza la lógica de permisos para evitar valores hardcodeados.
enum RoleSlug {
  worker,
  trabajador,
  employee,
  owner,
  admin,
  administrator,
  propietario,
}

extension RoleSlugExtension on RoleSlug {
  /// Roles con permisos limitados (solo Inicio y Ventas en el drawer).
  static const workerRoles = {
    RoleSlug.worker,
    RoleSlug.trabajador,
    RoleSlug.employee,
  };

  /// Roles que pueden crear sucursales y ver todo el menú.
  static const adminRoles = {
    RoleSlug.owner,
    RoleSlug.admin,
    RoleSlug.administrator,
    RoleSlug.propietario,
  };

  bool get isWorker => workerRoles.contains(this);

  bool get canCreateBranches => adminRoles.contains(this);
}

extension RoleSlugParse on String {
  RoleSlug? toRoleSlug() {
    if (isEmpty) return null;
    try {
      return RoleSlug.values.firstWhere(
        (e) => e.name.toLowerCase() == toLowerCase(),
      );
    } on Object catch (_) {
      return null;
    }
  }
}

/// Devuelve true si el rol corresponde a trabajador (permisos limitados).
bool isWorkerRole(RoleModel? role) {
  final slug = role?.slug.toRoleSlug();
  return slug?.isWorker ?? false;
}

/// Devuelve true si el rol puede crear sucursales (Owner/Admin).
bool canCreateBranchesRole(RoleModel? role) {
  final slug = role?.slug.toRoleSlug();
  return slug?.canCreateBranches ?? false;
}

/// Devuelve true si el rol es administrador o propietario.
bool isAdminRole(RoleModel? role) {
  final slug = role?.slug.toRoleSlug();
  return slug?.canCreateBranches ?? false;
}

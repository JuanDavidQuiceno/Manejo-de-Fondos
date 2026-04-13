import 'package:dashboard/src/common/models/role/role_model.dart';

/// Interfaz para las operaciones de gestión de roles.
abstract class RolesManagementRepository {
  /// Crea un nuevo rol.
  Future<RoleModel> createRole(Map<String, dynamic> data);

  /// Actualiza un rol existente.
  Future<RoleModel> updateRole(String id, Map<String, dynamic> data);

  /// Elimina un rol.
  Future<void> deleteRole(String id);
}

import 'package:dashboard/src/common/models/role/role_model.dart';
import 'package:dashboard/src/core/api/api_client.dart';
import 'package:dashboard/src/features/roles_management/domain/repositories/roles_management_repository.dart';

class RolesManagementRepositoryImpl implements RolesManagementRepository {
  RolesManagementRepositoryImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<RoleModel> createRole(Map<String, dynamic> data) async {
    final response = await _apiClient.post(path: '/v1/admin/roles', body: data);

    final responseData = response.data as Map<String, dynamic>? ?? {};
    final roleData =
        responseData['data'] ?? responseData['role'] ?? responseData;

    return RoleModel.fromJson(roleData as Map<String, dynamic>);
  }

  @override
  Future<RoleModel> updateRole(String id, Map<String, dynamic> data) async {
    final response = await _apiClient.put(
      path: '/v1/admin/roles/$id',
      body: data,
    );

    final responseData = response.data as Map<String, dynamic>? ?? {};
    final roleData =
        responseData['data'] ?? responseData['role'] ?? responseData;

    return RoleModel.fromJson(roleData as Map<String, dynamic>);
  }

  @override
  Future<void> deleteRole(String id) async {
    await _apiClient.delete(path: '/v1/admin/roles/$id');
  }
}

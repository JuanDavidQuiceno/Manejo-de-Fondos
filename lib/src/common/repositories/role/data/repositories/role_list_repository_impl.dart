import 'package:dashboard/src/common/models/role/role_model.dart';
import 'package:dashboard/src/common/repositories/role/domain/repositories/role_list_repository.dart';
import 'package:dashboard/src/core/api/api_client.dart';

/// Implementación que obtiene la lista de roles.
/// GET /v1/admin/roles
class RoleListRepositoryImpl implements RoleListRepository {
  RoleListRepositoryImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<List<RoleModel>> fetch([Map<String, dynamic>? params]) async {
    final queryParams = <String, String>{};
    if (params != null) {
      for (final entry in params.entries) {
        if (entry.value != null && entry.value.toString().isNotEmpty) {
          queryParams[entry.key] = entry.value.toString();
        }
      }
    }
    final response = await _apiClient.get(
      path: '/v1/admin/roles',
      queryParams: queryParams.isNotEmpty ? queryParams : null,
    );
    final data = response.data as Map<String, dynamic>;
    final list =
        data['data'] as List<dynamic>? ?? data['roles'] as List<dynamic>? ?? [];
    return list
        .map((e) => RoleModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<RoleModel>> refresh([Map<String, dynamic>? params]) =>
      fetch(params);

  @override
  Future<List<RoleModel>> submit(
    Map<String, dynamic> data, [
    Map<String, dynamic>? params,
  ]) {
    throw UnimplementedError('Submit not supported for role list');
  }
}

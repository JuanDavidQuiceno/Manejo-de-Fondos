import 'package:dashboard/src/core/api/api_client.dart';
import 'package:dashboard/src/features/home/domain/repositories/dashboard_repository.dart';

/// GET /v1/admin/dashboard — widgets (gráficas) e indicadores.
class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<dynamic> getDashboard([Map<String, dynamic>? params]) async {
    final queryParams = <String, String>{};

    final response = await _apiClient.get(
      path: '/v1/dashboard',
      queryParams: queryParams.isNotEmpty ? queryParams : null,
    );
    final raw = response.data as Map<String, dynamic>;
    final data = raw['data'] as Map<String, dynamic>? ?? raw;
    return data;
  }
}

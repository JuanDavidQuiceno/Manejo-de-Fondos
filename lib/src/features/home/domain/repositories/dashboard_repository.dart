/// Repositorio del dashboard: widgets (gráficas) e indicadores.
abstract class DashboardRepository {
  Future<dynamic> getDashboard([Map<String, dynamic>? params]);
}

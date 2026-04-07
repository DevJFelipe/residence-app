import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/dashboard_repository.dart';
import '../data/datasources/mock/mock_dashboard_datasource.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return MockDashboardDatasource();
});

final dashboardStatsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) {
  final repo = ref.read(dashboardRepositoryProvider);
  return repo.getStats();
});

final recentActivityProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) {
  final repo = ref.read(dashboardRepositoryProvider);
  return repo.getRecentActivity();
});

final dashboardVisitorsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) {
  final repo = ref.read(dashboardRepositoryProvider);
  return repo.getRecentVisitors();
});

final collectionsDataProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) {
  final repo = ref.read(dashboardRepositoryProvider);
  return repo.getCollectionsData();
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/visitor_repository.dart';
import '../data/datasources/api/api_visitor_datasource.dart';

final visitorRepositoryProvider = Provider<VisitorRepository>((ref) {
  return ApiVisitorDatasource();
});

final activeVisitorsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  final repo = ref.read(visitorRepositoryProvider);
  return repo.getActiveVisitors();
});

final visitorLogProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  final repo = ref.read(visitorRepositoryProvider);
  return repo.getVisitorLog();
});

final occupancyProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) {
  final repo = ref.read(visitorRepositoryProvider);
  return repo.getOccupancy();
});

final pendingVisitorsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  final repo = ref.read(visitorRepositoryProvider);
  return repo.getPendingVisitors();
});

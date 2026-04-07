import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/visitor_repository.dart';
import '../data/datasources/mock/mock_visitor_datasource.dart';

final visitorRepositoryProvider = Provider<VisitorRepository>((ref) {
  return MockVisitorDatasource();
});

final activeVisitorsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) {
  final repo = ref.read(visitorRepositoryProvider);
  return repo.getActiveVisitors();
});

final visitorLogProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) {
  final repo = ref.read(visitorRepositoryProvider);
  return repo.getVisitorLog();
});

final occupancyProvider = FutureProvider<Map<String, dynamic>>((ref) {
  final repo = ref.read(visitorRepositoryProvider);
  return repo.getOccupancy();
});

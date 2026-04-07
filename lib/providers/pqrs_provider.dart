import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/pqrs_repository.dart';
import '../data/datasources/mock/mock_pqrs_datasource.dart';

final pqrsRepositoryProvider = Provider<PqrsRepository>((ref) {
  return MockPqrsDatasource();
});

/// Provides all PQRS items (no filter).
final allPqrsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) {
  final repo = ref.read(pqrsRepositoryProvider);
  return repo.getAll();
});

/// Provides PQRS filtered by status.
final pqrsByStatusProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String?>((ref, status) {
  final repo = ref.read(pqrsRepositoryProvider);
  return repo.getAll(status: status);
});

/// Provides PQRS filtered by type.
final pqrsByTypeProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String?>((ref, type) {
  final repo = ref.read(pqrsRepositoryProvider);
  return repo.getAll(type: type);
});

/// Provides a single PQRS by ID.
final pqrsByIdProvider =
    FutureProvider.family<Map<String, dynamic>?, String>((ref, id) {
  final repo = ref.read(pqrsRepositoryProvider);
  return repo.getById(id);
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/condo_repository.dart';
import '../data/datasources/api/api_condo_datasource.dart';

final condoRepositoryProvider = Provider<CondoRepository>((ref) {
  return ApiCondoDatasource();
});

final featuredCondosProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) {
  final repo = ref.read(condoRepositoryProvider);
  return repo.getFeatured();
});

final condoSearchProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((ref, query) {
  final repo = ref.read(condoRepositoryProvider);
  return repo.search(query);
});

final condoByIdProvider =
    FutureProvider.family<Map<String, dynamic>?, String>((ref, id) {
  final repo = ref.read(condoRepositoryProvider);
  return repo.getById(id);
});

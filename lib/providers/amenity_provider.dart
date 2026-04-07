import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/amenity_repository.dart';
import '../data/datasources/mock/mock_amenity_datasource.dart';

final amenityRepositoryProvider = Provider<AmenityRepository>((ref) {
  return MockAmenityDatasource();
});

final amenitiesProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) {
  final repo = ref.read(amenityRepositoryProvider);
  return repo.getAmenities();
});

final amenityByIdProvider =
    FutureProvider.family<Map<String, dynamic>?, String>((ref, id) {
  final repo = ref.read(amenityRepositoryProvider);
  return repo.getAmenityById(id);
});

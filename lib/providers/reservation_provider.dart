import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/reservation_repository.dart';
import '../data/datasources/mock/mock_reservation_datasource.dart';

final reservationRepositoryProvider = Provider<ReservationRepository>((ref) {
  return MockReservationDatasource();
});

final upcomingReservationsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) {
  final repo = ref.read(reservationRepositoryProvider);
  return repo.getUpcoming();
});

final reservationHistoryProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) {
  final repo = ref.read(reservationRepositoryProvider);
  return repo.getHistory();
});

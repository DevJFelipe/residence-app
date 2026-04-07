import '../../repositories/reservation_repository.dart';

class MockReservationDatasource implements ReservationRepository {
  static const List<Map<String, dynamic>> _reservations = [
    {
      'id': 'res-001',
      'status': 'confirmada',
      'title': 'Salon Social',
      'date': '15 Oct, 2023',
      'time': '18:00 - 22:00',
      'image': 'assets/images/reserv_salon.png',
      'amenityId': 'amenity-2',
    },
    {
      'id': 'res-002',
      'status': 'pendiente',
      'title': 'Cancha de Tenis',
      'date': '18 Oct, 2023',
      'time': '07:00 - 09:00',
      'image': 'assets/images/reserv_tennis.png',
      'amenityId': 'amenity-3',
    },
    {
      'id': 'res-003',
      'status': 'finalizada',
      'title': 'Piscina Climatizada',
      'date': '10 Oct, 2023',
      'time': '14:00 - 16:00',
      'image': 'assets/images/reserv_pool.png',
      'amenityId': 'amenity-1',
    },
  ];

  @override
  Future<List<Map<String, dynamic>>> getUpcoming() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _reservations
        .where((r) => r['status'] != 'finalizada')
        .toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getHistory() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _reservations
        .where((r) => r['status'] == 'finalizada')
        .toList();
  }

  @override
  Future<Map<String, dynamic>> createReservation(
      Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'id': 'res-${DateTime.now().millisecondsSinceEpoch}',
      'status': 'pendiente',
      ...data,
    };
  }

  @override
  Future<List<Map<String, dynamic>>> getAvailableSlots(
      String amenityId, DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      {'startTime': '07:00', 'endTime': '09:00', 'isAvailable': true},
      {'startTime': '09:00', 'endTime': '11:00', 'isAvailable': true},
      {'startTime': '11:00', 'endTime': '13:00', 'isAvailable': false},
      {'startTime': '14:00', 'endTime': '16:00', 'isAvailable': true},
      {'startTime': '16:00', 'endTime': '18:00', 'isAvailable': true},
      {'startTime': '18:00', 'endTime': '20:00', 'isAvailable': false},
      {'startTime': '20:00', 'endTime': '22:00', 'isAvailable': true},
    ];
  }
}

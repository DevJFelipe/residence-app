abstract class ReservationRepository {
  /// Returns upcoming reservations.
  /// Each map has: 'id', 'status' (confirmada|pendiente|finalizada),
  /// 'title', 'date', 'time', 'image'
  Future<List<Map<String, dynamic>>> getUpcoming();

  /// Returns past/history reservations.
  Future<List<Map<String, dynamic>>> getHistory();

  /// Creates a new reservation. Returns the created reservation map.
  Future<Map<String, dynamic>> createReservation(Map<String, dynamic> data);

  /// Returns available time slots for an amenity on a given date.
  /// Each map has: 'startTime', 'endTime', 'isAvailable'
  Future<List<Map<String, dynamic>>> getAvailableSlots(
      String amenityId, DateTime date);
}

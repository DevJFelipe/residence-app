abstract class VisitorRepository {
  /// Returns currently active visitors.
  /// Each map has: 'name', 'location', 'time', 'iconAsset'
  Future<List<Map<String, dynamic>>> getActiveVisitors();

  /// Returns visitor log entries for the day.
  /// Each map has: 'name', 'subtitle', 'unit', 'entryTime', 'exitTime'
  Future<List<Map<String, dynamic>>> getVisitorLog();

  /// Returns occupancy data.
  /// Map has: 'current' (int), 'max' (int)
  Future<Map<String, dynamic>> getOccupancy();

  /// Registers a new visitor entry.
  Future<void> registerEntry(Map<String, dynamic> visitor);

  /// Registers a visitor exit by visitor ID.
  Future<void> registerExit(String visitorId);

  /// Returns pre-registered visitors (pending confirmation).
  Future<List<Map<String, dynamic>>> getPendingVisitors();

  /// Confirms a pre-registered visitor's entry.
  Future<void> confirmEntry(String visitorId);
}

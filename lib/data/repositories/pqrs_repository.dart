abstract class PqrsRepository {
  /// Returns all PQRS, optionally filtered by status and/or type.
  /// Each map has: 'id', 'type' (peticion|queja|reclamo|sugerencia),
  /// 'status' (abierto|en_proceso|resuelto|cerrado), 'priority' (alta|media|baja),
  /// 'title', 'description', 'createdAt', 'updatedAt', 'unit', 'residentName'
  Future<List<Map<String, dynamic>>> getAll({String? status, String? type});

  /// Returns a single PQRS by ID, or null if not found.
  Future<Map<String, dynamic>?> getById(String id);

  /// Creates a new PQRS. Returns the created entry.
  Future<Map<String, dynamic>> create(Map<String, dynamic> data);

  /// Updates the status of a PQRS.
  Future<void> updateStatus(String id, String status);
}

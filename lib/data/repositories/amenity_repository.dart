abstract class AmenityRepository {
  /// Returns all amenities.
  /// Each map has: 'id', 'image', 'title', 'capacity', 'description',
  /// 'status' (disponible|mantenimiento)
  Future<List<Map<String, dynamic>>> getAmenities();

  /// Returns a single amenity by ID, or null if not found.
  Future<Map<String, dynamic>?> getAmenityById(String id);
}

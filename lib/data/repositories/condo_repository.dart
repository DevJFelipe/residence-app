abstract class CondoRepository {
  /// Returns featured condos.
  /// Each map has: 'id', 'name', 'location', 'image', 'towers', 'units',
  /// 'estrato', 'address', 'locality', 'amenities', 'news', 'contact'
  Future<List<Map<String, dynamic>>> getFeatured();

  /// Searches condos by query string.
  Future<List<Map<String, dynamic>>> search(String query);

  /// Returns a single condo by ID, or null if not found.
  Future<Map<String, dynamic>?> getById(String id);
}

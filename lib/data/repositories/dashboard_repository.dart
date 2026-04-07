abstract class DashboardRepository {
  /// Returns list of stat cards data.
  /// Each map has: 'iconAsset', 'label', 'value', 'changeText', 'isPositive'
  Future<List<Map<String, dynamic>>> getStats();

  /// Returns recent activity items.
  /// Each map has: 'iconBackground' (int color), 'iconAsset', 'title', 'time'
  Future<List<Map<String, dynamic>>> getRecentActivity();

  /// Returns recent visitors currently on site.
  /// Each map has: 'name', 'destination', 'time', 'type', 'typeBadgeColor', 'typeBadgeTextColor'
  Future<List<Map<String, dynamic>>> getRecentVisitors();

  /// Returns collections chart data.
  /// Each map has: 'month', 'collected' (double 0-1), 'projected' (double 0-1)
  Future<List<Map<String, dynamic>>> getCollectionsData();
}

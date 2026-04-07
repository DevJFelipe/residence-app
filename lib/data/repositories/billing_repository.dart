abstract class BillingRepository {
  /// Returns paginated invoices, optionally filtered by status.
  /// Each map has: 'unit', 'residentName', 'initials', 'concept', 'amount',
  /// 'dueDate', 'status' (pagado|pendiente|vencido), 'isOverdueHighlight'
  Future<List<Map<String, dynamic>>> getInvoices({String? status, int page = 1});

  /// Returns billing summary data.
  /// Map has: 'collected', 'expected', 'percentage' (double), 'period', 'remaining'
  Future<Map<String, dynamic>> getSummary();

  /// Generates invoices for the current period.
  Future<void> generateInvoices();

  /// Exports billing report.
  Future<void> exportReport();
}

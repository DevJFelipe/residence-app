import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/billing_repository.dart';
import '../data/datasources/mock/mock_billing_datasource.dart';

final billingRepositoryProvider = Provider<BillingRepository>((ref) {
  return MockBillingDatasource();
});

/// Provides all invoices (no filter). Use the family variant for filtered results.
final invoicesProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) {
  final repo = ref.read(billingRepositoryProvider);
  return repo.getInvoices();
});

/// Provides invoices filtered by status.
final filteredInvoicesProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String?>((ref, status) {
  final repo = ref.read(billingRepositoryProvider);
  return repo.getInvoices(status: status);
});

final billingSummaryProvider = FutureProvider<Map<String, dynamic>>((ref) {
  final repo = ref.read(billingRepositoryProvider);
  return repo.getSummary();
});

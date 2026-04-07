import '../../repositories/billing_repository.dart';

class MockBillingDatasource implements BillingRepository {
  static const List<Map<String, dynamic>> _allInvoices = [
    {
      'id': 'inv-001',
      'unit': 'Apto 201',
      'residentName': 'Carlos Mendoza',
      'initials': 'CM',
      'concept': 'Adm. Octubre',
      'amount': '\$350.000',
      'amountRaw': 350000,
      'dueDate': '15 Oct 2023',
      'status': 'pagado',
      'isOverdueHighlight': false,
    },
    {
      'id': 'inv-002',
      'unit': 'Casa 12',
      'residentName': 'Andrea Duarte',
      'initials': 'AD',
      'concept': 'Adm. Octubre',
      'amount': '\$1.250.000',
      'amountRaw': 1250000,
      'dueDate': '30 Oct 2023',
      'status': 'pendiente',
      'isOverdueHighlight': false,
    },
    {
      'id': 'inv-003',
      'unit': 'Torre 4 - 802',
      'residentName': 'Roberto Rojas',
      'initials': 'RR',
      'concept': 'Extra. Fachada',
      'amount': '\$600.000',
      'amountRaw': 600000,
      'dueDate': '10 Oct 2023',
      'status': 'vencido',
      'isOverdueHighlight': true,
    },
    {
      'id': 'inv-004',
      'unit': 'Apto 505',
      'residentName': 'Luis Fernando P.',
      'initials': 'LF',
      'concept': 'Adm. Octubre',
      'amount': '\$350.000',
      'amountRaw': 350000,
      'dueDate': '15 Oct 2023',
      'status': 'pagado',
      'isOverdueHighlight': false,
    },
  ];

  @override
  Future<List<Map<String, dynamic>>> getInvoices({
    String? status,
    int page = 1,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    var filtered = _allInvoices;
    if (status != null && status.isNotEmpty) {
      filtered = filtered.where((inv) => inv['status'] == status).toList();
    }
    return List.from(filtered);
  }

  @override
  Future<Map<String, dynamic>> getSummary() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'collected': '\$850.000.000',
      'collectedRaw': 850000000,
      'expected': '\$1.250.000.000',
      'expectedRaw': 1250000000,
      'percentage': 0.68,
      'period': 'Octubre 2023',
      'remaining': '\$400.000.000',
    };
  }

  @override
  Future<void> generateInvoices() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  Future<void> exportReport() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }
}

import '../../repositories/dashboard_repository.dart';

class MockDashboardDatasource implements DashboardRepository {
  @override
  Future<List<Map<String, dynamic>>> getStats() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      {
        'iconAsset': 'assets/icons/stat_units.svg',
        'iconWidth': 34.0,
        'iconHeight': 34.0,
        'label': 'Total Unidades',
        'value': '240',
        'changeText': '+2%',
        'isPositive': true,
      },
      {
        'iconAsset': 'assets/icons/stat_residents.svg',
        'iconWidth': 38.0,
        'iconHeight': 32.0,
        'label': 'Residentes Activos',
        'value': '856',
        'changeText': '+5%',
        'isPositive': true,
      },
      {
        'iconAsset': 'assets/icons/stat_payments.svg',
        'iconWidth': 35.0,
        'iconHeight': 34.0,
        'label': 'Pagos Pendientes',
        'value': '\$12.4M',
        'changeText': '-8%',
        'isPositive': false,
      },
      {
        'iconAsset': 'assets/icons/stat_pqrs.svg',
        'iconWidth': 20.0,
        'iconHeight': 34.0,
        'label': 'PQRS Abiertos',
        'value': '14',
        'changeText': '-12%',
        'isPositive': false,
      },
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> getRecentActivity() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      {
        'iconBackground': 0xFFDCFCE7, // activityPaymentBg
        'iconAsset': 'assets/icons/activity_payment.svg',
        'iconSize': 11.667,
        'title': 'Pago Recibido - Apto 402',
        'time': 'Hace 15 min',
      },
      {
        'iconBackground': 0xFFDBEAFE, // activityVisitorBg
        'iconAsset': 'assets/icons/activity_visitor.svg',
        'iconSize': 9.333,
        'title': 'Visitante Registrado - Torre B',
        'time': 'Hace 45 min',
      },
      {
        'iconBackground': 0xFFFEF3C7, // activityPqrsBg
        'iconAsset': 'assets/icons/activity_pqrs.svg',
        'iconSize': 10.5,
        'title': 'Nueva PQRS - Daño Ascensor',
        'time': 'Hace 2 horas',
      },
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> getRecentVisitors() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      {
        'name': 'Carlos Ruiz',
        'destination': 'Apto 501-A',
        'time': '02:45 PM',
        'type': 'DOMICILIO',
        'typeBadgeColor': 0xFFDCFCE7,
        'typeBadgeTextColor': 0xFF047857,
      },
      {
        'name': 'Ana Martinez',
        'destination': 'Apto 203-B',
        'time': '03:12 PM',
        'type': 'FAMILIAR',
        'typeBadgeColor': 0xFFDBEAFE,
        'typeBadgeTextColor': 0xFF1D4ED8,
      },
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> getCollectionsData() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      {'month': 'Ene', 'collected': 0.55, 'projected': 0.65},
      {'month': 'Feb', 'collected': 0.70, 'projected': 0.80},
      {'month': 'Mar', 'collected': 0.60, 'projected': 0.70},
      {'month': 'Abr', 'collected': 0.75, 'projected': 0.85},
      {'month': 'May', 'collected': 0.85, 'projected': 0.95},
      {'month': 'Jun', 'collected': 0.0, 'projected': 0.0},
    ];
  }
}

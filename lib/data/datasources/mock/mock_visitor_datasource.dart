import '../../repositories/visitor_repository.dart';

class MockVisitorDatasource implements VisitorRepository {
  final List<Map<String, dynamic>> _activeVisitors = [
    {
      'id': 'v1',
      'name': 'Ricardo Montaner',
      'location': 'Torre A - 402',
      'time': '12:15 PM',
      'iconAsset': 'assets/icons/visitor_person.svg',
      'iconWidth': 18.0,
      'iconHeight': 16.0,
    },
    {
      'id': 'v2',
      'name': 'Elena Martinez',
      'location': 'Casa 15',
      'time': '01:45 PM',
      'iconAsset': 'assets/icons/visitor_person_female.svg',
      'iconWidth': 16.0,
      'iconHeight': 16.0,
    },
    {
      'id': 'v3',
      'name': 'Carlos Vives',
      'location': 'Torre C - 105',
      'time': '02:05 PM',
      'iconAsset': 'assets/icons/visitor_person.svg',
      'iconWidth': 18.0,
      'iconHeight': 16.0,
    },
    {
      'id': 'v4',
      'name': 'Rappi #4421',
      'location': 'Torre B - 901',
      'time': '02:22 PM',
      'iconAsset': 'assets/icons/visitor_delivery.svg',
      'iconWidth': 20.0,
      'iconHeight': 14.0,
    },
  ];

  @override
  Future<List<Map<String, dynamic>>> getActiveVisitors() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_activeVisitors);
  }

  @override
  Future<List<Map<String, dynamic>>> getVisitorLog() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      {
        'name': 'Ana Gabriela Lopez',
        'subtitle': 'ID: 10,234,556',
        'unit': 'Apto 502-A',
        'entryTime': '08:30 AM',
        'exitTime': '09:45 AM',
      },
      {
        'name': 'Servicios Electricos S.A.',
        'subtitle': 'Mantenimiento',
        'unit': 'Areas Comunes',
        'entryTime': '07:15 AM',
        'exitTime': '11:20 AM',
      },
      {
        'name': 'Javier Soto',
        'subtitle': 'ID: 8,990,221',
        'unit': 'Casa 22',
        'entryTime': '10:05 AM',
        'exitTime': '11:55 AM',
      },
    ];
  }

  @override
  Future<Map<String, dynamic>> getOccupancy() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return {
      'current': 12,
      'max': 30,
    };
  }

  @override
  Future<void> registerEntry(Map<String, dynamic> visitor) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _activeVisitors.add({
      'id': 'v${DateTime.now().millisecondsSinceEpoch}',
      ...visitor,
    });
  }

  @override
  Future<void> registerExit(String visitorId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _activeVisitors.removeWhere((v) => v['id'] == visitorId);
  }
}

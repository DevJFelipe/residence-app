import '../../repositories/pqrs_repository.dart';

class MockPqrsDatasource implements PqrsRepository {
  final List<Map<String, dynamic>> _items = [
    {
      'id': 'pqrs-001',
      'type': 'queja',
      'status': 'abierto',
      'priority': 'alta',
      'title': 'Dano en ascensor Torre 2',
      'description':
          'El ascensor del edificio Torre 2 lleva 3 dias fuera de servicio. Los residentes de pisos altos estan muy afectados.',
      'createdAt': '2023-10-12T08:30:00',
      'updatedAt': '2023-10-12T08:30:00',
      'unit': 'Apto 1201',
      'residentName': 'Maria Gonzalez',
    },
    {
      'id': 'pqrs-002',
      'type': 'peticion',
      'status': 'en_proceso',
      'priority': 'media',
      'title': 'Solicitud de parqueadero adicional',
      'description':
          'Solicito la asignacion de un segundo parqueadero para mi unidad, dado que tenemos dos vehiculos registrados.',
      'createdAt': '2023-10-10T14:15:00',
      'updatedAt': '2023-10-11T09:00:00',
      'unit': 'Casa 8',
      'residentName': 'Pedro Alvarez',
    },
    {
      'id': 'pqrs-003',
      'type': 'reclamo',
      'status': 'abierto',
      'priority': 'alta',
      'title': 'Filtracion de agua en techo',
      'description':
          'Desde la semana pasada se presenta una filtracion de agua en el techo del apartamento, proveniente del piso superior.',
      'createdAt': '2023-10-11T10:00:00',
      'updatedAt': '2023-10-11T10:00:00',
      'unit': 'Torre 3 - 502',
      'residentName': 'Laura Betancourt',
    },
    {
      'id': 'pqrs-004',
      'type': 'sugerencia',
      'status': 'resuelto',
      'priority': 'baja',
      'title': 'Mejorar iluminacion del parqueadero',
      'description':
          'Sugiero instalar luces LED en la zona del sotano 2 del parqueadero, ya que actualmente es muy oscuro.',
      'createdAt': '2023-10-05T16:45:00',
      'updatedAt': '2023-10-09T11:30:00',
      'unit': 'Apto 301-B',
      'residentName': 'Andres Ramirez',
    },
    {
      'id': 'pqrs-005',
      'type': 'queja',
      'status': 'cerrado',
      'priority': 'media',
      'title': 'Ruido excesivo en horario nocturno',
      'description':
          'Se reportan fiestas con musica a alto volumen en el apartamento 803 de la Torre 1, despues de las 10 PM.',
      'createdAt': '2023-10-01T22:00:00',
      'updatedAt': '2023-10-06T14:00:00',
      'unit': 'Torre 1 - 702',
      'residentName': 'Carolina Duque',
    },
    {
      'id': 'pqrs-006',
      'type': 'peticion',
      'status': 'en_proceso',
      'priority': 'baja',
      'title': 'Instalacion de estacion de bicicletas',
      'description':
          'Solicito que se instale una estacion de parqueo de bicicletas en la entrada principal del conjunto.',
      'createdAt': '2023-10-08T09:20:00',
      'updatedAt': '2023-10-10T15:45:00',
      'unit': 'Apto 405',
      'residentName': 'Felipe Torres',
    },
  ];

  @override
  Future<List<Map<String, dynamic>>> getAll({
    String? status,
    String? type,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    var filtered = List<Map<String, dynamic>>.from(_items);
    if (status != null && status.isNotEmpty) {
      filtered = filtered.where((item) => item['status'] == status).toList();
    }
    if (type != null && type.isNotEmpty) {
      filtered = filtered.where((item) => item['type'] == type).toList();
    }
    return filtered;
  }

  @override
  Future<Map<String, dynamic>?> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _items.firstWhere((item) => item['id'] == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newItem = {
      'id': 'pqrs-${DateTime.now().millisecondsSinceEpoch}',
      'status': 'abierto',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      ...data,
    };
    _items.insert(0, newItem);
    return newItem;
  }

  @override
  Future<void> updateStatus(String id, String status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _items.indexWhere((item) => item['id'] == id);
    if (index != -1) {
      _items[index] = {
        ..._items[index],
        'status': status,
        'updatedAt': DateTime.now().toIso8601String(),
      };
    }
  }
}

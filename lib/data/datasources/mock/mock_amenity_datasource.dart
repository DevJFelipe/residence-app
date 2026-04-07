import '../../repositories/amenity_repository.dart';

class MockAmenityDatasource implements AmenityRepository {
  static const List<Map<String, dynamic>> _amenities = [
    {
      'id': 'amenity-1',
      'image': 'assets/images/area_pool.png',
      'title': 'Piscina climatizada',
      'capacity': 'Capacidad: 20 personas',
      'capacityNumber': 20,
      'description':
          'Disfruta de una temperatura ideal todo el ano en nuestra piscina cubierta con sistema de calefaccion ecologico.',
      'status': 'disponible',
    },
    {
      'id': 'amenity-2',
      'image': 'assets/images/area_salon.png',
      'title': 'Salon social',
      'capacity': 'Capacidad: 50 personas',
      'capacityNumber': 50,
      'description':
          'Espacio amplio y elegante equipado con mobiliario moderno para tus eventos y celebraciones mas especiales.',
      'status': 'disponible',
    },
    {
      'id': 'amenity-3',
      'image': 'assets/images/area_tennis.png',
      'title': 'Cancha de tenis',
      'capacity': 'Capacidad: 4 personas',
      'capacityNumber': 4,
      'description':
          'Cancha de polvo de ladrillo reglamentaria con iluminacion nocturna. Actualmente en adecuacion de drenaje.',
      'status': 'mantenimiento',
    },
    {
      'id': 'amenity-4',
      'image': 'assets/images/area_bbq.png',
      'title': 'Zona BBQ',
      'capacity': 'Capacidad: 12 personas',
      'capacityNumber': 12,
      'description':
          'Area campestre equipada con parrilla profesional y zona de comedor al aire libre rodeada de jardines.',
      'status': 'disponible',
    },
    {
      'id': 'amenity-5',
      'image': 'assets/images/area_gym.png',
      'title': 'Gimnasio',
      'capacity': 'Capacidad: 8 personas',
      'capacityNumber': 8,
      'description':
          'Equipamiento de ultima generacion para cardio y fuerza, con aire acondicionado y vista al parque central.',
      'status': 'disponible',
    },
  ];

  @override
  Future<List<Map<String, dynamic>>> getAmenities() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_amenities);
  }

  @override
  Future<Map<String, dynamic>?> getAmenityById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _amenities.firstWhere((a) => a['id'] == id);
    } catch (_) {
      return null;
    }
  }
}

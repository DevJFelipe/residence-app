import '../../repositories/condo_repository.dart';

class MockCondoDatasource implements CondoRepository {
  static const List<Map<String, dynamic>> _condos = [
    {
      'id': 'condo-001',
      'name': 'Conjunto Residencial El Nogal',
      'location': 'Bogota, Colombia',
      'image': 'assets/images/profile_hero.png',
      'towers': 5,
      'units': 240,
      'estrato': 5,
      'address': 'Calle 100 #15-30',
      'locality': 'Localidad de Usaquen, Bogota',
      'amenities': [
        {'icon': 'assets/icons/prof_pool.svg', 'label': 'Piscina Climatizada'},
        {'icon': 'assets/icons/prof_gym.svg', 'label': 'Gimnasio'},
        {'icon': 'assets/icons/prof_bbq.svg', 'label': 'Zona BBQ'},
        {
          'icon': 'assets/icons/prof_playground.svg',
          'label': 'Parque Infantil'
        },
        {'icon': 'assets/icons/prof_visitors.svg', 'label': 'Visitantes'},
        {
          'icon': 'assets/icons/prof_security.svg',
          'label': 'Vigilancia 24/7'
        },
      ],
      'news': [
        {
          'type': 'mantenimiento',
          'time': 'Hoy',
          'title': 'Cierre temporal de ascensores Torre 2',
          'body':
              'Se realizara mantenimiento preventivo desde las 10:00 AM hasta las 2:00 PM.',
        },
        {
          'type': 'comunidad',
          'time': 'Ayer',
          'title': 'Nueva jornada de reciclaje',
          'body':
              'Acompananos este sabado en el salon comunal para aprender sobre separacion de residuos.',
        },
      ],
      'contact': {
        'phone': '+57 601 234 5678',
        'phoneLabel': 'Porteria Principal',
        'email': 'elnogal@residence.com',
        'emailLabel': 'Administracion',
        'hours': 'Lun - Vie: 8:00 AM - 5:00 PM',
        'hoursLabel': 'Horarios de Oficina',
      },
    },
  ];

  @override
  Future<List<Map<String, dynamic>>> getFeatured() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_condos);
  }

  @override
  Future<List<Map<String, dynamic>>> search(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final lowerQuery = query.toLowerCase();
    return _condos
        .where((c) =>
            (c['name'] as String).toLowerCase().contains(lowerQuery) ||
            (c['location'] as String).toLowerCase().contains(lowerQuery))
        .toList();
  }

  @override
  Future<Map<String, dynamic>?> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _condos.firstWhere((c) => c['id'] == id);
    } catch (_) {
      return null;
    }
  }
}

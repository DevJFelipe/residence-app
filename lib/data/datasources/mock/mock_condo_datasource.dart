import '../../repositories/condo_repository.dart';

class MockCondoDatasource implements CondoRepository {
  static const List<Map<String, dynamic>> _condos = [
    {
      'id': 'condo-001',
      'name': 'C.R. El Nogal',
      'location': 'Bogotá, Norte',
      'image': 'assets/images/condo1.png',
      'towers': 5,
      'units': 240,
      'estrato': 5,
      'address': 'Calle 100 #15-30',
      'locality': 'Localidad de Usaquén, Bogotá',
      'amenities': [
        {'icon': 'assets/icons/prof_pool.svg', 'label': 'Piscina Climatizada'},
        {'icon': 'assets/icons/prof_gym.svg', 'label': 'Gimnasio'},
        {'icon': 'assets/icons/prof_bbq.svg', 'label': 'Zona BBQ'},
        {'icon': 'assets/icons/prof_playground.svg', 'label': 'Parque Infantil'},
        {'icon': 'assets/icons/prof_visitors.svg', 'label': 'Visitantes'},
        {'icon': 'assets/icons/prof_security.svg', 'label': 'Vigilancia 24/7'},
      ],
      'news': [
        {
          'type': 'mantenimiento',
          'time': 'Hoy',
          'title': 'Cierre temporal de ascensores Torre 2',
          'body':
              'Se realizará mantenimiento preventivo desde las 10:00 AM hasta las 2:00 PM.',
        },
        {
          'type': 'comunidad',
          'time': 'Ayer',
          'title': 'Nueva jornada de reciclaje',
          'body':
              'Acompáñanos este sábado en el salón comunal para aprender sobre separación de residuos.',
        },
      ],
      'contact': {
        'phone': '+57 601 234 5678',
        'phoneLabel': 'Portería Principal',
        'email': 'elnogal@residence.com',
        'emailLabel': 'Administración',
        'hours': 'Lun - Vie: 8:00 AM - 5:00 PM',
        'hoursLabel': 'Horarios de Oficina',
      },
    },
    {
      'id': 'condo-002',
      'name': 'Torres de Viento',
      'location': 'Medellín, Poblado',
      'image': 'assets/images/condo2.png',
      'towers': 3,
      'units': 180,
      'estrato': 6,
      'address': 'Cra 43A #1-50',
      'locality': 'El Poblado, Medellín',
      'amenities': [
        {'icon': 'assets/icons/prof_pool.svg', 'label': 'Piscina'},
        {'icon': 'assets/icons/prof_gym.svg', 'label': 'Gimnasio'},
        {'icon': 'assets/icons/prof_bbq.svg', 'label': 'Terraza BBQ'},
        {'icon': 'assets/icons/prof_security.svg', 'label': 'Vigilancia 24/7'},
      ],
      'news': [
        {
          'type': 'comunidad',
          'time': 'Hoy',
          'title': 'Asamblea general de copropietarios',
          'body':
              'Este viernes a las 7:00 PM en el salón comunal. Confirmá tu asistencia.',
        },
      ],
      'contact': {
        'phone': '+57 604 567 8901',
        'phoneLabel': 'Portería Principal',
        'email': 'torresdeviento@residence.com',
        'emailLabel': 'Administración',
        'hours': 'Lun - Vie: 7:00 AM - 6:00 PM',
        'hoursLabel': 'Horarios de Oficina',
      },
    },
    {
      'id': 'condo-003',
      'name': 'Hacienda Real',
      'location': 'Chía, Cundinamarca',
      'image': 'assets/images/condo3.png',
      'towers': 8,
      'units': 320,
      'estrato': 4,
      'address': 'Km 2 Vía Chía-Cajicá',
      'locality': 'Chía, Cundinamarca',
      'amenities': [
        {'icon': 'assets/icons/prof_pool.svg', 'label': 'Piscina'},
        {'icon': 'assets/icons/prof_gym.svg', 'label': 'Gimnasio'},
        {'icon': 'assets/icons/prof_playground.svg', 'label': 'Parque Infantil'},
        {'icon': 'assets/icons/prof_bbq.svg', 'label': 'Zona BBQ'},
        {'icon': 'assets/icons/prof_visitors.svg', 'label': 'Salón Comunal'},
        {'icon': 'assets/icons/prof_security.svg', 'label': 'Vigilancia 24/7'},
      ],
      'news': [
        {
          'type': 'mantenimiento',
          'time': 'Ayer',
          'title': 'Fumigación zonas verdes',
          'body':
              'Se realizará fumigación el sábado de 6:00 AM a 10:00 AM. Favor no transitar por jardines.',
        },
      ],
      'contact': {
        'phone': '+57 601 890 1234',
        'phoneLabel': 'Portería Principal',
        'email': 'haciendareal@residence.com',
        'emailLabel': 'Administración',
        'hours': 'Lun - Sáb: 7:00 AM - 7:00 PM',
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

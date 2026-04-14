import 'package:dio/dio.dart';
import 'package:residence_app/core/api_client.dart';
import '../../repositories/condo_repository.dart';

class ApiCondoDatasource implements CondoRepository {
  final Dio _dio = ApiClient().dio;

  @override
  Future<List<Map<String, dynamic>>> getFeatured() async {
    final response = await _dio.get('/api/v1/condominiums/featured');
    final items = List<Map<String, dynamic>>.from(response.data['data']);
    return items.map(_mapCondo).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> search(String query) async {
    final all = await getFeatured();
    final lower = query.toLowerCase();
    return all.where((c) {
      final name = (c['name'] as String? ?? '').toLowerCase();
      final location = (c['location'] as String? ?? '').toLowerCase();
      return name.contains(lower) || location.contains(lower);
    }).toList();
  }

  @override
  Future<Map<String, dynamic>?> getById(String id) async {
    final all = await getFeatured();
    try {
      return all.firstWhere((c) => c['id'] == id);
    } catch (_) {
      return null;
    }
  }

  /// Maps the backend response to the format expected by the UI.
  Map<String, dynamic> _mapCondo(Map<String, dynamic> raw) {
    final city = raw['city'] ?? '';
    final department = raw['department'] ?? '';
    final location = department.isNotEmpty ? '$city, $department' : city;

    return {
      'id': raw['id']?.toString() ?? '',
      'name': raw['name'] ?? '',
      'location': location,
      'image': null, // No remote images yet — UI handles fallback
      'address': raw['address'] ?? '',
      'city': city,
      'department': department,
      'towers': raw['total_towers'] ?? 0,
      'units': raw['total_properties'] ?? 0,
      'estrato': raw['estrato'] ?? '-',
      'logo_url': raw['logo_url'],
    };
  }
}

import 'package:dio/dio.dart';
import 'package:residence_app/core/api_client.dart';

class ResidentsService {
  final Dio _dio = ApiClient().dio;

  /// List all properties for the current condominium.
  Future<List<Map<String, dynamic>>> getProperties() async {
    final response = await _dio.get('/api/v1/properties/', queryParameters: {
      'limit': 100,
    });
    return List<Map<String, dynamic>>.from(response.data['data']);
  }

  /// List residents assigned to a property.
  Future<List<Map<String, dynamic>>> getResidents(String propertyId) async {
    final response = await _dio.get(
      '/api/v1/properties/$propertyId/residents',
      queryParameters: {'active_only': true},
    );
    return List<Map<String, dynamic>>.from(response.data['data']);
  }

  /// Create a new user and assign to a property.
  Future<void> addResident({
    required String fullName,
    required String email,
    required String password,
    required String propertyId,
    required int relationTypeId,
    String? phone,
    String? documentNumber,
  }) async {
    // 1. Create user
    final userResponse = await _dio.post('/api/v1/users/', data: {
      'full_name': fullName,
      'email': email,
      'password': password,
      if (phone != null) 'phone': phone,
      if (documentNumber != null) 'document_number': documentNumber,
    });
    final userId = userResponse.data['data']['id'];

    // 2. Assign to property
    await _dio.post('/api/v1/properties/residents', data: {
      'user_id': userId,
      'property_id': propertyId,
      'relation_type_id': relationTypeId,
    });
  }

  /// List relation types from catalog.
  Future<List<Map<String, dynamic>>> getRelationTypes() async {
    final response = await _dio.get('/api/v1/catalogs/relation_types');
    return List<Map<String, dynamic>>.from(response.data['data']);
  }

  /// Parse error message from Dio response.
  static String parseError(DioException e) {
    if (e.response?.data is Map) {
      final error = e.response!.data['error'];
      if (error is Map && error['message'] != null) {
        return error['message'];
      }
    }
    if (e.type == DioExceptionType.connectionError) {
      return 'No se pudo conectar al servidor';
    }
    return 'Error inesperado';
  }
}

import 'package:dio/dio.dart';
import 'package:residence_app/core/api_client.dart';

class PqrsService {
  final Dio _dio = ApiClient().dio;

  Future<List<Map<String, dynamic>>> getPqrs({
    int? statusId,
    int? typeId,
    int skip = 0,
    int limit = 50,
  }) async {
    final params = <String, dynamic>{'skip': skip, 'limit': limit};
    if (statusId != null) params['status_id'] = statusId;
    if (typeId != null) params['type_id'] = typeId;
    final response =
        await _dio.get('/api/v1/pqrs/', queryParameters: params);
    return List<Map<String, dynamic>>.from(response.data['data']);
  }

  Future<Map<String, dynamic>> getPqr(String pqrId) async {
    final response = await _dio.get('/api/v1/pqrs/$pqrId');
    return Map<String, dynamic>.from(response.data['data']);
  }

  Future<List<Map<String, dynamic>>> getComments(String pqrId) async {
    final response = await _dio.get('/api/v1/pqrs/$pqrId/comments');
    return List<Map<String, dynamic>>.from(response.data['data']);
  }

  Future<List<Map<String, dynamic>>> getPqrTypes() async {
    final response = await _dio.get('/api/v1/catalogs/pqr-types');
    return List<Map<String, dynamic>>.from(response.data['data']);
  }

  Future<List<Map<String, dynamic>>> getPqrStatuses() async {
    final response = await _dio.get('/api/v1/catalogs/pqr-statuses');
    return List<Map<String, dynamic>>.from(response.data['data']);
  }

  Future<List<Map<String, dynamic>>> getPriorities() async {
    final response = await _dio.get('/api/v1/catalogs/priorities');
    return List<Map<String, dynamic>>.from(response.data['data']);
  }

  Future<Map<String, dynamic>> createPqr({
    required int pqrTypeId,
    required int priorityId,
    required String subject,
    required String description,
  }) async {
    final response = await _dio.post('/api/v1/pqrs/', data: {
      'pqr_type_id': pqrTypeId,
      'priority_id': priorityId,
      'subject': subject,
      'description': description,
    });
    return Map<String, dynamic>.from(response.data['data']);
  }

  Future<Map<String, dynamic>> updatePqr(String pqrId, {
    int? pqrStatusId,
    int? priorityId,
    String? resolution,
  }) async {
    final data = <String, dynamic>{};
    if (pqrStatusId != null) data['pqr_status_id'] = pqrStatusId;
    if (priorityId != null) data['priority_id'] = priorityId;
    if (resolution != null) data['resolution'] = resolution;
    final response = await _dio.patch('/api/v1/pqrs/$pqrId', data: data);
    return Map<String, dynamic>.from(response.data['data']);
  }

  Future<Map<String, dynamic>> addComment(String pqrId, String comment) async {
    final response = await _dio.post('/api/v1/pqrs/$pqrId/comments', data: {
      'comment': comment,
    });
    return Map<String, dynamic>.from(response.data['data']);
  }

  static String parseError(DioException e) {
    if (e.response?.data is Map) {
      final detail = e.response!.data['detail'];
      if (detail is String) return detail;
    }
    if (e.type == DioExceptionType.connectionError) {
      return 'No se pudo conectar al servidor';
    }
    return 'Error inesperado';
  }
}

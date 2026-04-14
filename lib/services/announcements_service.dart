import 'package:dio/dio.dart';
import 'package:residence_app/core/api_client.dart';

class AnnouncementsService {
  final Dio _dio = ApiClient().dio;

  Future<List<Map<String, dynamic>>> getAnnouncements() async {
    final response = await _dio.get('/api/v1/news/');
    return List<Map<String, dynamic>>.from(response.data['data']);
  }

  Future<Map<String, dynamic>> createAnnouncement({
    required String title,
    required String content,
    bool isPinned = false,
  }) async {
    final response = await _dio.post('/api/v1/news/', data: {
      'title': title,
      'content': content,
      'is_pinned': isPinned,
      'is_published': true,
    });
    return Map<String, dynamic>.from(response.data['data']);
  }

  Future<Map<String, dynamic>> updateAnnouncement(
    String id, {
    String? title,
    String? content,
    bool? isPinned,
  }) async {
    final data = <String, dynamic>{};
    if (title != null) data['title'] = title;
    if (content != null) data['content'] = content;
    if (isPinned != null) data['is_pinned'] = isPinned;
    final response = await _dio.patch('/api/v1/news/$id', data: data);
    return Map<String, dynamic>.from(response.data['data']);
  }

  Future<void> deleteAnnouncement(String id) async {
    await _dio.delete('/api/v1/news/$id');
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

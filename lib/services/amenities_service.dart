import 'package:dio/dio.dart';
import 'package:residence_app/core/api_client.dart';
import 'package:residence_app/models/amenity_models.dart';

class AmenitiesService {
  final Dio _dio = ApiClient().dio;

  Future<List<Amenity>> getAmenities() async {
    final response = await _dio.get('/api/v1/amenities/');
    final list = response.data['data'] as List;
    return list.map((e) => Amenity.fromJson(e)).toList();
  }

  Future<Amenity> getAmenity(int id) async {
    final response = await _dio.get('/api/v1/amenities/$id');
    return Amenity.fromJson(response.data['data']);
  }

  Future<Booking> createBooking({
    required int amenityId,
    required String propertyId,
    required DateTime startTime,
    required DateTime endTime,
    String? notes,
  }) async {
    final response = await _dio.post(
      '/api/v1/amenities/bookings',
      data: {
        'amenity_id': amenityId,
        'property_id': propertyId,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
        if (notes != null) 'notes': notes,
      },
    );
    return Booking.fromJson(response.data['data']);
  }

  Future<List<Booking>> getBookings({int? amenityId, int? statusId}) async {
    final params = <String, dynamic>{};
    if (amenityId != null) params['amenity_id'] = amenityId;
    if (statusId != null) params['status_id'] = statusId;
    final response = await _dio.get(
      '/api/v1/amenities/bookings/all',
      queryParameters: params,
    );
    final list = response.data['data'] as List;
    return list.map((e) => Booking.fromJson(e)).toList();
  }

  static String parseError(DioException e) {
    if (e.response?.data is Map) {
      final detail = e.response!.data['detail'];
      if (detail is String) return detail;
      final data = e.response!.data['data'];
      if (data is Map && data['message'] != null) return data['message'];
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.connectionError) {
      return 'No se pudo conectar al servidor';
    }
    return 'Error inesperado. Intente de nuevo.';
  }
}

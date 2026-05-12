import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:residence_app/core/api_client.dart';
import 'package:residence_app/models/amenity_models.dart';

class AmenitiesService {
  final Dio _dio = ApiClient().dio;

  static final ValueNotifier<int> bookingsChanged = ValueNotifier<int>(0);

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
        'start_time': _formatForApi(startTime),
        'end_time': _formatForApi(endTime),
        if (notes != null) 'notes': notes,
      },
    );
    bookingsChanged.value++;
    return Booking.fromJson(response.data['data']);
  }

  static String _formatForApi(DateTime dt) {
    final utc = dt.toUtc();
    String pad(int n) => n.toString().padLeft(2, '0');
    return '${utc.year}-${pad(utc.month)}-${pad(utc.day)}T'
        '${pad(utc.hour)}:${pad(utc.minute)}:${pad(utc.second)}';
  }

  Future<List<Booking>> getMyBookings({int? amenityId, int? statusId}) async {
    final params = <String, dynamic>{};
    if (amenityId != null) params['amenity_id'] = amenityId;
    if (statusId != null) params['status_id'] = statusId;
    final response = await _dio.get(
      '/api/v1/amenities/bookings/me',
      queryParameters: params,
    );
    final list = response.data['data'] as List;
    return list.map((e) => Booking.fromJson(e)).toList();
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

  Future<void> cancelBooking(String bookingId) async {
    await _dio.patch('/api/v1/amenities/bookings/$bookingId/cancel');
    bookingsChanged.value++;
  }

  static String parseError(DioException e) {
    if (e.response?.data is Map) {
      final body = e.response!.data as Map;
      final detail = body['detail'];
      if (detail is String) return detail;
      final error = body['error'];
      if (error is Map && error['message'] is String) return error['message'];
      final data = body['data'];
      if (data is Map && data['message'] is String) return data['message'];
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.connectionError) {
      return 'No se pudo conectar al servidor';
    }
    return 'Error inesperado. Intente de nuevo.';
  }
}

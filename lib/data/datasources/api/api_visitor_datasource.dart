import 'package:dio/dio.dart';
import 'package:residence_app/core/api_client.dart';
import '../../repositories/visitor_repository.dart';

class ApiVisitorDatasource implements VisitorRepository {
  final Dio _dio = ApiClient().dio;

  String _formatTime(String? isoTime) {
    if (isoTime == null) return '--';
    final dt = DateTime.parse(isoTime).toLocal();
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  String _formatTimeMultiline(String? isoTime) {
    if (isoTime == null) return '--';
    final dt = DateTime.parse(isoTime).toLocal();
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute\n$period';
  }

  @override
  Future<List<Map<String, dynamic>>> getActiveVisitors() async {
    final response = await _dio.get('/api/v1/visitors/active');
    final List data = response.data['data'];
    return data.map<Map<String, dynamic>>((v) {
      final bool isGuest = v['is_guest'] ?? false;
      final String notes = v['notes'] ?? '';
      final bool isDelivery = notes.toLowerCase().contains('domicilio') ||
          notes.toLowerCase().contains('delivery') ||
          notes.toLowerCase().contains('rappi');

      return {
        'id': v['id'],
        'name': v['visitor_name'] ?? '',
        'location': v['property_number'] != null
            ? 'Apto ${v['property_number']}'
            : '--',
        'time': _formatTime(v['entry_time']),
        'iconAsset': isDelivery
            ? 'assets/icons/visitor_delivery.svg'
            : isGuest
                ? 'assets/icons/visitor_person_female.svg'
                : 'assets/icons/visitor_person.svg',
        'iconWidth': isDelivery ? 20.0 : (isGuest ? 16.0 : 18.0),
        'iconHeight': isDelivery ? 14.0 : 16.0,
      };
    }).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getVisitorLog() async {
    final response = await _dio.get('/api/v1/visitors/', queryParameters: {
      'limit': 20,
    });
    final List data = response.data['data'];
    // Filter to only exited visitors for the log
    final exited = data.where((v) => v['exit_time'] != null).toList();
    return exited.map<Map<String, dynamic>>((v) {
      final docNumber = v['document_number'];
      final notes = v['notes'] ?? '';
      return {
        'name': (v['visitor_name'] ?? '').replaceAll(' ', '\n'),
        'subtitle': docNumber != null ? 'ID: $docNumber' : notes,
        'unit': v['property_number'] != null
            ? 'Apto\n${v['property_number']}'
            : '--',
        'entryTime': _formatTimeMultiline(v['entry_time']),
        'exitTime': _formatTimeMultiline(v['exit_time']),
      };
    }).toList();
  }

  @override
  Future<Map<String, dynamic>> getOccupancy() async {
    final response = await _dio.get('/api/v1/visitors/active');
    final List data = response.data['data'];
    return {
      'current': data.length,
      'max': 30, // TODO: get from condominium settings
    };
  }

  @override
  Future<void> registerEntry(Map<String, dynamic> visitor) async {
    await _dio.post('/api/v1/visitors/', data: {
      'property_id': visitor['property_id'],
      'visitor_name': visitor['name'],
      'document_number': visitor['document_number'],
      'vehicle_plate': visitor['vehicle_plate'],
      'is_guest': visitor['is_guest'] ?? false,
      'notes': visitor['notes'],
    });
  }

  @override
  Future<void> registerExit(String visitorId) async {
    await _dio.post('/api/v1/visitors/$visitorId/exit');
  }

  @override
  Future<List<Map<String, dynamic>>> getPendingVisitors() async {
    final response = await _dio.get('/api/v1/visitors/pending');
    final List data = response.data['data'];
    return data.map<Map<String, dynamic>>((v) {
      return {
        'id': v['id'],
        'name': v['visitor_name'] ?? '',
        'location': v['property_number'] != null
            ? 'Apto ${v['property_number']}'
            : '--',
        'authorized_by': v['authorized_by_name'] ?? '',
        'document': v['document_number'] ?? '',
        'vehicle': v['vehicle_plate'] ?? '',
        'notes': v['notes'] ?? '',
        'created_at': v['created_at'],
      };
    }).toList();
  }

  @override
  Future<void> confirmEntry(String visitorId) async {
    await _dio.post('/api/v1/visitors/$visitorId/confirm-entry');
  }
}

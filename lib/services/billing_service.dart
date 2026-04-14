import 'package:dio/dio.dart';
import 'package:residence_app/core/api_client.dart';

class BillingService {
  final Dio _dio = ApiClient().dio;

  Future<List<Map<String, dynamic>>> getInvoices({
    String? paymentStatusCode,
    int skip = 0,
    int limit = 50,
  }) async {
    final params = <String, dynamic>{'skip': skip, 'limit': limit};
    if (paymentStatusCode != null) {
      params['payment_status_code'] = paymentStatusCode;
    }
    final response = await _dio.get('/api/v1/finance/invoices',
        queryParameters: params);
    return List<Map<String, dynamic>>.from(response.data['data']);
  }

  Future<Map<String, dynamic>> getInvoice(String invoiceId) async {
    final response = await _dio.get('/api/v1/finance/invoices/$invoiceId');
    return Map<String, dynamic>.from(response.data['data']);
  }

  Future<List<Map<String, dynamic>>> getPayments(String invoiceId) async {
    final response =
        await _dio.get('/api/v1/finance/invoices/$invoiceId/payments');
    return List<Map<String, dynamic>>.from(response.data['data']);
  }

  Future<List<Map<String, dynamic>>> getChargeTypes() async {
    final response = await _dio.get('/api/v1/finance/charge-types');
    return List<Map<String, dynamic>>.from(response.data['data']);
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

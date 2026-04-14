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

  Future<Map<String, dynamic>> createInvoice({
    required String propertyId,
    required int chargeTypeId,
    required double amount,
    required String dueDate,
    String? billingPeriod,
    String? description,
  }) async {
    final response = await _dio.post('/api/v1/finance/invoices', data: {
      'property_id': propertyId,
      'charge_type_id': chargeTypeId,
      'amount': amount,
      'due_date': dueDate,
      if (billingPeriod != null) 'billing_period': billingPeriod,
      if (description != null) 'description': description,
    });
    return Map<String, dynamic>.from(response.data['data']);
  }

  Future<Map<String, dynamic>> registerPayment({
    required String invoiceId,
    required double amountPaid,
    required int paymentMethodId,
    String? reference,
    String? notes,
  }) async {
    final response = await _dio.post('/api/v1/finance/payments', data: {
      'invoice_id': invoiceId,
      'amount_paid': amountPaid,
      'payment_method_id': paymentMethodId,
      if (reference != null) 'reference': reference,
      if (notes != null) 'notes': notes,
    });
    return Map<String, dynamic>.from(response.data['data']);
  }

  Future<List<Map<String, dynamic>>> getPaymentMethods() async {
    final response = await _dio.get('/api/v1/catalogs/payment_methods');
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

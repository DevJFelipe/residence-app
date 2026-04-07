import 'package:dio/dio.dart';
import 'package:residence_app/core/api_client.dart';
import 'package:residence_app/models/dashboard_models.dart';

class DashboardService {
  final Dio _dio = ApiClient().dio;

  Future<DashboardSummary> getSummary() async {
    final response = await _dio.get('/api/v1/dashboard/summary');
    return DashboardSummary.fromJson(response.data['data']);
  }
}

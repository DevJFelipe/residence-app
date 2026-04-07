import 'package:dio/dio.dart';
import 'package:residence_app/core/api_client.dart';
import 'package:residence_app/core/session_manager.dart';
import 'package:residence_app/models/auth_models.dart';

class AuthService {
  final Dio _dio = ApiClient().dio;
  final SessionManager _session = SessionManager();

  /// Login with email + password. Returns [LoginResponse]
  /// with JWT token and user data.
  Future<LoginResponse> login(
    String email,
    String password,
  ) async {
    final response = await _dio.post(
      '/api/v1/auth/login',
      data: {'email': email, 'password': password},
    );
    final loginData =
        LoginResponse.fromJson(response.data['data']);

    await _session.saveSession(
      token: loginData.accessToken,
      user: loginData.toJson(),
    );

    return loginData;
  }

  /// Register a new user.
  Future<String> register({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  }) async {
    final response = await _dio.post(
      '/api/v1/auth/register',
      data: {
        'full_name': fullName,
        'email': email,
        'password': password,
        if (phone != null) 'phone': phone,
      },
    );
    return response.data['data']['message'];
  }

  /// Get current user profile.
  Future<LoginResponse> getMe() async {
    final response = await _dio.get('/api/v1/auth/me');
    return LoginResponse.fromJson(response.data['data']);
  }

  Future<void> logout() async {
    await _session.clear();
  }

  /// Parse a Dio error into a user-friendly message.
  static String parseError(DioException e) {
    if (e.response?.data is Map) {
      final error = e.response!.data['error'];
      if (error is Map && error['message'] != null) {
        return error['message'];
      }
      final data = e.response!.data['data'];
      if (data is Map && data['message'] != null) {
        return data['message'];
      }
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.connectionError) {
      return 'No se pudo conectar al servidor';
    }
    return 'Error inesperado. Intente de nuevo.';
  }
}

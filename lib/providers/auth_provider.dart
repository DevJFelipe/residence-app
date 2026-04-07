import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/session_manager.dart';
import '../data/repositories/auth_repository.dart';
import '../data/datasources/mock/mock_auth_datasource.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return MockAuthDatasource();
});

final authStateProvider =
    StateNotifierProvider<AuthNotifier, AuthStateData>((ref) {
  final notifier = AuthNotifier(ref.read(authRepositoryProvider));
  notifier.restoreSession();
  return notifier;
});

class AuthStateData {
  final bool isAuthenticated;
  final String? role;
  final String? email;
  final String? name;

  const AuthStateData({
    this.isAuthenticated = false,
    this.role,
    this.email,
    this.name,
  });

  AuthStateData copyWith({
    bool? isAuthenticated,
    String? role,
    String? email,
    String? name,
  }) =>
      AuthStateData(
        isAuthenticated: isAuthenticated ?? this.isAuthenticated,
        role: role ?? this.role,
        email: email ?? this.email,
        name: name ?? this.name,
      );
}

class AuthNotifier extends StateNotifier<AuthStateData> {
  final AuthRepository _repo;
  final SessionManager _session = SessionManager();

  AuthNotifier(this._repo) : super(const AuthStateData());

  /// Restore session from SharedPreferences on app start.
  Future<void> restoreSession() async {
    final user = await _session.getUser();
    final token = await _session.getToken();
    if (user != null && token != null) {
      final condominiums = user['condominiums'] as List?;
      String? role;
      if (condominiums != null && condominiums.isNotEmpty) {
        final roleName = condominiums[0]['role'] as String?;
        role = (roleName == 'admin' || roleName == 'super_admin')
            ? 'admin'
            : 'user';
      }
      state = AuthStateData(
        isAuthenticated: true,
        role: role,
        email: user['email'] as String?,
        name: user['full_name'] as String?,
      );
    }
  }

  /// Set authenticated state directly (used after real API login).
  void setAuthenticated({
    required String role,
    required String email,
    required String name,
  }) {
    state = AuthStateData(
      isAuthenticated: true,
      role: role,
      email: email,
      name: name,
    );
  }

  /// Validates email. Returns the user role on success, null on failure.
  Future<String?> login(String email) async {
    final result = await _repo.login(email);
    if (result == null) return null;
    return result['role'] as String?;
  }

  /// Verifies the PIN code. Returns true on success.
  Future<bool> verifyPin(String email, String pin) async {
    final result = await _repo.verifyPin(email, pin);
    if (result == null) return false;
    state = AuthStateData(
      isAuthenticated: true,
      role: result['role'] as String?,
      email: email,
      name: result['name'] as String?,
    );
    return true;
  }

  /// Logs out and resets state.
  Future<void> logout() async {
    await _repo.logout();
    await _session.clear();
    state = const AuthStateData();
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/auth_repository.dart';
import '../data/datasources/mock/mock_auth_datasource.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return MockAuthDatasource();
});

final authStateProvider =
    StateNotifierProvider<AuthNotifier, AuthStateData>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider));
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

  AuthNotifier(this._repo) : super(const AuthStateData());

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
    state = const AuthStateData();
  }
}

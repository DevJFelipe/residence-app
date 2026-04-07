import '../../repositories/auth_repository.dart';

class MockAuthDatasource implements AuthRepository {
  static const _testUsers = {
    'admin@residence.com': {
      'pin': '123456',
      'role': 'admin',
      'name': 'Administrador',
    },
    'residente@residence.com': {
      'pin': '111111',
      'role': 'user',
      'name': 'Juan Residente',
    },
  };

  @override
  Future<Map<String, dynamic>?> login(String email) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final normalizedEmail = email.trim().toLowerCase();
    final user = _testUsers[normalizedEmail];
    if (user == null) return null;
    return {
      'role': user['role'],
      'pin': user['pin'],
      'name': user['name'],
    };
  }

  @override
  Future<Map<String, dynamic>?> verifyPin(String email, String pin) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final normalizedEmail = email.trim().toLowerCase();
    final user = _testUsers[normalizedEmail];
    if (user == null || pin != user['pin']) return null;
    return {
      'role': user['role'],
      'name': user['name'],
      'email': normalizedEmail,
    };
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}

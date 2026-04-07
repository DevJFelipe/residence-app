abstract class AuthRepository {
  /// Validates if the email exists and returns user info map or null.
  /// Keys: 'role', 'pin'
  Future<Map<String, dynamic>?> login(String email);

  /// Verifies the PIN code for a given email.
  /// Returns user info map with 'role', 'name', 'email' on success, null on failure.
  Future<Map<String, dynamic>?> verifyPin(String email, String pin);

  /// Logs out the current user.
  Future<void> logout();
}

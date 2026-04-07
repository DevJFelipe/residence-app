import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  String? _cachedToken;
  Map<String, dynamic>? _cachedUser;

  Future<void> saveSession({
    required String token,
    required Map<String, dynamic> user,
  }) async {
    _cachedToken = token;
    _cachedUser = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, jsonEncode(user));
  }

  Future<String?> getToken() async {
    if (_cachedToken != null) return _cachedToken;
    final prefs = await SharedPreferences.getInstance();
    _cachedToken = prefs.getString(_tokenKey);
    return _cachedToken;
  }

  Future<Map<String, dynamic>?> getUser() async {
    if (_cachedUser != null) return _cachedUser;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_userKey);
    if (raw == null) return null;
    _cachedUser = jsonDecode(raw) as Map<String, dynamic>;
    return _cachedUser;
  }

  Future<bool> isLoggedIn() async {
    return (await getToken()) != null;
  }

  Future<void> clear() async {
    _cachedToken = null;
    _cachedUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }
}

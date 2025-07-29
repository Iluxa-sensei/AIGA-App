import 'package:flutter/foundation.dart';

/// Local-only Authentication service for AIGA Connect
/// Stores users in memory for local testing and development
class AuthService {
  final List<Map<String, dynamic>> _users = [];
  Map<String, dynamic>? _currentUser;

  /// Sign in with email and password
  Future<Map<String, dynamic>> signInWithPassword({
    required String email,
    required String password,
  }) async {
    final user = _users.firstWhere(
          (u) => u['email'] == email.trim().toLowerCase() && u['password'] == password,
      orElse: () => {},
    );

    if (user.isEmpty) {
      throw Exception('Неверный email или пароль');
    }

    _currentUser = user;

    if (kDebugMode) {
      debugPrint('✅ User signed in: ${user['email']}');
    }

    return user;
  }

  /// Sign up with email and password
  Future<Map<String, dynamic>> signUpWithPassword({
    required String email,
    required String password,
    required String fullName,
    String role = 'athlete',
    String? phone,
  }) async {
    final existing = _users.any((u) => u['email'] == email.trim().toLowerCase());

    if (existing) {
      throw Exception('Пользователь с таким email уже существует');
    }

    final newUser = {
      'email': email.trim().toLowerCase(),
      'password': password,
      'full_name': fullName.trim(),
      'role': role,
      'phone': phone?.trim(),
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
    };

    _users.add(newUser);
    _currentUser = newUser;

    if (kDebugMode) {
      debugPrint('✅ User signed up: ${newUser['email']}');
    }

    return newUser;
  }

  /// Sign out current user
  Future<void> signOut() async {
    if (_currentUser != null && kDebugMode) {
      debugPrint('✅ User signed out: ${_currentUser!['email']}');
    }
    _currentUser = null;
  }

  /// Reset password with email
  Future<void> resetPassword(String email) async {
    final user = _users.firstWhere(
          (u) => u['email'] == email.trim().toLowerCase(),
      orElse: () => {},
    );

    if (user.isEmpty) {
      throw Exception('Пользователь с таким email не найден');
    }

    if (kDebugMode) {
      debugPrint('✅ Password reset email (mock) sent to: $email');
    }
  }

  /// Get current user profile
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    return _currentUser;
  }

  /// Update current user profile
  Future<Map<String, dynamic>?> updateUserProfile(
      Map<String, dynamic> updates) async {
    if (_currentUser == null) {
      throw Exception('Нет авторизованного пользователя');
    }

    _currentUser!.addAll(updates);

    if (kDebugMode) {
      debugPrint('✅ User profile updated: ${_currentUser!['email']}');
    }

    return _currentUser;
  }

  /// Listen to authentication state changes (mocked as empty stream)
  Stream<Map<String, dynamic>?> get authStateStream async* {
    yield _currentUser;
  }

  /// Get current user (synchronous)
  Map<String, dynamic>? get currentUser => _currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated => _currentUser != null;

  /// Get current session (mocked)
  String? get currentSession => _currentUser != null ? "session_token_mock" : null;

  /// Convert AuthException to user-friendly message
  String getAuthErrorMessage(dynamic error) {
    return error.toString();
  }
}

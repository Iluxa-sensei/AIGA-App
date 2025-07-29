import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../models/user_profile.dart';
import '../../services/auth_service.dart';
import './widgets/biometric_auth_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/logo_widget.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  // Локальная "база пользователей"
  final Map<String, Map<String, dynamic>> _users = {
    'iluxa@gmail.com': {
      'password': '123456',
      'full_name': 'Iliuxa Test',
      'role': 'athlete',
    },
    // можешь добавить других пользователей здесь
  };

  Map<String, dynamic>? _currentUser;

  /// Войти по email и password
  Future<Map<String, dynamic>> signInWithPassword({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1)); // имитация запроса

    final user = _users[email.trim().toLowerCase()];

    if (user != null && user['password'] == password) {
      _currentUser = {
        'email': email.trim().toLowerCase(),
        'full_name': user['full_name'],
        'role': user['role'],
      };

      if (kDebugMode) {
        debugPrint('✅ User signed in: $email');
      }

      return _currentUser!;
    } else {
      if (kDebugMode) {
        debugPrint('❌ Sign-in failed for $email');
      }
      throw Exception('Неверный email или пароль');
    }
  }

  /// Получить текущий профиль пользователя
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _currentUser;
  }

  /// Проверка аутентификации
  bool get isAuthenticated => _currentUser != null;

  /// Преобразовать ошибки в человеко-читаемую строку
  String getAuthErrorMessage(dynamic error) {
    return error.toString().replaceAll('Exception: ', '');
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  bool _isBiometricAvailable = false;
  String? _errorMessage;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
    _checkExistingSession();
  }

  Future<void> _checkExistingSession() async {
    if (_authService.isAuthenticated) {
      _navigateToDashboard();
    }
  }

  Future<void> _checkBiometricAvailability() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _isBiometricAvailable = true;
    });
  }

  Future<void> _handleLogin(String email, String password) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await _authService.signInWithPassword(
        email: email,
        password: password,
      );

      if (user.isNotEmpty) {
        await _navigateToDashboard();
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = _authService.getAuthErrorMessage(error);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage!),
            backgroundColor: AppTheme.errorLight,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _navigateToDashboard() async {
    try {
      final profile = await _authService.getCurrentUserProfile();

      if (profile != null) {
        final userProfile = UserProfile.fromJson(profile);
        _navigateToRoleDashboard(userProfile.role);
      } else {
        _navigateToRoleDashboard(UserRole.athlete);
      }
    } catch (error) {
      _navigateToRoleDashboard(UserRole.athlete);
    }
  }

  void _navigateToRoleDashboard(UserRole role) {
    setState(() {
      _isLoading = false;
    });

    HapticFeedback.lightImpact();

    String route;
    switch (role) {
      case UserRole.athlete:
        route = '/athlete-dashboard';
        break;
      case UserRole.trainer:
        route = '/training-schedule';
        break;
      case UserRole.parent:
        route = '/progress-tracking';
        break;
      case UserRole.admin:
        route = '/merchandise-store';
        break;
    }

    Navigator.pushReplacementNamed(context, route);
  }

  Future<void> _handleBiometricAuth() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    HapticFeedback.lightImpact();
    Navigator.pushReplacementNamed(context, '/athlete-dashboard');
  }

  void _navigateToRegister() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Регистрация будет доступна в ближайшее время'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 8.h),

                  const LogoWidget(),

                  SizedBox(height: 6.h),

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.shadowLight,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Добро пожаловать!',
                          style: AppTheme.lightTheme.textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 1.h),

                        Text(
                          'Войдите в свой аккаунт',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 4.h),

                        LoginFormWidget(
                          onLogin: _handleLogin,
                          isLoading: _isLoading,
                        ),

                        BiometricAuthWidget(
                          onBiometricAuth: _handleBiometricAuth,
                          isAvailable: _isBiometricAvailable,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 4.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Новичок в AIGA? ',
                        style:
                        AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      TextButton(
                        onPressed: _navigateToRegister,
                        child: Text(
                          'Регистрация',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

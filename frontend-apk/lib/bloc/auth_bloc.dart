import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/validators.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../models/user.dart';

/// BLoC for handling authentication logic
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  static const String _userKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';

  AuthBloc() : super(const AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  /// Check if user is already logged in (on app start)
  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;

      if (isLoggedIn) {
        final userJson = prefs.getString(_userKey);
        if (userJson != null) {
          final user = User.fromJson(jsonDecode(userJson));
          emit(AuthAuthenticated(user: user));
        } else {
          emit(const AuthUnauthenticated());
        }
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: 'Failed to check auth status: ${e.toString()}'));
    }
  }

  /// Handler untuk proses login
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      // Validasi input
      final emailError = Validators.validateEmail(event.email);
      final passwordError = Validators.validatePassword(event.password);

      if (emailError != null || passwordError != null) {
        emit(AuthError(message: emailError ?? passwordError!));
        return;
      }

      // Simulasi API call
      await Future.delayed(const Duration(seconds: 1));

      final user = User(id: '123', email: event.email, name: 'User Demo');

      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(message: 'Login gagal: ${e.toString()}'));
    }
  }

  /// Handle registration request with validation
  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // Validate name
      final nameError = Validators.validateName(event.name);
      if (nameError != null) {
        emit(AuthError(message: nameError));
        return;
      }

      // Validate email
      final emailError = Validators.validateEmail(event.email);
      if (emailError != null) {
        emit(AuthError(message: emailError));
        return;
      }

      // Validate password
      final passwordError = Validators.validatePassword(event.password);
      if (passwordError != null) {
        emit(AuthError(message: passwordError));
        return;
      }

      // Validate confirm password
      final confirmPasswordError = Validators.validateConfirmPassword(
        event.password,
        event.confirmPassword,
      );
      if (confirmPasswordError != null) {
        emit(AuthError(message: confirmPasswordError));
        return;
      }

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock registration - In production, call actual API
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: event.email,
        name: event.name,
      );

      // Save to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_userKey, jsonEncode(user.toJson()));

      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(message: 'Registration failed: ${e.toString()}'));
    }
  }

  /// Handler untuk proses logout
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_isLoggedInKey); // Hapus flag login
      await prefs.remove(_userKey); // Hapus data user
      emit(const AuthUnauthenticated()); // Emit state keluar
    } catch (e) {
      emit(AuthError(message: 'Logout failed: ${e.toString()}'));
    }
  }
}

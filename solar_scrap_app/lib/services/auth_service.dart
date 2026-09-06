import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/registration_data.dart';

class AuthUser {
  final String userId;
  final String email;
  final String role;
  final String? displayName;
  final String? phoneNumber;

  AuthUser({
    required this.userId,
    required this.email,
    required this.role,
    this.displayName,
    this.phoneNumber,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      userId: json['user_id'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      displayName: json['display_name'],
      phoneNumber: json['phone_number'],
    );
  }
}

class AuthResult {
  final bool isSuccess;
  final String? message;
  final String? token;
  final AuthUser? user;
  final String? maskedPhone; // Added for register response

  AuthResult({
    required this.isSuccess,
    this.message,
    this.token,
    this.user,
    this.maskedPhone,
  });
}

class AuthService {
  static final AuthService instance = AuthService._internal();
  AuthService._internal();

  String? _accessToken;
  AuthUser? _currentUser;

  String? get accessToken => _accessToken;
  AuthUser? get currentUser => _currentUser;
  bool get isAuthenticated => _accessToken != null;

  Future<AuthResult> login({
    required String email,
    required String password,
    required String role,
  }) async {
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();

    if (trimmedEmail.isEmpty) {
      return AuthResult(isSuccess: false, message: 'Please enter your email or phone.');
    }
    if (trimmedPassword.isEmpty) {
      return AuthResult(isSuccess: false, message: 'Please enter your password.');
    }

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': trimmedEmail,
          'password': trimmedPassword,
          'role': role.toLowerCase(),
        }),
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _accessToken = data['access_token'];
        if (data['user'] != null) {
          _currentUser = AuthUser.fromJson(data['user']);
        }
        return AuthResult(
          isSuccess: true,
          token: _accessToken,
          user: _currentUser,
          message: data['message'] ?? 'Successfully signed in.',
        );
      } else {
        final errorDetail = data['detail'] ?? 'Sign in failed. Please try again.';
        return AuthResult(
          isSuccess: false,
          message: errorDetail,
        );
      }
    } catch (e) {
      return AuthResult(
        isSuccess: false,
        message: 'Could not connect to backend server. Ensure FastAPI and Firebase Emulator are running at ${ApiConfig.baseUrl}.',
      );
    }
  }

  Future<AuthResult> register(RegistrationData data) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/v1/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data.toJson()),
      ).timeout(const Duration(seconds: 15));

      final responseData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _accessToken = responseData['access_token'];
        if (responseData['user'] != null) {
          _currentUser = AuthUser.fromJson(responseData['user']);
        }
        return AuthResult(
          isSuccess: true,
          token: _accessToken,
          user: _currentUser,
          message: responseData['message'] ?? 'Successfully registered.',
          maskedPhone: responseData['masked_phone'],
        );
      } else {
        final errorDetail = responseData['detail'] ?? 'Registration failed. Please try again.';
        return AuthResult(
          isSuccess: false,
          message: errorDetail,
        );
      }
    } catch (e) {
      return AuthResult(
        isSuccess: false,
        message: 'Could not connect to backend server. Ensure FastAPI and Firebase Emulator are running at ${ApiConfig.baseUrl}.',
      );
    }
  }

  void logout() {
    _accessToken = null;
    _currentUser = null;
  }
}

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
  final String status;
  final String? companyName;
  final String? city;

  AuthUser({
    required this.userId,
    required this.email,
    required this.role,
    this.displayName,
    this.phoneNumber,
    this.status = 'approved',
    this.companyName,
    this.city,
  });

  bool get isApproved => status.toLowerCase() == 'approved';
  bool get isPending => status.toLowerCase() == 'pending';

  AuthUser copyWith({
    String? userId,
    String? email,
    String? role,
    String? displayName,
    String? phoneNumber,
    String? status,
    String? companyName,
    String? city,
  }) {
    return AuthUser(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      role: role ?? this.role,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
      companyName: companyName ?? this.companyName,
      city: city ?? this.city,
    );
  }

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      userId: json['user_id'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      displayName: json['display_name'],
      phoneNumber: json['phone_number'],
      status: json['status'] ?? 'pending',
      companyName: json['company_name'],
      city: json['city'],
    );
  }
}

class AuthResult {
  final bool isSuccess;
  final String? message;
  final String? token;
  final AuthUser? user;
  final String? maskedPhone;
  final String? status;
  final bool isPending;

  AuthResult({
    required this.isSuccess,
    this.message,
    this.token,
    this.user,
    this.maskedPhone,
    this.status,
    this.isPending = false,
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
          status: _currentUser?.status ?? 'approved',
          isPending: _currentUser?.isPending ?? false,
        );
      } else {
        final errorDetail = data['detail'];
        String msg = 'Sign in failed. Please try again.';
        String? stat;
        bool pending = false;
        if (errorDetail is Map) {
          msg = errorDetail['message'] ?? msg;
          stat = errorDetail['status'];
          pending = stat?.toLowerCase() == 'pending';
        } else if (errorDetail is String) {
          msg = errorDetail;
          if (msg.toLowerCase().contains('pending')) {
            stat = 'pending';
            pending = true;
          }
        }
        return AuthResult(
          isSuccess: false,
          message: msg,
          status: stat,
          isPending: pending,
        );
      }
    } catch (e) {
      return AuthResult(
        isSuccess: false,
        message: 'Could not connect to server at ${ApiConfig.baseUrl}. Please check your internet connection.',
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
          status: _currentUser?.status ?? 'pending',
          isPending: _currentUser?.isPending ?? true,
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
        message: 'Could not connect to server at ${ApiConfig.baseUrl}. Please check your internet connection.',
      );
    }
  }

  Future<Map<String, dynamic>> checkUserStatus({
    String? userId,
    String? email,
  }) async {
    try {
      final queryParams = <String, String>{};
      final uid = userId ?? _currentUser?.userId;
      final em = email ?? _currentUser?.email;
      if (uid != null && uid.isNotEmpty) queryParams['user_id'] = uid;
      if (em != null && em.isNotEmpty) queryParams['email'] = em;

      if (queryParams.isEmpty) return {'status': 'unknown'};

      final uri = Uri.parse('${ApiConfig.baseUrl}/api/v1/auth/user-status')
          .replace(queryParameters: queryParams);

      final response = await http.get(uri).timeout(const Duration(seconds: 5));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final newStatus = (data['status'] as String? ?? '').toLowerCase();
        if (_currentUser != null && newStatus.isNotEmpty) {
          _currentUser = _currentUser!.copyWith(
            status: newStatus,
            companyName: data['company_name'],
            city: data['city'],
          );
        }
        return data;
      }
    } catch (e) {
      // ignore
    }
    return {'status': 'unknown'};
  }

  void logout() {
    _accessToken = null;
    _currentUser = null;
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'email': email,
      'role': role,
      'display_name': displayName,
      'phone_number': phoneNumber,
      'status': status,
      'company_name': companyName,
      'city': city,
    };
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

  static const String _keyToken = 'solar_scrap_auth_token';
  static const String _keyUser = 'solar_scrap_auth_user';
  static const String _keyRole = 'solar_scrap_auth_role';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  String? _accessToken;
  AuthUser? _currentUser;

  String? get accessToken => _accessToken;
  AuthUser? get currentUser => _currentUser;
  bool get isAuthenticated => _accessToken != null && _currentUser != null;

  Future<void> _saveSession(String token, AuthUser user, String role) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyToken, token);
      await prefs.setString(_keyUser, jsonEncode(user.toJson()));
      await prefs.setString(_keyRole, role.toLowerCase());
    } catch (_) {}
  }

  Future<bool> tryAutoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_keyToken);
      final userStr = prefs.getString(_keyUser);

      if (token != null && token.isNotEmpty && userStr != null && userStr.isNotEmpty) {
        _accessToken = token;
        _currentUser = AuthUser.fromJson(jsonDecode(userStr));
        // Keep status fresh in background
        checkUserStatus(userId: _currentUser?.userId, email: _currentUser?.email);
        return true;
      }
    } catch (_) {}
    return false;
  }

  Future<void> logout() async {
    _accessToken = null;
    _currentUser = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyToken);
      await prefs.remove(_keyUser);
      await prefs.remove(_keyRole);
      await _googleSignIn.signOut();
    } catch (_) {}
  }

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
          await _saveSession(_accessToken!, _currentUser!, role);
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

  Future<AuthResult> signInWithGoogle({
    required String role,
    bool isSignUp = false,
  }) async {
    try {
      try {
        await _googleSignIn.signOut();
      } catch (_) {}

      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        return AuthResult(isSuccess: false, message: 'Google sign-in was cancelled.');
      }

      final GoogleSignInAuthentication authDetails = await account.authentication;
      final String? idToken = authDetails.idToken;

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/v1/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_token': idToken,
          'email': account.email,
          'display_name': account.displayName,
          'photo_url': account.photoUrl,
          'role': role.toLowerCase(),
          'google_id': account.id,
        }),
      ).timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _accessToken = data['access_token'];
        if (data['user'] != null) {
          _currentUser = AuthUser.fromJson(data['user']);
          await _saveSession(_accessToken!, _currentUser!, role);
        }
        return AuthResult(
          isSuccess: true,
          token: _accessToken,
          user: _currentUser,
          message: data['message'] ?? 'Successfully signed in with Google.',
          status: _currentUser?.status ?? 'approved',
          isPending: _currentUser?.isPending ?? false,
        );
      } else {
        final errorDetail = data['detail'];
        String msg = 'Google sign-in failed.';
        if (errorDetail is String) {
          msg = errorDetail;
        } else if (errorDetail is Map && errorDetail['message'] != null) {
          msg = errorDetail['message'];
        }
        return AuthResult(
          isSuccess: false,
          message: msg,
        );
      }
    } catch (e) {
      return AuthResult(
        isSuccess: false,
        message: 'Google sign-in error: ${e.toString().replaceAll("Exception:", "").trim()}',
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
          await _saveSession(_accessToken!, _currentUser!, data.role);
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
          // Update cached user
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_keyUser, jsonEncode(_currentUser!.toJson()));
        }
        return data;
      }
    } catch (_) {}
    return {'status': 'unknown'};
  }
}

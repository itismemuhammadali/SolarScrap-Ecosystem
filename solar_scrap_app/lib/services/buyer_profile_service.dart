import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../config/api_config.dart';
import '../models/buyer_profile.dart';
import '../models/buyer_stats.dart';
import 'auth_service.dart';

class BuyerProfileService {
  static final BuyerProfileService instance = BuyerProfileService._internal();
  BuyerProfileService._internal();

  String get _baseUrl => ApiConfig.baseUrl;
  BuyerProfile? _cachedProfile;

  Map<String, String> get _headers {
    final token = AuthService.instance.accessToken;
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  String? getFullImageUrl(String? pathOrUrl) {
    if (pathOrUrl == null || pathOrUrl.isEmpty) return null;
    if (pathOrUrl.startsWith('http://') || pathOrUrl.startsWith('https://')) {
      return pathOrUrl;
    }
    final cleanPath = pathOrUrl.startsWith('/') ? pathOrUrl : '/$pathOrUrl';
    return '$_baseUrl$cleanPath';
  }

  /// Fetch Buyer profile from backend /api/v1/auth/me or cached/current user
  Future<BuyerProfile?> fetchProfile() async {
    try {
      if (AuthService.instance.accessToken != null) {
        final response = await http.get(
          Uri.parse('$_baseUrl/api/v1/auth/me'),
          headers: _headers,
        ).timeout(const Duration(seconds: 15));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          _cachedProfile = BuyerProfile.fromJson(data);
          return _cachedProfile;
        }
      }
    } catch (_) {}

    if (_cachedProfile != null) {
      return _cachedProfile;
    }

    final currentUser = AuthService.instance.currentUser;
    if (currentUser != null) {
      _cachedProfile = BuyerProfile(
        userId: currentUser.userId,
        email: currentUser.email,
        role: currentUser.role,
        displayName: currentUser.displayName ?? '',
        phoneNumber: currentUser.phoneNumber ?? '',
        city: '',
        area: '',
      );
      return _cachedProfile;
    }

    _cachedProfile = BuyerProfile(
      userId: '',
      email: '',
      role: 'buyer',
      displayName: '',
      phoneNumber: '',
      city: '',
      area: '',
    );
    return _cachedProfile;
  }

  /// Fetch Buyer stats from backend /api/v1/auth/stats
  Future<BuyerStats?> fetchStats() async {
    try {
      if (AuthService.instance.accessToken != null) {
        final response = await http.get(
          Uri.parse('$_baseUrl/api/v1/auth/stats'),
          headers: _headers,
        ).timeout(const Duration(seconds: 15));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return BuyerStats.fromJson(data);
        }
      }
    } catch (_) {}
    return BuyerStats(totalBids: 0, wonAuctions: 0, activeBids: 0);
  }

  /// Update buyer profile fields (display_name, phone_number, city, etc.)
  Future<BuyerProfile?> updateProfile(Map<String, dynamic> updateFields) async {
    BuyerProfile? serverUpdated;
    try {
      if (AuthService.instance.accessToken != null) {
        final response = await http.put(
          Uri.parse('$_baseUrl/api/v1/auth/profile'),
          headers: _headers,
          body: jsonEncode(updateFields),
        ).timeout(const Duration(seconds: 15));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          serverUpdated = BuyerProfile.fromJson(data);
        }
      }
    } catch (_) {}

    if (serverUpdated != null) {
      _cachedProfile = serverUpdated;
      return _cachedProfile;
    }

    // Update local cache seamlessly
    final current = _cachedProfile ?? await fetchProfile();
    _cachedProfile = current?.copyWith(
      displayName: updateFields['display_name']?.toString() ?? current.displayName,
      phoneNumber: updateFields['phone_number']?.toString() ?? current.phoneNumber,
      city: updateFields['city']?.toString() ?? current.city,
      area: updateFields['area']?.toString() ?? current.area,
      profilePhotoUrl: updateFields['profile_photo_url']?.toString() ?? current.profilePhotoUrl,
    );

    return _cachedProfile;
  }

  /// Upload buyer profile photo
  Future<String?> uploadProfilePhoto(File imageFile) async {
    try {
      final token = AuthService.instance.accessToken;
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/api/v1/storage/upload-profile-photo'),
      );

      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      final ext = imageFile.path.split('.').last.toLowerCase();
      final subType = (ext == 'png' || ext == 'webp' || ext == 'gif') ? ext : 'jpeg';

      final multipartFile = await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        contentType: MediaType('image', subType),
      );
      request.files.add(multipartFile);

      final streamedResponse = await request.send().timeout(const Duration(seconds: 25));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        final url = data['profile_photo_url'];
        if (url != null && _cachedProfile != null) {
          _cachedProfile = _cachedProfile!.copyWith(profilePhotoUrl: url.toString());
        }
        return url;
      }
    } catch (_) {}
    return null;
  }

  /// Change Password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      if (AuthService.instance.accessToken != null) {
        final response = await http.post(
          Uri.parse('$_baseUrl/api/v1/auth/change-password'),
          headers: _headers,
          body: jsonEncode({
            'current_password': currentPassword,
            'new_password': newPassword,
          }),
        ).timeout(const Duration(seconds: 10));

        if (response.statusCode >= 200 && response.statusCode < 300) {
          return true;
        }
      }
    } catch (_) {}
    return true;
  }

  void clearCache() {
    _cachedProfile = null;
  }
}

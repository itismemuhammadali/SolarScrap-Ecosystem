import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../config/api_config.dart';
import '../models/seller_profile.dart';
import '../models/seller_stats.dart';
import 'auth_service.dart';

class ProfileService {
  static final ProfileService instance = ProfileService._internal();
  ProfileService._internal();

  String get _baseUrl => ApiConfig.baseUrl;

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

  Future<SellerProfile?> fetchProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/v1/auth/me'),
        headers: _headers,
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return SellerProfile.fromJson(data);
      }
    } catch (e) {
      print('[ProfileService] fetchProfile error: $e');
    }
    return null;
  }

  Future<SellerStats?> fetchStats() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/v1/auth/stats'),
        headers: _headers,
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return SellerStats.fromJson(data);
      }
    } catch (e) {
      print('[ProfileService] fetchStats error: $e');
    }
    return null;
  }

  Future<SellerProfile?> updateProfile(Map<String, dynamic> updateFields) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/api/v1/auth/profile'),
        headers: _headers,
        body: jsonEncode(updateFields),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return SellerProfile.fromJson(data);
      }
    } catch (e) {
      print('[ProfileService] updateProfile error: $e');
    }
    return null;
  }

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
        return data['profile_photo_url'];
      } else {
        print('[ProfileService] uploadProfilePhoto failed: ${response.body}');
      }
    } catch (e) {
      print('[ProfileService] uploadProfilePhoto error: $e');
    }
    return null;
  }
}

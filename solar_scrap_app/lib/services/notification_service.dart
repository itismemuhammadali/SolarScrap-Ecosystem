import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/notification_item.dart';
import 'auth_service.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._internal();
  NotificationService._internal();

  String get _baseUrl => ApiConfig.baseUrl;

  Map<String, String> get _headers {
    final token = AuthService.instance.accessToken;
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Fetch all notifications for current user
  Future<List<NotificationItem>> fetchNotifications() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/v1/notifications'),
        headers: _headers,
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => NotificationItem.fromJson(json)).toList();
      }
    } catch (e) {
      // Ignored in production
    }
    return [];
  }

  /// Mark single notification as read
  Future<bool> markAsRead(String notificationId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/v1/notifications/$notificationId/read'),
        headers: _headers,
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// Mark all notifications as read
  Future<bool> markAllAsRead() async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/v1/notifications/read-all'),
        headers: _headers,
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}

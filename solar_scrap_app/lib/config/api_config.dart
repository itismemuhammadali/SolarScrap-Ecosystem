import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class ApiConfig {
  // Configurable base URL override (e.g. for real physical devices on Wi-Fi)
  static String? customBaseUrl;

  static String get baseUrl {
    if (customBaseUrl != null && customBaseUrl!.isNotEmpty) {
      return customBaseUrl!;
    }

    if (kIsWeb) {
      return 'http://127.0.0.1:8000';
    }

    try {
      if (Platform.isAndroid) {
        // Android Emulator loops back to host via 10.0.2.2
        return 'http://10.0.2.2:8000';
      }
    } catch (_) {
      // Fallback for non-dart:io web / other targets
    }

    return 'http://127.0.0.1:8000';
  }

  // Auth Endpoints
  static String get loginUrl => '$baseUrl/api/v1/auth/login';
  static String get meUrl => '$baseUrl/api/v1/auth/me';
  static String get healthUrl => '$baseUrl/api/v1/health';
}

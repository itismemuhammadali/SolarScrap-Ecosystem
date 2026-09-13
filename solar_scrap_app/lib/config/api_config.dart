class ApiConfig {
  // Configurable base URL override
  static String? customBaseUrl;

  // VPS Production Server
  static const String productionBaseUrl = 'http://2.25.116.203';

  static String get baseUrl {
    if (customBaseUrl != null && customBaseUrl!.isNotEmpty) {
      return customBaseUrl!;
    }

    return productionBaseUrl;
  }

  // Auth Endpoints
  static String get loginUrl => '$baseUrl/api/v1/auth/login';
  static String get meUrl => '$baseUrl/api/v1/auth/me';
  static String get deleteAccountUrl => '$baseUrl/api/v1/auth/account';
  static String get healthUrl => '$baseUrl/api/v1/health';

  // Google OAuth Web Client ID (from Firebase Console)
  static const String googleServerClientId =
      '436150981342-p0al738lojtbed5lmn22gjo93ret6a0q.apps.googleusercontent.com';
}

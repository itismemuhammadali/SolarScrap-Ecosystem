import 'dart:developer' as developer;
import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static final RemoteConfigService instance = RemoteConfigService._();
  RemoteConfigService._();

  static const String keyGoogleMapsApiKey = 'google_maps_api_key';
  static const String defaultMapsKey = 'AIzaSyAzdW-jDO8eeWcK3cVT1MfwS8FxUTRFds4';

  FirebaseRemoteConfig? _remoteConfig;

  Future<void> init() async {
    try {
      _remoteConfig = FirebaseRemoteConfig.instance;
      await _remoteConfig!.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );

      await _remoteConfig!.setDefaults({
        keyGoogleMapsApiKey: defaultMapsKey,
        'default_latitude': 24.8607,
        'default_longitude': 67.0011,
      });

      await _remoteConfig!.fetchAndActivate();
      developer.log('Firebase Remote Config initialized successfully', name: 'RemoteConfig');
    } catch (e) {
      developer.log('Remote Config init warning: $e', name: 'RemoteConfig');
    }
  }

  String get googleMapsApiKey {
    final value = _remoteConfig?.getString(keyGoogleMapsApiKey);
    if (value != null && value.trim().isNotEmpty) {
      return value.trim();
    }
    return defaultMapsKey;
  }

  double get defaultLatitude {
    final val = _remoteConfig?.getDouble('default_latitude');
    return (val != null && val != 0.0) ? val : 24.8607;
  }

  double get defaultLongitude {
    final val = _remoteConfig?.getDouble('default_longitude');
    return (val != null && val != 0.0) ? val : 67.0011;
  }
}

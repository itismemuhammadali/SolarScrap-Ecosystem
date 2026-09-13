import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'auth_service.dart';

class PushNotificationService {
  static final PushNotificationService instance =
      PushNotificationService._internal();
  PushNotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Real-time event notifier that increments whenever a new push notification is received
  static final ValueNotifier<int> onNotificationReceived = ValueNotifier<int>(0);

  bool _isInitialized = false;

  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
    'solar_scrap_channel',
    'Solar Scrap Notifications',
    description: 'High-importance push notifications for deals, bids, and updates.',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // 1. Request notification permissions
      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      debugPrint(
          '[PushNotification] User granted permission: ${settings.authorizationStatus}');

      // 2. Initialize Flutter Local Notifications for heads-up foreground display
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@drawable/ic_notification');

      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint(
              '[PushNotification] Local notification tapped: ${response.payload}');
        },
      );

      // Create high-importance Android channel
      if (Platform.isAndroid) {
        final androidImplementation = _localNotifications
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();
        await androidImplementation
            ?.createNotificationChannel(_androidChannel);
      }

      // 3. Foreground message presentation options for iOS
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // 4. Listen for foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint(
            '[PushNotification] Received foreground message: ${message.notification?.title}');
        _showLocalNotification(message);
        // Trigger in-app live auto-reload on dashboards and notification lists
        onNotificationReceived.value++;
      });

      // 5. Retrieve device FCM token and register with backend
      _retrieveAndRegisterToken();

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        debugPrint('[PushNotification] FCM token refreshed: $newToken');
        AuthService.instance.registerFcmToken(newToken);
      });

      _isInitialized = true;
    } catch (e) {
      debugPrint('[PushNotification] Initialization failed: $e');
    }
  }

  Future<void> _retrieveAndRegisterToken() async {
    await syncFcmTokenWithBackend();
  }

  /// Public method to retrieve and sync FCM token with the backend for the current user
  Future<void> syncFcmTokenWithBackend() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null && token.isNotEmpty) {
        debugPrint('[PushNotification] Syncing FCM Token with backend: $token');
        await AuthService.instance.registerFcmToken(token);
      }
    } catch (e) {
      debugPrint('[PushNotification] Could not sync FCM token: $e');
    }
  }

  void _showLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    final androidDetails = AndroidNotificationDetails(
      _androidChannel.id,
      _androidChannel.name,
      channelDescription: _androidChannel.description,
      importance: Importance.max,
      priority: Priority.high,
      icon: '@drawable/ic_notification',
      color: const Color(0xFF00A63E),
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/launcher_icon'),
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    _localNotifications.show(
      message.hashCode,
      notification.title ?? 'Solar Scrap',
      notification.body ?? '',
      notificationDetails,
      payload: message.data['listing_id'] ?? '',
    );
  }

  /// Trigger a test notification locally
  Future<void> showTestNotification({
    String title = 'Solar Scrap Alert',
    String body = 'Push notifications are working smoothly!',
  }) async {
    final androidDetails = AndroidNotificationDetails(
      _androidChannel.id,
      _androidChannel.name,
      channelDescription: _androidChannel.description,
      importance: Importance.max,
      priority: Priority.high,
      icon: '@drawable/ic_notification',
      color: const Color(0xFF00A63E),
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/launcher_icon'),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _localNotifications.show(
      0,
      title,
      body,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
    );
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import 'auth_service.dart';

class UserPreferencesService {
  static final UserPreferencesService instance = UserPreferencesService._internal();
  UserPreferencesService._internal();

  // Keys for SharedPreferences
  static const String _keyListingUpdates = 'pref_listing_updates';
  static const String _keyPriceOffers = 'pref_price_offers';
  static const String _keyProductUpdates = 'pref_product_updates';
  static const String _keyNewAuctions = 'pref_new_auctions';
  static const String _keyBidUpdates = 'pref_bid_updates';
  static const String _keyClosingSoonAlerts = 'pref_closing_soon_alerts';
  static const String _keyWinningNotifications = 'pref_winning_notifications';
  static const String _keyLanguage = 'pref_language';

  // Seller Preferences
  bool listingUpdates = true;
  bool priceOffers = true;
  bool productUpdates = false;

  // Buyer Preferences
  bool newAuctions = true;
  bool bidUpdates = true;
  bool closingSoonAlerts = false;
  bool winningNotifications = true;

  // Common
  String language = 'English';
  bool _initialized = false;

  /// Initialize and load preferences from local cache immediately
  Future<void> init() async {
    if (_initialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      listingUpdates = prefs.getBool(_keyListingUpdates) ?? true;
      priceOffers = prefs.getBool(_keyPriceOffers) ?? true;
      productUpdates = prefs.getBool(_keyProductUpdates) ?? false;

      newAuctions = prefs.getBool(_keyNewAuctions) ?? true;
      bidUpdates = prefs.getBool(_keyBidUpdates) ?? true;
      closingSoonAlerts = prefs.getBool(_keyClosingSoonAlerts) ?? false;
      winningNotifications = prefs.getBool(_keyWinningNotifications) ?? true;

      language = prefs.getString(_keyLanguage) ?? 'English';
      _initialized = true;

      // Fetch latest from backend in background
      fetchRemotePreferences();
    } catch (_) {}
  }

  /// Sync preferences with backend server
  Future<void> fetchRemotePreferences() async {
    final token = AuthService.instance.accessToken;
    if (token == null) return;

    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/v1/auth/preferences'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();

        if (data.containsKey('listing_updates') && data['listing_updates'] is bool) {
          listingUpdates = data['listing_updates'];
          await prefs.setBool(_keyListingUpdates, listingUpdates);
        }
        if (data.containsKey('price_offers') && data['price_offers'] is bool) {
          priceOffers = data['price_offers'];
          await prefs.setBool(_keyPriceOffers, priceOffers);
        }
        if (data.containsKey('product_updates') && data['product_updates'] is bool) {
          productUpdates = data['product_updates'];
          await prefs.setBool(_keyProductUpdates, productUpdates);
        }
        if (data.containsKey('new_auctions') && data['new_auctions'] is bool) {
          newAuctions = data['new_auctions'];
          await prefs.setBool(_keyNewAuctions, newAuctions);
        }
        if (data.containsKey('bid_updates') && data['bid_updates'] is bool) {
          bidUpdates = data['bid_updates'];
          await prefs.setBool(_keyBidUpdates, bidUpdates);
        }
        if (data.containsKey('closing_soon_alerts') && data['closing_soon_alerts'] is bool) {
          closingSoonAlerts = data['closing_soon_alerts'];
          await prefs.setBool(_keyClosingSoonAlerts, closingSoonAlerts);
        }
        if (data.containsKey('winning_notifications') && data['winning_notifications'] is bool) {
          winningNotifications = data['winning_notifications'];
          await prefs.setBool(_keyWinningNotifications, winningNotifications);
        }
      }
    } catch (_) {}
  }

  /// Update single or multiple preferences locally and push to backend
  Future<void> updatePreferences(Map<String, dynamic> updates) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (updates.containsKey('listing_updates')) {
        listingUpdates = updates['listing_updates'] as bool;
        await prefs.setBool(_keyListingUpdates, listingUpdates);
      }
      if (updates.containsKey('price_offers')) {
        priceOffers = updates['price_offers'] as bool;
        await prefs.setBool(_keyPriceOffers, priceOffers);
      }
      if (updates.containsKey('product_updates')) {
        productUpdates = updates['product_updates'] as bool;
        await prefs.setBool(_keyProductUpdates, productUpdates);
      }
      if (updates.containsKey('new_auctions')) {
        newAuctions = updates['new_auctions'] as bool;
        await prefs.setBool(_keyNewAuctions, newAuctions);
      }
      if (updates.containsKey('bid_updates')) {
        bidUpdates = updates['bid_updates'] as bool;
        await prefs.setBool(_keyBidUpdates, bidUpdates);
      }
      if (updates.containsKey('closing_soon_alerts')) {
        closingSoonAlerts = updates['closing_soon_alerts'] as bool;
        await prefs.setBool(_keyClosingSoonAlerts, closingSoonAlerts);
      }
      if (updates.containsKey('winning_notifications')) {
        winningNotifications = updates['winning_notifications'] as bool;
        await prefs.setBool(_keyWinningNotifications, winningNotifications);
      }

      // Push to backend asynchronously
      final token = AuthService.instance.accessToken;
      if (token != null) {
        http.put(
          Uri.parse('${ApiConfig.baseUrl}/api/v1/auth/preferences'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(updates),
        ).timeout(const Duration(seconds: 8)).catchError((_) => http.Response('{}', 500));
      }
    } catch (_) {}
  }

  Future<void> setLanguage(String lang) async {
    language = lang;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyLanguage, lang);
    } catch (_) {}
  }
}

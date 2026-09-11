import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/bid.dart';
import 'auth_service.dart';

class BidService {
  static final BidService instance = BidService._internal();
  BidService._internal();

  String get _baseUrl => ApiConfig.baseUrl;
  List<Bid>? _cachedMyBids;

  Map<String, String> get _headers {
    final token = AuthService.instance.accessToken;
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  void clearCache() {
    _cachedMyBids = null;
  }

  /// Submit a new bid on a listing
  Future<Bid?> submitBid(String listingId, double amount) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/v1/bids'),
        headers: _headers,
        body: jsonEncode({
          'listing_id': listingId,
          'amount': amount,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        clearCache();
        final data = jsonDecode(response.body);
        return Bid.fromJson(data);
      } else {
        // ignore: avoid_print
        print('submitBid error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('submitBid exception: $e');
    }
    return null;
  }

  /// Fetch all bids placed by current logged in buyer
  Future<List<Bid>> fetchMyBids({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedMyBids != null && _cachedMyBids!.isNotEmpty) {
      return _cachedMyBids!;
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/v1/bids'),
        headers: _headers,
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final list = data.map((json) => Bid.fromJson(json)).toList();
        _cachedMyBids = list;
        return list;
      } else {
        // ignore: avoid_print
        print('fetchMyBids error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('fetchMyBids exception: $e');
    }

    return _cachedMyBids ?? [];
  }

  /// Fetch all bids for a specific listing (seller side)
  Future<List<Bid>> fetchBidsForListing(String listingId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/v1/bids/listing/$listingId'),
        headers: _headers,
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Bid.fromJson(json)).toList();
      }
    } catch (_) {}
    return [];
  }

  /// Accept a bid (seller side)
  Future<Bid?> acceptBid(String bidId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/v1/bids/$bidId/accept'),
        headers: _headers,
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        clearCache();
        final data = jsonDecode(response.body);
        return Bid.fromJson(data);
      }
    } catch (_) {}
    return null;
  }

  /// Reject a bid (seller side)
  Future<Bid?> rejectBid(String bidId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/v1/bids/$bidId/reject'),
        headers: _headers,
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        clearCache();
        final data = jsonDecode(response.body);
        return Bid.fromJson(data);
      }
    } catch (_) {}
    return null;
  }
}

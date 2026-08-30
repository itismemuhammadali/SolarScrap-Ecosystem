import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../config/api_config.dart';
import '../models/listing.dart';
import '../models/listing_draft.dart';
import 'auth_service.dart';

class ListingService {
  static final ListingService instance = ListingService._internal();
  ListingService._internal();

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

  /// Upload an image file for a listing
  Future<String?> uploadListingImage(File imageFile, {int retries = 1}) async {
    for (int attempt = 0; attempt <= retries; attempt++) {
      try {
        final token = AuthService.instance.accessToken;
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('$_baseUrl/api/v1/storage/upload-listing-image'),
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

        final streamedResponse = await request.send().timeout(const Duration(seconds: 10));
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode >= 200 && response.statusCode < 300) {
          final data = jsonDecode(response.body);
          return data['url'];
        } else {
          print('[ListingService] uploadListingImage failed (attempt ${attempt + 1}): ${response.body}');
        }
      } catch (e) {
        print('[ListingService] uploadListingImage error (attempt ${attempt + 1}): $e');
        if (attempt == retries) return null;
        await Future.delayed(const Duration(seconds: 1));
      }
    }
    return null;
  }

  /// Submit a new listing to FastAPI/Firestore
  Future<Listing?> createListing(ListingDraft draft) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/v1/listings'),
        headers: _headers,
        body: jsonEncode(draft.toJson()),
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        return Listing.fromJson(data);
      } else {
        print('[ListingService] createListing failed (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      print('[ListingService] createListing error: $e');
    }
    return null;
  }

  /// Fetch all listings created by the current seller
  Future<List<Listing>> fetchMyListings() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/v1/listings'),
        headers: _headers,
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Listing.fromJson(json)).toList();
      } else {
        print('[ListingService] fetchMyListings failed: ${response.body}');
      }
    } catch (e) {
      print('[ListingService] fetchMyListings error: $e');
    }
    return [];
  }

  /// Fetch single listing by ID
  Future<Listing?> fetchListingById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/v1/listings/$id'),
        headers: _headers,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Listing.fromJson(data);
      }
    } catch (e) {
      print('[ListingService] fetchListingById error: $e');
    }
    return null;
  }
}

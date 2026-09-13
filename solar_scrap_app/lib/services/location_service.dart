import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationDetails {
  final double latitude;
  final double longitude;
  final String city;
  final String area;
  final String fullAddress;

  LocationDetails({
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.area,
    required this.fullAddress,
  });
}

class LocationService {
  static final LocationService instance = LocationService._();
  LocationService._();

  /// Request location permission and get current position
  Future<Position?> getCurrentPosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('Location services are disabled.');
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Location permissions are denied');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('Location permissions are permanently denied');
        return null;
      }

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 8),
        ),
      );
    } catch (e) {
      debugPrint('Error getting current position: $e');
      return null;
    }
  }

  /// Reverse geocode coordinates to human-readable address
  Future<LocationDetails?> reverseGeocode(double latitude, double longitude) async {
    try {
      final geocoding = Geocoding();
      List<Placemark> placemarks = await geocoding.placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final city = place.locality?.isNotEmpty == true
            ? place.locality!
            : (place.subAdministrativeArea ?? 'Karachi');
        final area = place.subLocality?.isNotEmpty == true
            ? place.subLocality!
            : (place.name ?? '');
        
        final street = place.street ?? '';
        final fullParts = [
          if (street.isNotEmpty && street != area) street,
          if (area.isNotEmpty) area,
          if (city.isNotEmpty) city,
          if (place.country != null && place.country!.isNotEmpty) place.country!,
        ];
        final fullAddress = fullParts.join(', ');

        return LocationDetails(
          latitude: latitude,
          longitude: longitude,
          city: city,
          area: area,
          fullAddress: fullAddress.isNotEmpty ? fullAddress : '$city, Pakistan',
        );
      }
    } catch (e) {
      debugPrint('Reverse geocoding error: $e');
    }
    return LocationDetails(
      latitude: latitude,
      longitude: longitude,
      city: 'Karachi',
      area: '',
      fullAddress: 'Karachi, Pakistan',
    );
  }

  /// Calculate distance between two coordinates in kilometers
  double calculateDistanceKm(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    try {
      final distanceInMeters = Geolocator.distanceBetween(
        startLat,
        startLng,
        endLat,
        endLng,
      );
      return distanceInMeters / 1000.0;
    } catch (e) {
      // Fallback Haversine
      const p = 0.017453292519943295;
      final a = 0.5 -
          cos((endLat - startLat) * p) / 2 +
          cos(startLat * p) * cos(endLat * p) * (1 - cos((endLng - startLng) * p)) / 2;
      return 12742 * asin(sqrt(a));
    }
  }

  /// Format distance into user-friendly string
  String formatDistance(double km) {
    if (km < 1.0) {
      return '${(km * 1000).round()} m away';
    } else if (km < 10) {
      return '${km.toStringAsFixed(1)} km away';
    } else {
      return '${km.toStringAsFixed(0)} km away';
    }
  }

  /// Format approximate drive time
  String formatDriveTime(double km) {
    // Estimate based on city driving ~30-40 km/h
    final minutes = (km / 35.0 * 60).round();
    if (minutes < 5) {
      return '~5 mins';
    } else if (minutes < 60) {
      return '~$minutes mins';
    } else {
      final hours = minutes ~/ 60;
      final remainingMins = minutes % 60;
      return remainingMins > 0 ? '~${hours}h ${remainingMins}m' : '~${hours}h';
    }
  }
}

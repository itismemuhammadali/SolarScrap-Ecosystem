import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/location_service.dart';
import '../services/remote_config_service.dart';

class ListingMapPreviewWidget extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final String pickupCity;
  final String? pickupArea;
  final String pickupAddress;

  const ListingMapPreviewWidget({
    super.key,
    this.latitude,
    this.longitude,
    required this.pickupCity,
    this.pickupArea,
    required this.pickupAddress,
  });

  @override
  State<ListingMapPreviewWidget> createState() => _ListingMapPreviewWidgetState();
}

class _ListingMapPreviewWidgetState extends State<ListingMapPreviewWidget> {
  GoogleMapController? _mapController;
  late LatLng _targetLocation;
  String? _distanceText;
  String? _driveTimeText;
  bool _isCalculatingDistance = true;

  @override
  void initState() {
    super.initState();
    final defaultLat = widget.latitude ?? RemoteConfigService.instance.defaultLatitude;
    final defaultLng = widget.longitude ?? RemoteConfigService.instance.defaultLongitude;
    _targetLocation = LatLng(defaultLat, defaultLng);
    _calculateDistance();
  }

  Future<void> _calculateDistance() async {
    try {
      final userPos = await LocationService.instance.getCurrentPosition();
      if (userPos != null && mounted) {
        final distKm = LocationService.instance.calculateDistanceKm(
          userPos.latitude,
          userPos.longitude,
          _targetLocation.latitude,
          _targetLocation.longitude,
        );
        setState(() {
          _distanceText = LocationService.instance.formatDistance(distKm);
          _driveTimeText = LocationService.instance.formatDriveTime(distKm);
          _isCalculatingDistance = false;
        });
        return;
      }
    } catch (_) {}
    if (mounted) {
      setState(() {
        _isCalculatingDistance = false;
      });
    }
  }

  Future<void> _openNativeMaps() async {
    final lat = _targetLocation.latitude;
    final lng = _targetLocation.longitude;
    final label = Uri.encodeComponent(
      widget.pickupAddress.isNotEmpty ? widget.pickupAddress : widget.pickupCity,
    );

    Uri uri;
    if (Platform.isIOS) {
      uri = Uri.parse('http://maps.apple.com/?q=$label&ll=$lat,$lng');
    } else {
      uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    }

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        final fallbackUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
        await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Could not launch maps: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayAddress = [
      if (widget.pickupAddress.isNotEmpty) widget.pickupAddress,
      if (widget.pickupArea != null && widget.pickupArea!.isNotEmpty) widget.pickupArea!,
      if (widget.pickupCity.isNotEmpty) widget.pickupCity,
    ].join(', ');

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFEAEAEA),
          width: 1.1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: Color(0xFF00A63E),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Pickup Location',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF18181B),
                      ),
                    ),
                  ],
                ),
                if (_distanceText != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFBBF7D0)),
                    ),
                    child: Text(
                      '$_distanceText${_driveTimeText != null ? ' · $_driveTimeText' : ''}',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF15803D),
                      ),
                    ),
                  )
                else if (_isCalculatingDistance)
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF00A63E)),
                  ),
              ],
            ),
          ),

          // Map Preview
          SizedBox(
            height: 160,
            width: double.infinity,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _targetLocation,
                    zoom: 14.0,
                  ),
                  onMapCreated: (controller) => _mapController = controller,
                  markers: {
                    Marker(
                      markerId: const MarkerId('pickup_location'),
                      position: _targetLocation,
                      infoWindow: InfoWindow(
                        title: 'Scrap Pickup Point',
                        snippet: displayAddress,
                      ),
                    ),
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  compassEnabled: false,
                  mapToolbarEnabled: false,
                ),
                // Tap overlay to open in full maps
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _openNativeMaps,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.directions, color: Color(0xFF00A63E), size: 16),
                            const SizedBox(width: 4),
                            Text(
                              'Directions',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF00A63E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Address Footer
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.place_outlined, color: Color(0xFF71717A), size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    displayAddress.isNotEmpty ? displayAddress : 'Location specified by seller',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF52525B),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}

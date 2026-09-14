import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_localizations.dart';
import '../../models/listing.dart';
import '../../services/listing_service.dart';
import '../../utils/rtl_helper.dart';
import '../../widgets/listing_map_preview_widget.dart';
import 'seller_status_tracking_screen.dart';

class SellerListingDetailsScreen extends StatefulWidget {
  final Listing? listing;

  const SellerListingDetailsScreen({
    this.listing,
    super.key,
  });

  @override
  State<SellerListingDetailsScreen> createState() =>
      _SellerListingDetailsScreenState();
}

class _SellerListingDetailsScreenState
    extends State<SellerListingDetailsScreen> {
  Listing get _listing {
    if (widget.listing != null) return widget.listing!;
    return Listing(
      id: 'SS-ACTIVE',
      sellerId: '',
      category: 'Solar Panels',
      status: 'active',
      priceDemand: 240000.0,
      specs: {
        'panels_count': '200',
        'watts_per_panel': '400',
        'panel_condition': 'Good',
      },
      imageUrls: [],
      pickupCity: 'Karachi',
      pickupArea: 'DHA Phase 7',
      pickupAddress: 'Street 5, Commercial Area',
      contactName: 'Abdul Samad',
      contactPhone: '+92 3012345678',
      contactEmail: 'seller@suntech.com',
    );
  }

  String _getCategoryDisplayName(String name, AppLocalizations l10n) {
    switch (name) {
      case 'Solar Panels':
        return l10n.categoryPanels;
      case 'Batteries':
        return l10n.categoryBatteries;
      case 'Inverters':
        return l10n.categoryInverters;
      case 'Cables':
        return l10n.categoryCables;
      case 'Structure':
        return l10n.categoryStructure;
      case 'Complete Solar System':
        return l10n.completeSolarSystem;
      default:
        return name;
    }
  }

  String _getDisplayTitle(AppLocalizations l10n) {
    final l = _listing;
    if (l.category == 'Solar Panels' && l.specs['panels_count'] != null) {
      return '${l.specs['panels_count']}x ${l10n.categoryPanels} ${l.specs['watts_per_panel'] ?? ''}W';
    } else if (l.category == 'Batteries' && l.specs['battery_count'] != null) {
      return '${l.specs['battery_count']}x ${l.specs['battery_type'] ?? ''} ${l10n.categoryBatteries}';
    } else if (l.category == 'Inverters' && l.specs['rated_power'] != null) {
      return '${l.specs['inverter_brand'] ?? ''} ${l.specs['inverter_type'] ?? ''} ${l10n.inverter}';
    } else if (l.category == 'Cables') {
      return '${l.specs['cable_type'] ?? ''} ${l10n.categoryCables} ${l.specs['cable_size'] ?? ''}';
    } else if (l.category == 'Structure') {
      return '${l.specs['structure_type'] ?? ''} (${l.specs['structure_metal'] ?? ''}) ${l10n.structure}';
    }
    return l.category.isNotEmpty ? _getCategoryDisplayName(l.category, l10n) : l10n.equipmentDetailsTitle;
  }

  String _formatPrice(double price, AppLocalizations l10n) {
    if (price >= 100000) {
      return 'Rs. ${(price / 100000).toStringAsFixed(1)} ${l10n.lakhUnit}';
    }
    return 'Rs. ${price.toStringAsFixed(0)}';
  }

  String _localizeCondition(String condition, AppLocalizations l10n) {
    switch (condition.toLowerCase()) {
      case 'scrap':
        return l10n.conditionScrap;
      case 'bullet hit':
        return l10n.conditionBulletHit;
      case 'shatter glass':
      case 'shatter lass':
        return l10n.conditionShatterGlass;
      case 'good':
      case 'good conditions':
        return l10n.conditionGood;
      case 'working':
        return l10n.conditionWorking;
      case 'non working':
      case 'non-working':
        return l10n.conditionNonWorking;
      case 'other':
        return l10n.conditionOther;
      default:
        return condition;
    }
  }

  String _localizeSpecKey(String key, AppLocalizations l10n) {
    switch (key) {
      case 'panels_count':
        return l10n.numberOfPanels;
      case 'watts_per_panel':
        return l10n.wattsPerPanel;
      case 'panel_condition':
      case 'battery_condition':
      case 'inverter_condition':
        return l10n.listingConditionLabel;
      case 'battery_type':
        return l10n.batteryType;
      case 'battery_count':
        return l10n.listingQuantityLabel;
      case 'battery_capacity':
        return l10n.capacity;
      case 'battery_brand':
      case 'inverter_brand':
        return l10n.brand;
      case 'inverter_type':
        return l10n.inverterType;
      case 'rated_power':
        return l10n.ratedPower;
      case 'cable_type':
        return l10n.cableType;
      case 'cable_conductor':
        return l10n.conductor;
      case 'insulation_type':
        return l10n.insulation;
      case 'cable_size':
        return l10n.cableSize;
      case 'structure_type':
        return l10n.structureType;
      case 'structure_metal':
        return l10n.metal;
      default:
        return key
            .split('_')
            .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
            .join(' ');
    }
  }

  String _getFallbackAsset() {
    final cat = _listing.category;
    if (cat == 'Batteries') return 'assets/images/battery.jpg';
    if (cat == 'Inverters') return 'assets/images/inverter.png';
    if (cat == 'Cables') return 'assets/images/cables.jpg';
    if (cat == 'Structure') return 'assets/images/structure.png';
    if (cat == 'Complete Solar System') return 'assets/images/complete-solar-system.jpg';
    return 'assets/images/solar-panel.jpg';
  }

  Widget _buildImage(String urlOrPath, {required double width, required double height, required double radius}) {
    if (urlOrPath.startsWith('http://') || urlOrPath.startsWith('https://') || urlOrPath.startsWith('/api/')) {
      final fullUrl = ListingService.instance.getFullImageUrl(urlOrPath);
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.network(
          fullUrl ?? urlOrPath,
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            _getFallbackAsset(),
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else if (urlOrPath.startsWith('/') || urlOrPath.startsWith('file://')) {
      final clean = urlOrPath.replaceFirst('file://', '');
      final file = File(clean);
      if (file.existsSync()) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Image.file(
            file,
            width: width,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Image.asset(
              _getFallbackAsset(),
              width: width,
              height: height,
              fit: BoxFit.cover,
            ),
          ),
        );
      }
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(
        urlOrPath.isNotEmpty ? urlOrPath : _getFallbackAsset(),
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          _getFallbackAsset(),
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final l = _listing;
    final displayId = l.id.length > 12 ? l.id.substring(0, 12).toUpperCase() : l.id.toUpperCase();
    final statusLabel = l.status == 'active'
        ? l10n.filterActive
        : (l.status == 'under_review' ? l10n.statusUnderReview : l.status);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 56,
        leading: IconButton(
          icon: Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFE9E9E9),
              shape: BoxShape.circle,
            ),
            child: RTLHelper.backIcon(
              context,
              color: Colors.black,
              size: 18,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          l10n.listingDetailsTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Gallery
              if (l.imageUrls.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: l.imageUrls.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final url = entry.value;
                      final isFirst = idx == 0;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: _buildImage(
                          url,
                          width: isFirst ? 260 : 120,
                          height: 180,
                          radius: isFirst ? 16 : 12,
                        ),
                      );
                    }).toList(),
                  ),
                )
              else
                _buildImage(_getFallbackAsset(), width: double.infinity, height: 200, radius: 16),

              const SizedBox(height: 16),

              // Title and Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getDisplayTitle(l10n),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$displayId · ${_getCategoryDisplayName(l.category, l10n)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      statusLabel,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF00A63E),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Price
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF00A63E),
                    Color(0xFF007D2E),
                  ],
                ).createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                ),
                child: Text(
                  _formatPrice(l.priceDemand, l10n),
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 32 / 24,
                    letterSpacing: 0,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Equipment Details Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFEAEAEA),
                    width: 1.09,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.equipmentDetailsTitle,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF18181B),
                      ),
                    ),
                    const SizedBox(height: 8),

                    _buildDetailRow(l10n.listingCategoryLabel, _getCategoryDisplayName(l.category, l10n)),
                    ...l.specs.entries.map((e) {
                      final localizedKey = _localizeSpecKey(e.key, l10n);
                      final valStr = e.value.toString();
                      final localizedVal = (e.key.contains('condition'))
                          ? _localizeCondition(valStr, l10n)
                          : valStr;
                      return _buildDetailRow(localizedKey, localizedVal);
                    }),
                    _buildDetailRow(l10n.pickupCity, l.pickupCity),
                    if (l.pickupArea != null && l.pickupArea!.isNotEmpty)
                      _buildDetailRow(l10n.pickupArea, l.pickupArea!),
                    _buildDetailRow(l10n.addressLabel, l.pickupAddress),
                    _buildDetailRow(l10n.contactPerson, l.contactName),
                    _buildDetailRow(l10n.contactPhoneLabel, l.contactPhone, showDivider: false),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Pickup Location Map
              ListingMapPreviewWidget(
                latitude: l.latitude,
                longitude: l.longitude,
                pickupCity: l.pickupCity,
                pickupArea: l.pickupArea,
                pickupAddress: l.pickupAddress,
              ),
              const SizedBox(height: 16),

              // Track Status Card
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SellerStatusTrackingScreen(
                        currentStatus: statusLabel,
                        listing: _listing,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9F9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFEAEAEA),
                      width: 1.09,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.trackStatus,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF18181B),
                        ),
                      ),
                      RTLHelper.chevronIcon(
                        context,
                        color: const Color(0xFF00A63E),
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool showDivider = true}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 11),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF71717A),
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF18181B),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFEAEAEA),
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../models/listing.dart';
import '../../services/listing_service.dart';
import '../../services/saved_auctions_service.dart';
import '../../utils/rtl_helper.dart';
import '../../widgets/listing_map_preview_widget.dart';
import 'buyer_place_bid_screen.dart';

class BuyerAuctionDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? auctionData;
  final Listing? listing;

  const BuyerAuctionDetailsScreen({
    super.key,
    this.auctionData,
    this.listing,
  });

  @override
  State<BuyerAuctionDetailsScreen> createState() =>
      _BuyerAuctionDetailsScreenState();
}

class _BuyerAuctionDetailsScreenState extends State<BuyerAuctionDetailsScreen> {
  int _selectedTabIndex = 0; // 0: Details, 1: Specs, 2: Timeline
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  late Map<String, dynamic> _auction;
  late List<String> _imageUrls;

  @override
  void initState() {
    super.initState();
    _imageUrls = [];

    if (widget.listing != null) {
      final l = widget.listing!;
      _imageUrls = List<String>.from(l.imageUrls);

      final List<String> computedSpecs = [];
      l.specs.forEach((k, v) {
        if (v != null && v.toString().isNotEmpty && k != 'description') {
          final label = k
              .split('_')
              .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
              .join(' ');
          computedSpecs.add('$label: $v');
        }
      });
      if (computedSpecs.isEmpty) {
        computedSpecs.add('Category: ${l.category}');
        computedSpecs.add('Quantity: ${l.quantityDisplay}');
        computedSpecs.add('Location: ${l.locationDisplay}');
      }

      _auction = {
        'id': l.id.length >= 6 ? l.id.substring(0, 6).toUpperCase() : l.id.toUpperCase(),
        'title': l.title,
        'category': l.category,
        'image': l.firstImageUrl ?? 'assets/images/buyer-solar.jpg',
        'startingBid': l.formattedPrice,
        'currentBid': l.formattedPrice,
        'quantity': l.quantityDisplay,
        'condition': l.specs['condition']?.toString() ?? 'Inspected / Working',
        'location': l.pickupCity.isNotEmpty ? l.pickupCity : 'Pakistan',
        'locationDetail': l.locationDisplay,
        'timeLeft': 'Active',
        'contactName': l.contactName,
        'contactPhone': l.contactPhone,
        'contactEmail': l.contactEmail,
        'pickupAddress': l.pickupAddress,
        'description': l.specs['description']?.toString().isNotEmpty == true
            ? l.specs['description'].toString()
            : 'Solar equipment verified and available for immediate pickup at ${l.pickupAddress.isNotEmpty ? l.pickupAddress : l.locationDisplay}.',
        'specs': computedSpecs,
        'timeline': [
          {
            'title': 'Auction Created',
            'subtitle': l.createdAt ?? 'Recently',
            'completed': true,
          },
          {
            'title': 'Auction Live & Active',
            'subtitle': 'Bidding is currently open',
            'completed': true,
          },
          {
            'title': 'Highest Bidder Review',
            'subtitle': 'Seller will confirm winner',
            'completed': false,
            'current': true,
          },
        ],
      };
    } else {
      final defaultData = {
        'id': 'A001',
        'title': 'Monocrystalline Solar Panels',
        'category': 'Solar Panels',
        'image': 'assets/images/buyer-solar.jpg',
        'startingBid': 'PKR 85,000',
        'currentBid': 'PKR 92,000',
        'quantity': '150 units',
        'condition': 'Good',
        'location': 'Karachi',
        'locationDetail': 'Karachi, SITE Area',
        'timeLeft': 'Active',
        'description':
            'High-efficiency 400W monocrystalline panels from a decommissioned 500kW solar farm. Panels are in good working condition with minor cosmetic wear.',
        'specs': [
          '400W rated power',
          '21.3% efficiency',
          '25-year warranty remaining (5yr)',
          'Silver frame',
        ],
        'timeline': [
          {
            'title': 'Auction Created',
            'subtitle': 'Recently',
            'completed': true,
          },
          {
            'title': 'Auction Live & Active',
            'subtitle': 'Bidding is currently open',
            'completed': true,
          },
          {
            'title': 'Highest Bidder Review',
            'subtitle': 'Seller will confirm winner',
            'completed': false,
            'current': true,
          },
        ],
      };

      _auction = Map<String, dynamic>.from(defaultData);
      if (widget.auctionData != null) {
        widget.auctionData!.forEach((key, value) {
          if (value != null) {
            _auction[key] = value;
          }
        });
        if (widget.auctionData!['priceStr'] != null) {
          _auction['currentBid'] = widget.auctionData!['priceStr'];
        }
        if (widget.auctionData!['units'] != null) {
          _auction['quantity'] = widget.auctionData!['units'];
        }
        if (widget.auctionData!['location'] != null) {
          _auction['locationDetail'] =
              '${widget.auctionData!['location']}, Industrial Area';
        }
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String get _auctionId => widget.listing?.id ?? _auction['id']?.toString() ?? 'A001';

  bool get _isFavorite => SavedAuctionsService.instance.isFavorite(_auctionId);

  String get _descriptionText {
    if (_auction['description'] != null &&
        (_auction['description'] as String).isNotEmpty) {
      return _auction['description'];
    }
    return 'Quality solar scrap equipment inspected and listed on the SolarScrap marketplace.';
  }

  List<String> get _specsList {
    if (_auction['specs'] != null && (_auction['specs'] as List).isNotEmpty) {
      return List<String>.from(_auction['specs']);
    }
    return [
      'Category: ${_auction['category'] ?? 'Solar Scrap'}',
      'Verified equipment lot',
      'Available for pickup inspection',
    ];
  }

  List<Map<String, dynamic>> get _timelineList {
    if (_auction['timeline'] != null &&
        (_auction['timeline'] as List).isNotEmpty) {
      return List<Map<String, dynamic>>.from(_auction['timeline']);
    }
    return [
      {
        'title': 'Auction Created',
        'subtitle': 'Recently',
        'completed': true,
      },
      {
        'title': 'Auction Live & Active',
        'subtitle': 'Bidding is currently open',
        'completed': true,
      },
    ];
  }

  Widget _buildImageWidget(String pathOrUrl) {
    final fullUrl = ListingService.instance.getFullImageUrl(pathOrUrl);
    if (fullUrl != null &&
        (fullUrl.startsWith('http://') || fullUrl.startsWith('https://'))) {
      return Image.network(
        fullUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => _buildFallbackImage(),
      );
    }

    if (pathOrUrl.startsWith('assets/')) {
      return Image.asset(
        pathOrUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => _buildFallbackImage(),
      );
    }

    return _buildFallbackImage();
  }

  Widget _buildFallbackImage() {
    return Container(
      color: const Color(0xFFE5E7EB),
      child: const Center(
        child: Icon(
          Icons.solar_power_outlined,
          size: 64,
          color: Color(0xFF9CA3AF),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = _auction['title'] ?? 'Solar Equipment';
    final category = _auction['category'] ?? 'Solar Panels';
    final startingBid = _auction['startingBid'] ?? 'PKR 0';
    final currentBid = _auction['currentBid'] ?? 'PKR 0';
    final quantity = _auction['quantity'] ?? '1 lot';
    final condition = _auction['condition'] ?? 'Inspected';
    final location = _auction['location'] ?? 'Pakistan';
    final locationDetail = _auction['locationDetail'] ?? location;
    final timeLeft = _auction['timeLeft'] ?? 'Active';
    final auctionId = _auction['id'] ?? 'A001';

    final contactName = _auction['contactName']?.toString();

    final imagesToDisplay = _imageUrls.isNotEmpty
        ? _imageUrls
        : [(_auction['image']?.toString() ?? 'assets/images/buyer-solar.jpg')];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Image Header
                  Stack(
                    children: [
                      // Image / PageView
                      SizedBox(
                        height: 280,
                        width: double.infinity,
                        child: imagesToDisplay.length > 1
                            ? PageView.builder(
                                controller: _pageController,
                                itemCount: imagesToDisplay.length,
                                onPageChanged: (index) {
                                  setState(() => _currentImageIndex = index);
                                },
                                itemBuilder: (context, index) {
                                  return _buildImageWidget(imagesToDisplay[index]);
                                },
                              )
                            : _buildImageWidget(imagesToDisplay.first),
                      ),

                      // Top Gradient for button visibility
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 100,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.55),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Top Nav Buttons
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 8,
                        left: 16,
                        right: 16,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Back Button
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.4),
                                  shape: BoxShape.circle,
                                ),
                                child: RTLHelper.backIcon(
                                  context,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),

                            // Right Action Buttons
                            Row(
                              children: [
                                // Heart Button
                                GestureDetector(
                                  onTap: () {
                                    SavedAuctionsService.instance.toggleFavorite(_auctionId);
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.4),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      _isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: _isFavorite
                                          ? const Color(0xFFEF4444)
                                          : Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Bottom Overlay Badges & Dots
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                // Verified Seller Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF00A63E),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        l10n.verifiedSeller,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // Status Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        color: Colors.white,
                                        size: 13,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        timeLeft,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            // Multi-image dots indicator
                            if (imagesToDisplay.length > 1)
                              Row(
                                children: List.generate(imagesToDisplay.length, (idx) {
                                  return Container(
                                    width: _currentImageIndex == idx ? 16 : 6,
                                    height: 6,
                                    margin: const EdgeInsets.only(left: 4),
                                    decoration: BoxDecoration(
                                      color: _currentImageIndex == idx
                                          ? const Color(0xFF00A63E)
                                          : Colors.white70,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  );
                                }),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Main Content
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title & Starting Bid Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0F172A),
                                      height: 1.25,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEAF8EE),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      category,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF00A63E),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  l10n.priceDemand,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF9CA3AF),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  startingBid,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF00A63E),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Metric Info Cards (Quantity, Condition, Location)
                        Row(
                          children: [
                            Expanded(
                              child: _buildMetricCard(
                                icon: Icons.inventory_2_outlined,
                                label: l10n.listingQuantityLabel,
                                value: quantity,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildMetricCard(
                                icon: Icons.verified_outlined,
                                label: l10n.listingConditionLabel,
                                value: condition,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildMetricCard(
                                icon: Icons.location_on_outlined,
                                label: l10n.location,
                                value: location,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Seller Contact Card (if available)
                        if (contactName != null && contactName.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                                width: 1.0,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.sellerContactDetailsTitle,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF8E8E93),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFEAF8EE),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.person_outline,
                                        size: 18,
                                        color: Color(0xFF00A63E),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        contactName,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF111827),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                        // Segmented Tab Selector (Details | Specs | Timeline)
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              _buildSegmentTab(
                                index: 0,
                                label: l10n.detailsTab,
                              ),
                              _buildSegmentTab(
                                index: 1,
                                label: l10n.specsTab,
                              ),
                              _buildSegmentTab(
                                index: 2,
                                label: l10n.timelineTab,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Tab Content
                        if (_selectedTabIndex == 0)
                          _buildDetailsTab(locationDetail)
                        else if (_selectedTabIndex == 1)
                          _buildSpecsTab()
                        else
                          _buildTimelineTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Bar (Fixed)
          Container(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.priceDemand,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            currentBid,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00A63E),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            l10n.listingIdLabel,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            auctionId,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF00A63E),
                            Color(0xFF007D2E),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BuyerPlaceBidScreen(
                                auctionData: _auction,
                                listing: widget.listing,
                              ),
                            ),
                          );
                          if (result != null && mounted) {
                            setState(() {
                              _auction['currentBid'] = 'PKR $result';
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          l10n.placeBid,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFF3F4F6),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: const Color(0xFF9CA3AF),
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentTab({
    required int index,
    required String label,
  }) {
    final bool isSelected = _selectedTabIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF00A63E)
                    : const Color(0xFF6B7280),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 1. Details Tab
  Widget _buildDetailsTab(String locationDetail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _descriptionText,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF4B5563),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        ListingMapPreviewWidget(
          latitude: widget.listing?.latitude,
          longitude: widget.listing?.longitude,
          pickupCity: widget.listing?.pickupCity ?? _auction['location'] ?? 'Karachi',
          pickupArea: widget.listing?.pickupArea,
          pickupAddress: widget.listing?.pickupAddress.isNotEmpty == true
              ? widget.listing!.pickupAddress
              : locationDetail,
        ),
      ],
    );
  }

  // 2. Specs Tab
  Widget _buildSpecsTab() {
    final List<String> specs = _specsList;

    return Column(
      children: specs.map((spec) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: Color(0xFF00A63E),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  spec,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1F2937),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // 3. Timeline Tab
  Widget _buildTimelineTab() {
    final List<Map<String, dynamic>> timeline = _timelineList;

    return Column(
      children: List.generate(timeline.length, (index) {
        final item = timeline[index];
        final bool isLast = index == timeline.length - 1;
        final bool isCompleted = item['completed'] == true;
        final bool isCurrent = item['current'] == true;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Indicator & Line
              SizedBox(
                width: 24,
                child: Column(
                  children: [
                    // Circle Icon
                    if (isCompleted)
                      Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          color: Color(0xFF00A63E),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 13,
                          ),
                        ),
                      )
                    else if (isCurrent)
                      Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF3F4F6),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF9CA3AF),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      )
                    else
                      Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF3F4F6),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF9CA3AF),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),

                    // Connecting Line
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          color: isCompleted
                              ? const Color(0xFF86EFAC)
                              : const Color(0xFFE5E7EB),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 14),

              // Title and Subtitle
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'] ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['subtitle'] ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

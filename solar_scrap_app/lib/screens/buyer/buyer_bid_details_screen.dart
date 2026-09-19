import 'dart:io';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../models/bid.dart';
import '../../models/listing.dart';
import '../../services/listing_service.dart';
import '../../utils/rtl_helper.dart';
import 'buyer_auction_details_screen.dart';

class BuyerBidDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? bidData;
  final Bid? bid;
  final Listing? listing;

  const BuyerBidDetailsScreen({
    super.key,
    this.bidData,
    this.bid,
    this.listing,
  });

  @override
  State<BuyerBidDetailsScreen> createState() => _BuyerBidDetailsScreenState();
}

class _BuyerBidDetailsScreenState extends State<BuyerBidDetailsScreen> {
  bool _isFavorite = true;
  late Map<String, dynamic> _bid;
  Listing? _listing;
  bool _isLoadingListing = false;
  List<String> _imageUrls = [];
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    final defaultData = {
      'id': '',
      'auctionId': 'A001',
      'title': 'Solar Equipment',
      'image': 'assets/images/buyer-solar.jpg',
      'time': 'Active',
      'status': 'Active',
      'myBidAmount': 'PKR 0',
      'bidDate': 'Recent',
      'currentHighest': 'PKR 0',
      'isFavorite': true,
      'category': 'Solar Equipment',
    };

    _bid = Map<String, dynamic>.from(defaultData);

    if (widget.bid != null) {
      final b = widget.bid!;
      _bid['id'] = b.id;
      _bid['auctionId'] = b.referenceNumber;
      _bid['title'] = b.titleDisplay;
      _bid['image'] = b.listingImage ?? b.fallbackAsset;
      _bid['status'] = b.statusDisplay;
      _bid['myBidAmount'] = b.formattedAmount;
      _bid['currentHighest'] = b.formattedAmount;
      _bid['bidDate'] = b.dateDisplay;
      _bid['time'] = b.statusDisplay;
      _bid['category'] = b.listingCategory ?? 'Solar Equipment';
    } else if (widget.bidData != null) {
      widget.bidData!.forEach((key, value) {
        if (value != null) {
          _bid[key] = value;
        }
      });
      if (_bid['title'] != null) {
        _bid['title'] = _bid['title'].toString().replaceAll('\n', ' ');
      }
      if (widget.bidData!['price'] != null) {
        _bid['myBidAmount'] = widget.bidData!['price'];
        _bid['currentHighest'] = widget.bidData!['price'];
      }
      if (widget.bidData!['date'] != null) {
        _bid['bidDate'] = widget.bidData!['date'];
      }
    }

    if (_bid['isFavorite'] != null) {
      _isFavorite = _bid['isFavorite'] as bool;
    }

    // Apply passed listing or fetch dynamically
    if (widget.listing != null) {
      _applyListingData(widget.listing!);
    } else if (widget.bid != null && widget.bid!.listingId.isNotEmpty) {
      _fetchListingDetails(widget.bid!.listingId);
    }
  }

  Future<void> _fetchListingDetails(String listingId) async {
    setState(() {
      _isLoadingListing = true;
    });
    try {
      final l = await ListingService.instance.fetchListingById(listingId);
      if (l != null && mounted) {
        setState(() {
          _applyListingData(l);
          _isLoadingListing = false;
        });
      } else if (mounted) {
        setState(() {
          _isLoadingListing = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoadingListing = false;
        });
      }
    }
  }

  void _applyListingData(Listing l) {
    _listing = l;
    if (l.title.isNotEmpty) {
      _bid['title'] = l.title;
    }
    if (l.category.isNotEmpty) {
      _bid['category'] = l.category;
    }
    if (l.imageUrls.isNotEmpty) {
      _imageUrls = List<String>.from(l.imageUrls);
      _bid['image'] = l.imageUrls.first;
    }
    if (l.priceDemand > 0) {
      _bid['currentHighest'] = l.formattedPrice;
    }
    _bid['city'] = l.pickupCity;
    _bid['area'] = l.pickupArea;
    _bid['address'] = l.pickupAddress;
    _bid['contactName'] = l.contactName;
    _bid['contactPhone'] = l.contactPhone;
    _bid['contactEmail'] = l.contactEmail;
  }

  String get _fallbackAsset {
    if (widget.bid != null) return widget.bid!.fallbackAsset;
    final cat = (_bid['category'] ?? '').toString().toLowerCase();
    final title = (_bid['title'] ?? '').toString().toLowerCase();
    if (cat.contains('battery') || title.contains('batter')) return 'assets/images/battery.jpg';
    if (cat.contains('inverter') || title.contains('inverter')) return 'assets/images/inverter.png';
    if (cat.contains('cable') || title.contains('cable')) return 'assets/images/cables.jpg';
    if (cat.contains('complete') || title.contains('complete')) return 'assets/images/complete-solar-system.jpg';
    if (cat.contains('structure') || title.contains('structure')) return 'assets/images/structure.jpg';
    return 'assets/images/buyer-solar.jpg';
  }

  String get _normalizedStatus {
    final s = (_bid['status'] ?? 'Active').toString().toLowerCase();
    if (s.contains('accept') || s == 'won') return 'Won';
    if (s.contains('win')) return 'Winning';
    if (s.contains('reject') || s.contains('lost') || s.contains('closed')) return 'Closed';
    if (s.contains('outbid')) return 'Outbid';
    return 'Active';
  }

  Color get _statusBadgeBg {
    switch (_normalizedStatus) {
      case 'Won':
      case 'Winning':
        return const Color(0xFFEAF8EE);
      case 'Active':
        return const Color(0xFFEFF6FF);
      case 'Outbid':
        return const Color(0xFFFEF3C7);
      case 'Closed':
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  Color get _statusBadgeText {
    switch (_normalizedStatus) {
      case 'Won':
      case 'Winning':
        return const Color(0xFF00A63E);
      case 'Active':
        return const Color(0xFF2563EB);
      case 'Outbid':
        return const Color(0xFFD97706);
      case 'Closed':
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _localizedStatus(String status, AppLocalizations l10n) {
    switch (status) {
      case 'Won':
        return l10n.statusWon;
      case 'Winning':
        return l10n.filterWinning;
      case 'Active':
        return l10n.filterActive;
      case 'Outbid':
        return l10n.filterOutbid;
      case 'Closed':
        return l10n.filterClosed;
      default:
        return status;
    }
  }

  List<Map<String, dynamic>> _timelineSteps(AppLocalizations l10n) {
    final status = _normalizedStatus;

    if (status == 'Won') {
      return [
        {'title': l10n.timelineStepBidSubmitted, 'completed': true},
        {'title': l10n.timelineStepUnderSellerReview, 'completed': true},
        {'title': l10n.timelineStepBidAccepted, 'completed': true},
        {'title': l10n.timelineStepDealFinalized, 'completed': true},
      ];
    } else if (status == 'Closed') {
      return [
        {'title': l10n.timelineStepBidSubmitted, 'completed': true},
        {'title': l10n.timelineStepAuctionRunning, 'completed': true},
        {'title': l10n.timelineStepOfferDeclined, 'completed': true},
        {'title': l10n.timelineStepAuctionClosed, 'completed': true},
      ];
    } else if (status == 'Winning') {
      return [
        {'title': l10n.timelineStepBidSubmitted, 'completed': true},
        {'title': l10n.timelineStepHighestBidder, 'completed': true},
        {'title': l10n.timelineStepSellerDecision, 'completed': false},
        {'title': l10n.timelineStepDealFinalized, 'completed': false},
      ];
    } else {
      return [
        {'title': l10n.timelineStepBidSubmitted, 'completed': true},
        {'title': l10n.timelineStepUnderSellerReview, 'completed': true},
        {'title': l10n.timelineStepSellerDecision, 'completed': false},
        {'title': l10n.timelineStepDealFinalized, 'completed': false},
      ];
    }
  }

  Widget _buildImageItem(String pathOrUrl) {
    final fullUrl = ListingService.instance.getFullImageUrl(pathOrUrl);
    if (fullUrl != null && (fullUrl.startsWith('http://') || fullUrl.startsWith('https://'))) {
      return Image.network(
        fullUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          _fallbackAsset,
          fit: BoxFit.cover,
        ),
      );
    } else if (pathOrUrl.startsWith('/data/') ||
        pathOrUrl.startsWith('/storage/') ||
        pathOrUrl.startsWith('file://')) {
      return Image.file(
        File(pathOrUrl.replaceFirst('file://', '')),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          _fallbackAsset,
          fit: BoxFit.cover,
        ),
      );
    }
    return Image.asset(
      pathOrUrl.isNotEmpty && pathOrUrl.startsWith('assets/') ? pathOrUrl : _fallbackAsset,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        _fallbackAsset,
        fit: BoxFit.cover,
      ),
    );
  }

  List<Widget> _buildDynamicSpecsRows(AppLocalizations l10n) {
    final List<Widget> rows = [];
    final specs = _listing?.specs ?? {};
    final category = _bid['category']?.toString() ?? _listing?.category ?? '';

    void addRow(String label, String value) {
      if (value.trim().isEmpty) return;
      if (rows.isNotEmpty) {
        rows.add(const Divider(height: 16, color: Color(0xFFF3F4F6)));
      }
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      );
    }

    addRow(l10n.listingCategoryLabel, category);

    if (category == 'Solar Panels') {
      if (specs['panels_count'] != null) addRow('Number of Panels', '${specs['panels_count']}');
      if (specs['watts_per_panel'] != null) addRow('Watts per Panel', '${specs['watts_per_panel']} W');
      if (specs['panel_condition'] != null) addRow(l10n.listingConditionLabel, '${specs['panel_condition']}');
    } else if (category == 'Batteries') {
      if (specs['battery_type'] != null) addRow('Battery Type', '${specs['battery_type']}');
      if (specs['battery_count'] != null) addRow(l10n.listingQuantityLabel, '${specs['battery_count']}');
      if (specs['battery_capacity'] != null) addRow('Capacity', '${specs['battery_capacity']}');
      if (specs['battery_brand'] != null) addRow('Brand', '${specs['battery_brand']}');
      if (specs['battery_condition'] != null) addRow(l10n.listingConditionLabel, '${specs['battery_condition']}');
    } else if (category == 'Inverters') {
      if (specs['inverter_brand'] != null) addRow('Brand', '${specs['inverter_brand']}');
      if (specs['inverter_type'] != null) addRow('Type', '${specs['inverter_type']}');
      if (specs['rated_power'] != null) addRow('Rated Power', '${specs['rated_power']}');
      if (specs['inverter_condition'] != null) addRow(l10n.listingConditionLabel, '${specs['inverter_condition']}');
    } else if (category == 'Cables') {
      if (specs['cable_type'] != null) addRow('Cable Type', '${specs['cable_type']}');
      if (specs['cable_size'] != null) addRow('Cable Size', '${specs['cable_size']}');
      if (specs['cable_conductor'] != null) addRow(l10n.cableConductor, '${specs['cable_conductor']}');
      if (specs['cable_condition'] != null) addRow(l10n.listingConditionLabel, '${specs['cable_condition']}');
    } else if (category == 'Structure') {
      if (specs['structure_type'] != null) addRow('Structure Type', '${specs['structure_type']}');
      if (specs['structure_metal'] != null) addRow('Metal Material', '${specs['structure_metal']}');
    } else if (category == 'Complete Solar System') {
      if (specs['panels_count'] != null) addRow('Panels', '${specs['panels_count']}x (${specs['watts_per_panel'] ?? ''}W)');
      if (specs['inverter_brand'] != null) addRow('Inverter', '${specs['inverter_brand']} (${specs['inverter_type'] ?? ''})');
      if (specs['battery_count'] != null) addRow('Batteries', '${specs['battery_count']}x ${specs['battery_type'] ?? ''}');
      if (specs['structure_type'] != null) addRow('Structure', '${specs['structure_type']}');
    }

    if (specs['condition'] != null && rows.length <= 2) {
      addRow(l10n.listingConditionLabel, '${specs['condition']}');
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final title = _bid['title'] ?? 'Solar Equipment';
    final auctionId = _bid['auctionId'] ?? 'A005';
    final time = _bid['time'] ?? 'Active';
    final myBidAmount = _bid['myBidAmount'] ?? 'PKR 0';
    final bidDate = _bid['bidDate'] ?? 'Recent';
    final currentHighest = _bid['currentHighest'] ?? 'PKR 0';
    final status = _normalizedStatus;

    final city = _bid['city']?.toString() ?? '';
    final address = _bid['address']?.toString() ?? '';
    final locationDisplay = city.isNotEmpty
        ? (address.isNotEmpty ? '$city, $address' : city)
        : address;

    final contactName = _bid['contactName']?.toString() ?? '';
    final hasContactInfo = contactName.isNotEmpty;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // Top Bar: Back Button & Screen Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F4F6),
                        shape: BoxShape.circle,
                      ),
                      child: RTLHelper.backIcon(
                        context,
                        color: Colors.black87,
                        size: 20,
                      ),
                    ),
                  ),
                  Text(
                    l10n.bidDetails,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
              const SizedBox(height: 16),

              // Hero Image Card (Dynamic PageView Carousel)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFFF3F4F6),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (_imageUrls.isNotEmpty)
                      PageView.builder(
                        controller: _pageController,
                        itemCount: _imageUrls.length,
                        onPageChanged: (idx) {
                          setState(() {
                            _currentImageIndex = idx;
                          });
                        },
                        itemBuilder: (context, index) {
                          return _buildImageItem(_imageUrls[index]);
                        },
                      )
                    else
                      _buildImageItem(_bid['image']?.toString() ?? ''),

                    // Top Featured / Category Badge
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00A63E),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _bid['category']?.toString() ?? 'Solar Equipment',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    // Favorite Heart Button
                    Positioned(
                      top: 12,
                      right: 12,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isFavorite = !_isFavorite;
                          });
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: _isFavorite
                                ? const Color(0xFFEF4444)
                                : const Color(0xFF4B5563),
                            size: 18,
                          ),
                        ),
                      ),
                    ),

                    // Multi-image counter badge
                    if (_imageUrls.length > 1)
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_currentImageIndex + 1}/${_imageUrls.length}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                    // Time / Status Badge Bottom-Left
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 12,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              time,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Title, Auction ID & Status Badge Row
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.auctionIdPrefix(auctionId),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _statusBadgeBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _localizedStatus(status, l10n),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _statusBadgeText,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Bid Details Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFE5E7EB),
                    width: 1.0,
                  ),
                ),
                child: Column(
                  children: [
                    // My Bid Amount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.myBidAmount,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        Text(
                          myBidAmount,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00A63E),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Bid Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.bidDate,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        Text(
                          bidDate,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Current Highest
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.currentHighest,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        Text(
                          currentHighest,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Dynamic Equipment Specifications Card
              if (_isLoadingListing) ...[
                const SizedBox(height: 20),
                const Center(
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF00A63E)),
                  ),
                ),
              ] else if (_buildDynamicSpecsRows(l10n).isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(
                  l10n.equipmentSpecifications,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Column(
                    children: _buildDynamicSpecsRows(l10n),
                  ),
                ),
              ],

              // Dynamic Pickup Location Card
              if (locationDisplay.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(
                  l10n.pickupLocationTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF8EE),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Color(0xFF00A63E),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              city.isNotEmpty ? city : l10n.pickupLocationTitle,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              locationDisplay,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Seller Contact Information (Visible especially if Won/Accepted)
              if (hasContactInfo && (status == 'Won' || status == 'Winning')) ...[
                const SizedBox(height: 20),
                Text(
                  l10n.sellerContactInformation,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFBBF7D0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person, size: 18, color: Color(0xFF00A63E)),
                      const SizedBox(width: 10),
                      Text(
                        contactName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // View Full Auction Page Button
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF00A63E), width: 1.5),
                ),
                child: TextButton.icon(
                  onPressed: () async {
                    if (_listing != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BuyerAuctionDetailsScreen(listing: _listing),
                        ),
                      );
                    } else if (widget.bid != null && widget.bid!.listingId.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.loadingAuctionDetails)),
                      );
                      final l = await ListingService.instance.fetchListingById(widget.bid!.listingId);
                      if (!mounted) return;
                      if (l != null) {
                        Navigator.push(
                          this.context,
                          MaterialPageRoute(
                            builder: (ctx) => BuyerAuctionDetailsScreen(listing: l),
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.open_in_new, color: Color(0xFF00A63E), size: 18),
                  label: Text(
                    l10n.viewFullAuctionListing,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00A63E),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Timeline Section
              Text(
                l10n.timelineTab,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 16),

              // Stepper List
              _buildTimelineStepper(l10n),

              // Contextual Status Banners
              if (status == 'Won') ...[
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF8EE),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF86EFAC)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_circle_outline,
                          color: Color(0xFF00A63E),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.bidAcceptedBannerTitle,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00A63E),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              l10n.bidAcceptedBannerDesc,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF4B5563),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (status == 'Winning') ...[
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF8EE),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.workspace_premium_outlined,
                          color: Color(0xFF00A63E),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.bidWinningBannerTitle,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00A63E),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              l10n.bidWinningBannerDesc,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF4B5563),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (status == 'Active') ...[
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.schedule_outlined,
                          color: Color(0xFF2563EB),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.bidActiveBannerTitle,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E40AF),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              l10n.bidActiveBannerDesc,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF4B5563),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (status == 'Outbid') ...[
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.trending_up,
                          color: Color(0xFFD97706),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.bidOutbidBannerTitle,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF92400E),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              l10n.bidOutbidBannerDesc,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF4B5563),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineStepper(AppLocalizations l10n) {
    final steps = _timelineSteps(l10n);

    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final bool isLast = index == steps.length - 1;
        final bool isCompleted = step['completed'] == true;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                child: Column(
                  children: [
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
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 28),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      step['title'] ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
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

import 'package:flutter/material.dart';
import 'buyer_place_bid_screen.dart';

class BuyerAuctionDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? auctionData;

  const BuyerAuctionDetailsScreen({
    super.key,
    this.auctionData,
  });

  @override
  State<BuyerAuctionDetailsScreen> createState() =>
      _BuyerAuctionDetailsScreenState();
}

class _BuyerAuctionDetailsScreenState extends State<BuyerAuctionDetailsScreen> {
  int _selectedTabIndex = 0; // 0: Details, 1: Specs, 2: Timeline
  bool _isFavorite = true;

  late Map<String, dynamic> _auction;

  @override
  void initState() {
    super.initState();
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
      'timeLeft': '2h 34m',
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
          'subtitle': 'Jul 20, 2026 · 10:00 AM',
          'completed': true,
        },
        {
          'title': 'Auction Live',
          'subtitle': 'Jul 21, 2026 · 08:00 AM',
          'completed': true,
        },
        {
          'title': 'Auction Ends',
          'subtitle': 'Jul 23, 2026 · 2h 34m remaining',
          'completed': false,
          'current': true,
        },
        {
          'title': 'Winner Notified',
          'subtitle': 'After auction closes',
          'completed': false,
          'current': false,
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
      if (widget.auctionData!['time'] != null) {
        _auction['timeLeft'] = widget.auctionData!['time'];
      }
      if (widget.auctionData!['units'] != null) {
        _auction['quantity'] = widget.auctionData!['units'];
      }
      if (widget.auctionData!['location'] != null) {
        _auction['locationDetail'] =
            '${widget.auctionData!['location']}, Industrial Area';
      }
    }

    if (_auction['isFavorite'] != null) {
      _isFavorite = _auction['isFavorite'] as bool;
    }
  }

  String get _descriptionText {
    if (_auction['description'] != null &&
        (_auction['description'] as String).isNotEmpty) {
      return _auction['description'];
    }
    return 'High-efficiency 400W monocrystalline panels from a decommissioned 500kW solar farm. Panels are in good working condition with minor cosmetic wear.';
  }

  List<String> get _specsList {
    if (_auction['specs'] != null &&
        (_auction['specs'] as List).isNotEmpty) {
      return List<String>.from(_auction['specs']);
    }
    final title = (_auction['title'] ?? '').toString().toLowerCase();
    if (title.contains('inverter')) {
      return [
        '5kW continuous output power',
        '97.8% maximum efficiency',
        '10-year manufacturer warranty',
        'IP65 weatherproof enclosure',
      ];
    } else if (title.contains('battery')) {
      return [
        '48V 100Ah capacity (4.8kWh)',
        '6,000+ cycle life at 80% DoD',
        'Built-in smart BMS protection',
        'Wall mountable design',
      ];
    } else if (title.contains('transformer')) {
      return [
        '100kVA rated capacity',
        'Oil-immersed cooling system',
        'Copper winding standard',
        'High overload capacity',
      ];
    }
    return [
      '400W rated power',
      '21.3% efficiency',
      '25-year warranty remaining (5yr)',
      'Silver frame',
    ];
  }

  List<Map<String, dynamic>> get _timelineList {
    if (_auction['timeline'] != null &&
        (_auction['timeline'] as List).isNotEmpty) {
      return List<Map<String, dynamic>>.from(_auction['timeline']);
    }
    final remainingTime = _auction['timeLeft'] ?? _auction['time'] ?? '2h 34m';
    return [
      {
        'title': 'Auction Created',
        'subtitle': 'Jul 20, 2026 · 10:00 AM',
        'completed': true,
      },
      {
        'title': 'Auction Live',
        'subtitle': 'Jul 21, 2026 · 08:00 AM',
        'completed': true,
      },
      {
        'title': 'Auction Ends',
        'subtitle': 'Jul 23, 2026 · $remainingTime remaining',
        'completed': false,
        'current': true,
      },
      {
        'title': 'Winner Notified',
        'subtitle': 'After auction closes',
        'completed': false,
        'current': false,
      },
    ];
  }


  @override
  Widget build(BuildContext context) {
    final imagePath = _auction['image'] ?? 'assets/images/buyer-solar.jpg';
    final title = _auction['title'] ?? 'Monocrystalline Solar Panels';
    final category = _auction['category'] ?? 'Solar Panels';
    final startingBid = _auction['startingBid'] ?? 'PKR 85,000';
    final currentBid = _auction['currentBid'] ?? 'PKR 92,000';
    final quantity = _auction['quantity'] ?? '150 units';
    final condition = _auction['condition'] ?? 'Good';
    final location = _auction['location'] ?? 'Karachi';
    final locationDetail =
        _auction['locationDetail'] ?? 'Karachi, SITE Area';
    final timeLeft = _auction['timeLeft'] ?? '2h 34m';
    final auctionId = _auction['id'] ?? 'A001';

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
                      // Image
                      SizedBox(
                        height: 270,
                        width: double.infinity,
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                        ),
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
                                Colors.black.withValues(alpha: 0.5),
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
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.4),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_back,
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
                                    setState(() {
                                      _isFavorite = !_isFavorite;
                                    });
                                  },
                                  child: Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.black.withValues(alpha: 0.4),
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
                                const SizedBox(width: 10),

                                // Share Button
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.share_outlined,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Bottom Overlay Badges
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Row(
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
                                children: const [
                                  Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Verified Seller',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Ends In Badge
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
                                    'Ends in $timeLeft',
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
                                const Text(
                                  'Starting Bid',
                                  style: TextStyle(
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
                                label: 'Quantity',
                                value: quantity,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildMetricCard(
                                icon: Icons.star_border_rounded,
                                label: 'Condition',
                                value: condition,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildMetricCard(
                                icon: Icons.location_on_outlined,
                                label: 'Location',
                                value: location,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

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
                                label: 'Details',
                              ),
                              _buildSegmentTab(
                                index: 1,
                                label: 'Specs',
                              ),
                              _buildSegmentTab(
                                index: 2,
                                label: 'Timeline',
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
                          const Text(
                            'Current Highest Bid',
                            style: TextStyle(
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
                          const Text(
                            'Auction ID',
                            style: TextStyle(
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
                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BuyerPlaceBidScreen(auctionData: _auction),
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
                      child: const Text(
                        'Place Bid',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: const Color(0xFF00A63E),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
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
        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 18,
              color: Color(0xFF00A63E),
            ),
            const SizedBox(width: 6),
            Text(
              locationDetail,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
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

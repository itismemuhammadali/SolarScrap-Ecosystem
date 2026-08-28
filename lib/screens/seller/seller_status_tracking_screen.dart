import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'seller_price_offer_screen.dart';

class SellerStatusTrackingScreen extends StatefulWidget {
  final String currentStatus;

  const SellerStatusTrackingScreen({
    super.key,
    this.currentStatus = 'Price Offered',
  });

  @override
  State<SellerStatusTrackingScreen> createState() =>
      _SellerStatusTrackingScreenState();
}

class _SellerStatusTrackingScreenState
    extends State<SellerStatusTrackingScreen> {
  static const LinearGradient primaryGreenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF00A63E),
      Color(0xFF007D2E),
    ],
  );

  @override
  void initState() {
    super.initState();
    if (widget.currentStatus == 'Price Offered') {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _navigateToPriceOffer();
        }
      });
    }
  }

  void _navigateToPriceOffer() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SellerPriceOfferScreen(),
      ),
    );
  }

  final List<Map<String, dynamic>> _statusFlow = [
    {
      'title': 'Submitted',
      'subtitle': 'Dec 18, 09:30 AM',
      'isCompleted': true,
      'isActive': false,
    },
    {
      'title': 'Under Review',
      'subtitle': 'Admin reviewing your listing',
      'isCompleted': true,
      'isActive': false,
    },
    {
      'title': 'Price Offered',
      'subtitle': 'Awaiting your response',
      'badge': 'Action Required',
      'isCompleted': false,
      'isActive': true,
    },
    {
      'title': 'Negotiation',
      'subtitle': 'Pending',
      'isCompleted': false,
      'isActive': false,
    },
    {
      'title': 'Deal Closed',
      'subtitle': 'Pending',
      'isCompleted': false,
      'isActive': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Status Tracking',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Listing Info Card
              GestureDetector(
                onTap: () {
                  if (widget.currentStatus == 'Price Offered') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const SellerPriceOfferScreen(),
                      ),
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: primaryGreenGradient,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/icons/stocks.svg',
                            width: 18,
                            height: 18,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '200x Solar Panels 400W',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 2),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF6B7280),
                                ),
                                children: [
                                  const TextSpan(text: 'SS-2024-001 · Currently: '),
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: ShaderMask(
                                      blendMode: BlendMode.srcIn,
                                      shaderCallback: (bounds) =>
                                          primaryGreenGradient.createShader(bounds),
                                      child: Text(
                                        widget.currentStatus,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
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
                ),
              ),
              const SizedBox(height: 28),

              // Status Timeline List
              ..._statusFlow.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> status = entry.value;
                bool isLast = index == _statusFlow.length - 1;

                return _buildStatusItem(
                  status: status,
                  isLast: isLast,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusItem({
    required Map<String, dynamic> status,
    required bool isLast,
  }) {
    bool isCompleted = status['isCompleted'] as bool;
    bool isActive = status['isActive'] as bool;

    return IntrinsicHeight(
      child: GestureDetector(
        onTap: isActive ? _navigateToPriceOffer : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline Node & Connecting Line
            Column(
              children: [
                // Node Circle
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    gradient: isActive ? primaryGreenGradient : null,
                    color: isActive
                        ? null
                        : isCompleted
                            ? const Color(0xFFDCFCE7)
                            : const Color(0xFFF3F4F6),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isCompleted
                        ? ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (bounds) =>
                                primaryGreenGradient.createShader(bounds),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            ),
                          )
                        : isActive
                            ? SvgPicture.asset(
                                'assets/icons/price-offered.svg',
                                width: 12,
                                height: 12,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              )
                            : SvgPicture.asset(
                                'assets/icons/price-offered.svg',
                                width: 12,
                                height: 12,
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFF9CA3AF),
                                  BlendMode.srcIn,
                                ),
                              ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      color: isCompleted
                          ? const Color(0xFF86EFAC)
                          : const Color(0xFFE5E7EB),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),

            // Content Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          status['title'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isActive || isCompleted
                                ? Colors.black
                                : const Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        if (isActive)
                          ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (bounds) =>
                                primaryGreenGradient.createShader(bounds),
                            child: Text(
                              status['subtitle'] as String,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        else
                          Text(
                            status['subtitle'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              color: isCompleted
                                  ? const Color(0xFF6B7280)
                                  : const Color(0xFFD1D5DB),
                            ),
                          ),
                      ],
                    ),
                    if (status['badge'] != null) ...[
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: _navigateToPriceOffer,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  gradient: primaryGreenGradient,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (bounds) =>
                                    primaryGreenGradient.createShader(bounds),
                                child: Text(
                                  status['badge'] as String,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

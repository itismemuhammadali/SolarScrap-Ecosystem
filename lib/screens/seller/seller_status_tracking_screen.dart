import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'seller_price_offer_screen.dart';

class SellerStatusTrackingScreen extends StatefulWidget {
  final String? currentStatus;

  const SellerStatusTrackingScreen({
    this.currentStatus = 'Price Offered',
    super.key,
  });

  @override
  State<SellerStatusTrackingScreen> createState() =>
      _SellerStatusTrackingScreenState();
}

class _SellerStatusTrackingScreenState
    extends State<SellerStatusTrackingScreen> {
  late List<Map<String, dynamic>> _statusFlow;

  @override
  void initState() {
    super.initState();
    _initializeStatusFlow();
    
    // Navigate to Price Offer screen after 2 seconds if status is "Price Offered"
    if (widget.currentStatus == 'Price Offered') {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SellerPriceOfferScreen(),
            ),
          );
        }
      });
    }
  }

  void _initializeStatusFlow() {
    _statusFlow = [
      {
        'title': 'Submitted',
        'subtitle': 'Dec 18, 09:30 AM',
        'isCompleted': _isStatusCompleted('Submitted'),
        'isActive': widget.currentStatus == 'Submitted',
      },
      {
        'title': 'Under Review',
        'subtitle': 'Admin reviewing your listing',
        'isCompleted': _isStatusCompleted('Under Review'),
        'isActive': widget.currentStatus == 'Under Review',
      },
      {
        'title': 'Price Offered',
        'subtitle': 'Awaiting your response',
        'badge': 'Action Required',
        'isCompleted': _isStatusCompleted('Price Offered'),
        'isActive': widget.currentStatus == 'Price Offered',
      },
      {
        'title': 'Negotiation',
        'subtitle': 'Pending',
        'isCompleted': _isStatusCompleted('Negotiation'),
        'isActive': false,
      },
      {
        'title': 'Deal Closed',
        'subtitle': 'Pending',
        'isCompleted': _isStatusCompleted('Deal Closed'),
        'isActive': false,
      },
    ];
  }

  bool _isStatusCompleted(String status) {
    final statusOrder = [
      'Submitted',
      'Under Review',
      'Price Offered',
      'Negotiation',
      'Deal Closed'
    ];
    final currentIndex = statusOrder.indexOf(widget.currentStatus ?? 'Submitted');
    final statusIndex = statusOrder.indexOf(status);
    return statusIndex < currentIndex;
  }

  @override
  Widget build(BuildContext context) {
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
              color: Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black87,
              size: 18,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          'Status Tracking',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Banner Summary Card
              Container(
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
                      decoration: BoxDecoration(
                        color: const Color(0xFF00A63E),
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
                                TextSpan(
                                  text: widget.currentStatus,
                                  style: const TextStyle(
                                    color: Color(0xFF00A63E),
                                    fontWeight: FontWeight.w600,
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
                  color: isActive
                      ? const Color(0xFF00A63E)
                      : isCompleted
                          ? const Color(0xFFDCFCE7)
                          : const Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(
                          Icons.check,
                          color: Color(0xFF00A63E),
                          size: 16,
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
                    color: const Color(0xFFE5E7EB),
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
                      Text(
                        status['subtitle'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: isActive
                              ? const Color(0xFF00A63E)
                              : isCompleted
                                  ? const Color(0xFF6B7280)
                                  : const Color(0xFFD1D5DB),
                        ),
                      ),
                    ],
                  ),
                  if (status['badge'] != null) ...[
                    const SizedBox(height: 6),
                    Container(
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
                              color: Color(0xFF00A63E),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            status['badge'] as String,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF00A63E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

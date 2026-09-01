import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/bid.dart';

class BuyerBidDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? bidData;
  final Bid? bid;

  const BuyerBidDetailsScreen({
    super.key,
    this.bidData,
    this.bid,
  });

  @override
  State<BuyerBidDetailsScreen> createState() => _BuyerBidDetailsScreenState();
}

class _BuyerBidDetailsScreenState extends State<BuyerBidDetailsScreen> {
  bool _isFavorite = true;
  late Map<String, dynamic> _bid;

  @override
  void initState() {
    super.initState();
    final defaultData = {
      'id': 'bid-1',
      'auctionId': 'A005',
      'title': 'DC Cable Bundle 6mm²',
      'image': 'assets/images/cables.jpg',
      'time': '2h 34m',
      'status': 'Closed', // 'Winning', 'Outbid', 'Closed'
      'myBidAmount': 'PKR 29,000',
      'bidDate': 'Jul 20, 2026',
      'currentHighest': 'PKR 31,000',
      'isFavorite': true,
    };

    _bid = Map<String, dynamic>.from(defaultData);

    if (widget.bid != null) {
      final b = widget.bid!;
      _bid['id'] = b.id;
      _bid['auctionId'] = b.referenceNumber;
      _bid['title'] = b.titleDisplay;
      _bid['image'] = b.displayImage;
      _bid['status'] = b.statusDisplay;
      _bid['myBidAmount'] = b.formattedAmount;
      _bid['currentHighest'] = b.formattedAmount;
      _bid['bidDate'] = b.dateDisplay;
      _bid['time'] = 'Active';
    } else if (widget.bidData != null) {
      widget.bidData!.forEach((key, value) {
        if (value != null) {
          _bid[key] = value;
        }
      });
      // Clean up multi-line title if present
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
  }

  String get _normalizedStatus {
    final s = (_bid['status'] ?? 'Closed').toString().toLowerCase();
    if (s.contains('win')) return 'Winning';
    if (s.contains('outbid') || s.contains('active')) return 'Outbid';
    return 'Closed';
  }

  Color get _statusBadgeBg {
    switch (_normalizedStatus) {
      case 'Winning':
        return const Color(0xFFEAF8EE);
      case 'Outbid':
        return const Color(0xFFFEF3C7);
      case 'Closed':
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  Color get _statusBadgeText {
    switch (_normalizedStatus) {
      case 'Winning':
        return const Color(0xFF00A63E);
      case 'Outbid':
        return const Color(0xFFD97706);
      case 'Closed':
      default:
        return const Color(0xFF6B7280);
    }
  }

  List<Map<String, dynamic>> get _timelineSteps {
    final status = _normalizedStatus;

    if (status == 'Closed') {
      return [
        {
          'title': 'Bid Submitted',
          'completed': true,
        },
        {
          'title': 'Auction Running',
          'completed': true,
        },
        {
          'title': 'Winner Selected',
          'completed': true,
        },
        {
          'title': 'Auction Closed',
          'completed': true,
        },
      ];
    } else if (status == 'Winning') {
      return [
        {
          'title': 'Bid Submitted',
          'completed': true,
        },
        {
          'title': 'Auction Running',
          'completed': true,
        },
        {
          'title': 'Winner Selected',
          'completed': true,
        },
        {
          'title': 'Auction Closed',
          'completed': false,
        },
      ];
    } else {
      // Outbid / Active
      return [
        {
          'title': 'Bid Submitted',
          'completed': true,
        },
        {
          'title': 'Auction Running',
          'completed': true,
        },
        {
          'title': 'Winner Selected',
          'completed': false,
        },
        {
          'title': 'Auction Closed',
          'completed': false,
        },
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final image = _bid['image'] ?? 'assets/images/cables.jpg';
    final title = _bid['title'] ?? 'DC Cable Bundle 6mm²';
    final auctionId = _bid['auctionId'] ?? 'A005';
    final time = _bid['time'] ?? '2h 34m';
    final myBidAmount = _bid['myBidAmount'] ?? 'PKR 29,000';
    final bidDate = _bid['bidDate'] ?? 'Jul 20, 2026';
    final currentHighest = _bid['currentHighest'] ?? 'PKR 31,000';
    final status = _normalizedStatus;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // Back Button
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3F4F6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black87,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              const Text(
                'Bid Details',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 20),

              // Hero Image Card
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Builder(
                      builder: (context) {
                        final imgStr = image.toString();
                        if (imgStr.startsWith('http://') || imgStr.startsWith('https://')) {
                          return Image.network(
                            imgStr,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Image.asset(
                              'assets/images/buyer-solar.jpg',
                              fit: BoxFit.cover,
                            ),
                          );
                        } else if (imgStr.startsWith('/data/') ||
                            imgStr.startsWith('/storage/') ||
                            imgStr.startsWith('/sdcard/') ||
                            imgStr.startsWith('file://')) {
                          return Image.file(
                            File(imgStr.replaceFirst('file://', '')),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Image.asset(
                              'assets/images/buyer-solar.jpg',
                              fit: BoxFit.cover,
                            ),
                          );
                        }
                        return Image.asset(
                          imgStr.isNotEmpty ? imgStr : 'assets/images/buyer-solar.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Image.asset(
                            'assets/images/buyer-solar.jpg',
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),

                    // Top Featured Badge
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
                        child: const Text(
                          'Featured',
                          style: TextStyle(
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

                    // Time Badge Bottom-Left
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
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Auction ID: $auctionId',
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
                      status,
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
                        const Text(
                          'My Bid Amount',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        Text(
                          myBidAmount,
                          style: const TextStyle(
                            fontSize: 14,
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
                        const Text(
                          'Bid Date',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        Text(
                          bidDate,
                          style: const TextStyle(
                            fontSize: 14,
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
                        const Text(
                          'Current Highest',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        Text(
                          currentHighest,
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
              ),
              const SizedBox(height: 24),

              // Timeline Section
              const Text(
                'Timeline',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 16),

              // Stepper List
              _buildTimelineStepper(),

              // Winning Banner (only if status is Winning)
              if (status == 'Winning') ...[
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
                          children: const [
                            Text(
                              "You're currently winning!",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00A63E),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Admin will contact you if you win.',
                              style: TextStyle(
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

  Widget _buildTimelineStepper() {
    final steps = _timelineSteps;

    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final bool isLast = index == steps.length - 1;
        final bool isCompleted = step['completed'] == true;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Indicator & Vertical Line
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

                    // Vertical Line
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

              // Title
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

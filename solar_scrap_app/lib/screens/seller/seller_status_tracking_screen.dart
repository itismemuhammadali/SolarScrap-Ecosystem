import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../l10n/app_localizations.dart';
import '../../models/bid.dart';
import '../../models/listing.dart';
import '../../services/bid_service.dart';
import '../../services/push_notification_service.dart';
import '../../utils/rtl_helper.dart';
import 'seller_price_offer_screen.dart';

class SellerStatusTrackingScreen extends StatefulWidget {
  final String currentStatus;
  final Listing? listing;

  const SellerStatusTrackingScreen({
    super.key,
    this.currentStatus = 'Price Offered',
    this.listing,
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

  List<Bid> _bids = [];
  bool _isLoadingBids = false;

  @override
  void initState() {
    super.initState();
    PushNotificationService.onNotificationReceived.addListener(_onPushReceived);
    _loadListingBids();
  }

  @override
  void dispose() {
    PushNotificationService.onNotificationReceived.removeListener(_onPushReceived);
    super.dispose();
  }

  void _onPushReceived() {
    _silentLoadListingBids();
  }

  Future<void> _silentLoadListingBids() async {
    if (widget.listing == null) return;
    final fetched = await BidService.instance.fetchBidsForListing(widget.listing!.id);
    if (!mounted) return;
    setState(() {
      _bids = fetched;
    });
  }

  Future<void> _loadListingBids() async {
    if (widget.listing == null) return;
    setState(() => _isLoadingBids = true);
    final fetched = await BidService.instance.fetchBidsForListing(widget.listing!.id);
    if (!mounted) return;
    setState(() {
      _bids = fetched;
      _isLoadingBids = false;
    });
  }

  void _navigateToPriceOffer([Bid? bid]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SellerPriceOfferScreen(
          listing: widget.listing,
          bid: bid ?? (_bids.isNotEmpty ? _bids.first : null),
        ),
      ),
    );
    if (result == true) {
      _loadListingBids();
    }
  }

  String get _displayTitle {
    if (widget.listing != null) return widget.listing!.title;
    return '200x Solar Panels 400W';
  }

  String get _displayRef {
    if (widget.listing != null) {
      final idStr = widget.listing!.id.length >= 6
          ? widget.listing!.id.substring(0, 6).toUpperCase()
          : widget.listing!.id.toUpperCase();
      return 'SS-$idStr';
    }
    return 'SS-2024-001';
  }

  String get _effectiveStatus {
    if (_bids.any((b) => b.status == 'accepted')) return 'Deal Closed';
    if (_bids.isNotEmpty) return 'Price Offered';
    return widget.currentStatus;
  }

  String _getEffectiveStatus(AppLocalizations l10n) {
    if (_bids.any((b) => b.status == 'accepted')) return l10n.dealClosed;
    if (_bids.isNotEmpty) return l10n.filterPriceOffered;
    if (widget.currentStatus == 'Price Offered') return l10n.filterPriceOffered;
    return widget.currentStatus;
  }

  List<Map<String, dynamic>> _getStatusFlow(AppLocalizations l10n) {
    final status = _effectiveStatus;
    final isClosed = status == 'Deal Closed';
    final hasOffers = _bids.isNotEmpty || status == 'Price Offered';

    return [
      {
        'title': l10n.filterSubmitted,
        'subtitle': widget.listing?.createdFormatted ?? 'Dec 18, 09:30 AM',
        'isCompleted': true,
        'isActive': false,
      },
      {
        'title': l10n.activeOnMarket,
        'subtitle': l10n.acceptingBidsFromBuyers,
        'isCompleted': true,
        'isActive': false,
      },
      {
        'title': l10n.filterPriceOffered,
        'subtitle': hasOffers
            ? l10n.bidsReceivedCount(_bids.length)
            : l10n.awaitingBuyerBids,
        'badge': hasOffers && !isClosed ? l10n.actionRequired : null,
        'isCompleted': isClosed,
        'isActive': hasOffers && !isClosed,
      },
      {
        'title': l10n.negotiationReview,
        'subtitle': isClosed
            ? l10n.statusCompleted
            : (_bids.isNotEmpty
                ? l10n.reviewingOffersCount(_bids.length)
                : l10n.awaitingBuyerOffers),
        'isCompleted': isClosed,
        'isActive': false,
      },
      {
        'title': l10n.dealClosed,
        'subtitle': isClosed ? l10n.offerAccepted : l10n.pendingAgreement,
        'isCompleted': isClosed,
        'isActive': isClosed,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final statusFlow = _getStatusFlow(l10n);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: RTLHelper.backIcon(context, color: Colors.black, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.statusTrackingTitle,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadListingBids,
          color: const Color(0xFF00A63E),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              // Header Listing Info Card
              GestureDetector(
                onTap: _bids.isNotEmpty ? () => _navigateToPriceOffer(_bids.first) : null,
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
                            Text(
                              _displayTitle,
                              style: const TextStyle(
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
                                  TextSpan(text: '$_displayRef · ${l10n.currentlyLabel}'),
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: ShaderMask(
                                      blendMode: BlendMode.srcIn,
                                      shaderCallback: (bounds) =>
                                          primaryGreenGradient.createShader(bounds),
                                      child: Text(
                                        _getEffectiveStatus(l10n),
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
              ...statusFlow.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> status = entry.value;
                bool isLast = index == statusFlow.length - 1;

                return _buildStatusItem(
                  status: status,
                  isLast: isLast,
                );
              }),

              const SizedBox(height: 16),
              const Divider(color: Color(0xFFE5E7EB), thickness: 1),
              const SizedBox(height: 16),

              // Bids Received Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.bidsReceived,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (_bids.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF8EE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        l10n.totalBadge(_bids.length),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00A63E),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Bids List or Loading
              if (_isLoadingBids)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: CircularProgressIndicator(color: Color(0xFF00A63E)),
                  ),
                )
              else if (_bids.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFF3F4F6)),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.gavel_outlined, size: 32, color: Colors.grey.shade400),
                      const SizedBox(height: 8),
                      Text(
                        l10n.noBidsPlacedYet,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.bidsWillAppearRealtime,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ..._bids.map((bid) => _buildBidCard(bid, l10n)),

              const SizedBox(height: 32),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildBidCard(Bid bid, AppLocalizations l10n) {
    final isAccepted = bid.status.toLowerCase() == 'accepted';
    final isRejected = bid.status.toLowerCase() == 'rejected';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isAccepted
              ? const Color(0xFF86EFAC)
              : const Color(0xFFE5E7EB),
          width: isAccepted ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xFFEAF8EE),
                    child: Text(
                      bid.buyerName.isNotEmpty ? bid.buyerName[0].toUpperCase() : 'B',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00A63E),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bid.buyerName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        bid.dateDisplay,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isAccepted
                      ? const Color(0xFFEAF8EE)
                      : isRejected
                          ? const Color(0xFFFEE2E2)
                          : const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isAccepted
                      ? l10n.statusAccepted
                      : isRejected
                          ? l10n.statusDeclined
                          : l10n.statusPendingOffer,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isAccepted
                        ? const Color(0xFF00A63E)
                        : isRejected
                            ? const Color(0xFFDC2626)
                            : const Color(0xFF2563EB),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.offerAmount,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  Text(
                    bid.formattedAmount,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00A63E),
                    ),
                  ),
                ],
              ),
              if (!isAccepted && !isRejected)
                ElevatedButton(
                  onPressed: () => _navigateToPriceOffer(bid),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A63E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.reviewOffer,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
            ],
          ),
        ],
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
        onTap: isActive ? () => _navigateToPriceOffer() : null,
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
                        onTap: () => _navigateToPriceOffer(),
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

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/rtl_helper.dart';
import '../../models/listing.dart';
import '../../models/notification_item.dart';
import '../../models/seller_profile.dart';
import '../../models/seller_stats.dart';
import '../../services/listing_service.dart';
import '../../services/notification_service.dart';
import '../../services/profile_service.dart';
import '../../services/push_notification_service.dart';
import 'seller_edit_profile_screen.dart';
import 'seller_settings_screen.dart';
import 'seller_new_listing_screen.dart';
import 'seller_listing_details_screen.dart';
import 'seller_status_tracking_screen.dart';
import '../role_selection_screen.dart';
import '../../services/auth_service.dart';


class SellerDashboardScreen extends StatefulWidget {
  const SellerDashboardScreen({super.key});

  @override
  State<SellerDashboardScreen> createState() => _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends State<SellerDashboardScreen>
    with WidgetsBindingObserver {
  int _selectedIndex = 0;
  String _selectedFilter = 'All';
  String _searchQuery = '';

  String _getSellerFilterDisplay(String filter, AppLocalizations l10n) {
    switch (filter) {
      case 'All':
        return l10n.filterAll;
      case 'Active':
        return l10n.filterActive;
      case 'Submitted':
        return l10n.filterSubmitted;
      case 'Under Review':
        return l10n.filterUnderReview;
      case 'Price Offered':
        return l10n.filterPriceOffered;
      default:
        return filter;
    }
  }

  SellerProfile? _profile;
  SellerStats? _stats;
  List<Listing> _myListings = [];
  List<NotificationItem> _notifications = [];
  bool _isProfileLoading = false;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    PushNotificationService.onNotificationReceived.addListener(_onPushReceived);
    _loadProfileData();
    // Silent background poll every 25 seconds while dashboard is open
    _pollTimer = Timer.periodic(const Duration(seconds: 25), (_) {
      _silentRefresh();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    PushNotificationService.onNotificationReceived.removeListener(_onPushReceived);
    _pollTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _silentRefresh();
    }
  }

  void _onPushReceived() {
    _silentRefresh();
  }

  Future<void> _silentRefresh() async {
    if (!mounted) return;
    try {
      final notifsFuture = NotificationService.instance.fetchNotifications();
      final listingsFuture = ListingService.instance.fetchMyListings();
      final statsFuture = ProfileService.instance.fetchStats();
      final results = await Future.wait([notifsFuture, listingsFuture, statsFuture]);
      if (!mounted) return;
      setState(() {
        final fetchedNotifs = results[0] as List<NotificationItem>;
        if (fetchedNotifs.isNotEmpty) {
          _notifications = fetchedNotifs;
        }
        final fetchedListings = results[1] as List<Listing>;
        _myListings = fetchedListings;
        _allListings = fetchedListings.map((l) => _mapListingToDashboard(l)).toList();
        if (results[2] != null) {
          _stats = results[2] as SellerStats;
        }
      });
    } catch (_) {}
  }

  Future<void> _loadProfileData() async {
    setState(() => _isProfileLoading = true);
    final profileFuture = ProfileService.instance.fetchProfile();
    final statsFuture = ProfileService.instance.fetchStats();
    final listingsFuture = ListingService.instance.fetchMyListings();
    final notifsFuture = NotificationService.instance.fetchNotifications();

    final results = await Future.wait([profileFuture, statsFuture, listingsFuture, notifsFuture]);
    if (!mounted) return;

    setState(() {
      if (results[0] != null) {
        _profile = results[0] as SellerProfile;
      }
      if (results[1] != null) {
        _stats = results[1] as SellerStats;
      }
      final fetchedListings = results[2] as List<Listing>;
      _myListings = fetchedListings;
      _allListings = fetchedListings.map((l) => _mapListingToDashboard(l)).toList();
      final fetchedNotifs = results[3] as List<NotificationItem>;
      if (fetchedNotifs.isNotEmpty) {
        _notifications = fetchedNotifs;
      } else {
        _notifications = [
          NotificationItem(
            id: 'sn-1',
            userId: 'user',
            type: 'account_verified',
            title: 'Account Verified!',
            description:
                'Your seller profile and documents have been verified. You can now publish unlimited solar listings.',
            createdAt: DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
            isRead: false,
          ),
          NotificationItem(
            id: 'sn-2',
            userId: 'user',
            type: 'listing_published',
            title: 'Listing Published!',
            description:
                'Your Monocrystalline Solar Panels listing is now live and accepting bids.',
            createdAt: DateTime.now().subtract(const Duration(minutes: 30)).toIso8601String(),
            isRead: false,
          ),
          NotificationItem(
            id: 'sn-3',
            userId: 'user',
            type: 'new_bid_received',
            title: 'New Bid Received!',
            description:
                'A buyer placed a new highest bid of PKR 92,000 on your Monocrystalline Solar Panels.',
            createdAt: DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
            isRead: true,
          ),
          NotificationItem(
            id: 'sn-4',
            userId: 'user',
            type: 'auction_ending_24h',
            title: 'Auction Ends in 24 Hours',
            description:
                'Your String Inverters 5kW lot auction closes tomorrow at 5:00 PM.',
            createdAt: DateTime.now().subtract(const Duration(hours: 6)).toIso8601String(),
            isRead: true,
          ),
          NotificationItem(
            id: 'sn-5',
            userId: 'user',
            type: 'deal_closed',
            title: 'Deal Closed!',
            description:
                'Congratulations! Your Hybrid Solar Inverter 10kW deal has been closed for PKR 1,10,000.',
            createdAt: DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
            isRead: true,
          ),
        ];
      }
      _isProfileLoading = false;
    });
  }

  static bool _isServerUrl(String url) {
    return url.startsWith('http://') ||
        url.startsWith('https://') ||
        url.startsWith('/api/');
  }

  static bool _isLocalDevicePath(String url) {
    return url.startsWith('/data/') ||
        url.startsWith('/storage/') ||
        url.startsWith('/sdcard/') ||
        url.startsWith('file://');
  }

  Map<String, dynamic> _mapListingToDashboard(Listing l) {
    String imagePath = 'assets/images/home-listing-1.jpg';
    if (l.category == 'Batteries') {
      imagePath = 'assets/images/battery.jpg';
    } else if (l.category == 'Inverters') {
      imagePath = 'assets/images/inverter.png';
    } else if (l.category == 'Cables') {
      imagePath = 'assets/images/cables.jpg';
    } else if (l.category == 'Structure') {
      imagePath = 'assets/images/structure.png';
    } else if (l.category == 'Complete Solar System') {
      imagePath = 'assets/images/complete-solar-system.jpg';
    }

    final priceStr = l.priceDemand >= 100000
        ? 'Rs. ${(l.priceDemand / 100000).toStringAsFixed(1)}L'
        : 'Rs. ${l.priceDemand.toStringAsFixed(0)}';

    String title = l.category;
    if (l.category == 'Solar Panels' && l.specs['panels_count'] != null) {
      title = '${l.specs['panels_count']}x Solar Panels ${l.specs['watts_per_panel'] ?? ''}W';
    } else if (l.category == 'Batteries' && l.specs['battery_count'] != null) {
      title = '${l.specs['battery_count']}x ${l.specs['battery_type'] ?? ''} Batteries';
    } else if (l.category == 'Inverters' && l.specs['rated_power'] != null) {
      title = '${l.specs['inverter_brand'] ?? ''} ${l.specs['inverter_type'] ?? ''} Inverter';
    }

    // Determine image to show and whether it's a real network URL
    String displayImage = imagePath;
    bool isRemote = false;
    bool isLocalFile = false;

    if (l.imageUrls.isNotEmpty) {
      final firstUrl = l.imageUrls.first;
      if (_isServerUrl(firstUrl)) {
        displayImage = firstUrl;
        isRemote = true;
      } else if (_isLocalDevicePath(firstUrl)) {
        // Stored local device path — render as file image
        displayImage = firstUrl;
        isLocalFile = true;
      }
      // Otherwise it's garbage data — fall back to asset
    }

    return {
      'rawId': l.id,
      'image': displayImage,
      'isRemote': isRemote,
      'isLocalFile': isLocalFile,
      'title': title,
      'id': l.id.length > 10 ? l.id.substring(0, 10).toUpperCase() : l.id.toUpperCase(),
      'time': 'Recently',
      'status': l.status == 'active' ? 'Active' : l.status,
      'price': priceStr,
    };
  }

  Listing? _getListingFromItem(Map<String, dynamic> item) {
    try {
      final rawId = item['rawId'];
      if (rawId != null) {
        return _myListings.firstWhere((l) => l.id == rawId);
      }
      final displayId = item['id']?.toString() ?? '';
      return _myListings.firstWhere((l) => l.id.toUpperCase().startsWith(displayId));
    } catch (_) {
      return null;
    }
  }

  String _getProfileInitials() {
    final name = _profile?.displayName.trim() ?? '';
    if (name.isEmpty) return 'S';
    final parts = name.split(' ').where((s) => s.isNotEmpty).toList();
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  Widget _buildThumbnailWidget(String imagePath, {bool isRemote = false, bool isLocalFile = false}) {
    // Remote server URL
    if (isRemote || imagePath.startsWith('http://') || imagePath.startsWith('https://') || imagePath.startsWith('/api/')) {
      final fullUrl = ListingService.instance.getFullImageUrl(imagePath);
      return Image.network(
        fullUrl ?? imagePath,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          'assets/images/home-listing-1.jpg',
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      );
    }
    // Local device file path (e.g. Android cache: /data/user/0/...)
    if (isLocalFile || imagePath.startsWith('/data/') || imagePath.startsWith('/storage/') || imagePath.startsWith('/sdcard/') || imagePath.startsWith('file://')) {
      final cleanPath = imagePath.replaceFirst('file://', '');
      final file = File(cleanPath);
      return Image.file(
        file,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          'assets/images/home-listing-1.jpg',
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      );
    }
    // Asset path
    return Image.asset(
      imagePath,
      width: 60,
      height: 60,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        'assets/images/home-listing-1.jpg',
        width: 60,
        height: 60,
        fit: BoxFit.cover,
      ),
    );
  }

  List<Map<String, dynamic>> _allListings = [];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: _buildCurrentView(l10n),
      ),
      floatingActionButton: _buildCenterAddButton(),
      floatingActionButtonLocation: const _CustomCenterDockedLocation(offsetY: -4),
      bottomNavigationBar: _buildBottomNavBar(l10n),
    );
  }

  Widget _buildCenterAddButton() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SellerNewListingScreen(),
          ),
        ).then((_) => _silentRefresh());
      },
      child: Container(
        width: 68,
        height: 68,
        alignment: Alignment.center,
        color: Colors.transparent, // Ensures 100% of the 68x68 touch area receives taps
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF00A63E),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.14),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.add,
              color: Color(0xFF00A63E),
              size: 28,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(AppLocalizations l10n) {
    return CustomPaint(
      size: Size(MediaQuery.of(context).size.width, 68 + MediaQuery.of(context).padding.bottom),
      painter: const NotchedBottomBarPainter(),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Expanded(child: _buildNavItem('assets/icons/home.svg', l10n.homeTab, 0)),
                Expanded(child: _buildNavItem('assets/icons/listing.svg', l10n.listingTab, 1)),
                const SizedBox(width: 80), // Space for center notch
                Expanded(child: _buildNavItem('assets/icons/bell.svg', l10n.alertsTab, 2)),
                Expanded(child: _buildNavItem('assets/icons/person.svg', l10n.profileTab, 3)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentView(AppLocalizations l10n) {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeView(l10n);
      case 1:
        return _buildListingView(l10n);
      case 2:
        return _buildAlertsView(l10n);
      case 3:
        return _buildProfileView(l10n);
      default:
        return _buildHomeView(l10n);
    }
  }

  // Common Header Widget
  Widget _buildHeader(AppLocalizations l10n, {Widget? rightWidget}) {
    bool hasUnreadAlerts = _notifications.any((a) => !a.isRead);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.goodMorning,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            Text(
              _profile?.displayName.isNotEmpty == true
                  ? _profile!.displayName
                  : l10n.sellerRoleFallback,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        rightWidget ??
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
              },
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/bell.svg',
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        Colors.grey,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  if (hasUnreadAlerts)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xFF00A63E),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
      ],
    );
  }

  // Home Screen View
  Widget _buildHomeView(AppLocalizations l10n) {
    final totalListingsCount = _myListings.isNotEmpty ? _myListings.length : (_stats?.listingsCount ?? 0);
    final activeListingsCount = _myListings.where((l) => l.status == 'active').length;

    return RefreshIndicator(
      onRefresh: _loadProfileData,
      color: const Color(0xFF00A63E),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(l10n),
            const SizedBox(height: 24),

            // Ready to Sell Card
            Container(
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF00A63E),
                    Color(0xFF007D2E),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 12,
                    top: 12,
                    child: Opacity(
                      opacity: 0.25,
                      child: SvgPicture.asset(
                        'assets/icons/solar_scrap_icon.svg',
                        width: 85,
                        height: 85,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _profile?.companyName.isNotEmpty == true ? _profile!.companyName : 'SunTech Solar Pvt. Ltd.',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.readyToSell,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.readyToSellDesc,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.white70,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SellerNewListingScreen(),
                              ),
                            );
                            _loadProfileData();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF00A63E),
                            minimumSize: const Size(130, 40),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.add_circle_outline,
                                size: 18,
                                color: Color(0xFF00A63E),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                l10n.sellSolarScrap,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF00A63E),
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
            const SizedBox(height: 24),

            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 1;
                        _selectedFilter = 'All';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: SvgPicture.asset(
                                  'assets/icons/file.svg',
                                  width: 20,
                                  height: 20,
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFF2563EB),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              RTLHelper.chevronIcon(
                                context,
                                color: Colors.grey.shade400,
                                size: 20,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '$totalListingsCount',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.totalListings,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 1;
                        _selectedFilter = 'All';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDCFCE7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: SvgPicture.asset(
                                  'assets/icons/clock.svg',
                                  width: 20,
                                  height: 20,
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFF16A34A),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              RTLHelper.chevronIcon(
                                context,
                                color: Colors.grey.shade400,
                                size: 20,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '$activeListingsCount',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.activeListings,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Recent Listings Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.recentListings,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                  child: Text(
                    l10n.viewAll,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF00A63E),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Home Recent Listings (First 3) or Empty State
            if (_allListings.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF0F0F0)),
                ),
                child: Column(
                  children: [
                    Icon(Icons.inventory_2_outlined, size: 40, color: Colors.grey.shade400),
                    const SizedBox(height: 12),
                    Text(
                      l10n.noListingsYet,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.tapSellSolarScrapToAdd,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              )
            else
              ..._allListings.take(3).map((listing) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SellerListingDetailsScreen(
                        listing: _getListingFromItem(listing),
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF0F0F0)),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: _buildThumbnailWidget(
                          listing['image'] as String,
                          isRemote: listing['isRemote'] == true,
                          isLocalFile: listing['isLocalFile'] == true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              listing['title'] as String,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF151516),
                                height: 20 / 14,
                                letterSpacing: 0,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${listing['id']} · ${listing['time']}',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: const Color(0xFF9CA3AF),
                              ),
                            ),
                            if (listing['status'] == 'Under Review') ...[
                              const SizedBox(height: 5),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEFCE8),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  l10n.filterUnderReview,
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFD08700),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                              l10n.askingPrice,
                              textAlign: TextAlign.right,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 20 / 14,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            listing['price'] as String,
                            textAlign: TextAlign.right,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF999999), // #999999 Grey
                              height: 20 / 12,
                              letterSpacing: 0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 80),
        ],
      ),
    ),
  );
}

  // Listing Screen View
  Widget _buildListingView(AppLocalizations l10n) {
    final filteredListings = _allListings.where((listing) {
      bool matchesFilter = true;
      if (_selectedFilter == 'Submitted') {
        matchesFilter = listing['status'] == 'Submitted';
      } else if (_selectedFilter == 'Under Review') {
        matchesFilter = listing['status'] == 'Under Review';
      } else if (_selectedFilter == 'Price Offered') {
        matchesFilter = listing['status'] == 'Price Offered';
      }

      bool matchesSearch = true;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        matchesSearch = (listing['title'] as String).toLowerCase().contains(q) ||
            (listing['id'] as String).toLowerCase().contains(q);
      }

      return matchesFilter && matchesSearch;
    }).toList();

    return RefreshIndicator(
      onRefresh: _loadProfileData,
      color: const Color(0xFF00A63E),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(l10n),
            const SizedBox(height: 24),

            // Search Bar & Filter Icon Row
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            onChanged: (val) {
                              setState(() {
                                _searchQuery = val;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: l10n.searchListingsHint,
                              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/filter.svg',
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      Colors.black87,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Filter Pills Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Active', 'Submitted', 'Under Review', 'Price Offered'].map((filter) {
                  bool isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF00A63E) : const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _getSellerFilterDisplay(filter, l10n),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? Colors.white : const Color(0xFF555555),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Listings List
            if (filteredListings.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF0F0F0)),
                ),
                child: Column(
                  children: [
                    Icon(Icons.inventory_2_outlined, size: 44, color: Colors.grey.shade400),
                    const SizedBox(height: 12),
                    Text(
                      _searchQuery.isNotEmpty || _selectedFilter != 'All'
                          ? l10n.noMatchingListings
                          : l10n.noListingsCreatedYet,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _searchQuery.isNotEmpty || _selectedFilter != 'All'
                          ? l10n.tryChangingSearchFilter
                          : l10n.tapPlusToCreateListing,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...filteredListings.map((listing) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SellerListingDetailsScreen(
                            listing: _getListingFromItem(listing),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF0F0F0)),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: _buildThumbnailWidget(
                              listing['image'] as String,
                              isRemote: listing['isRemote'] == true,
                              isLocalFile: listing['isLocalFile'] == true,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  listing['title'] as String,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF151516),
                                    height: 20 / 14,
                                    letterSpacing: 0,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${listing['id']} · ${listing['time']}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: const Color(0xFF9CA3AF),
                                  ),
                                ),
                                if (listing['status'] == 'Under Review') ...[
                                  const SizedBox(height: 5),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFEFCE8),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      l10n.filterUnderReview,
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFFD08700),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
                                  l10n.askingPrice,
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    height: 20 / 14,
                                    letterSpacing: 0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                listing['price'] as String,
                                textAlign: TextAlign.right,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF999999), // #999999 Grey
                                  height: 20 / 12,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  // Alerts Screen View
  Widget _buildAlertsView(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Mark all read
          _buildHeader(
            l10n,
            rightWidget: GestureDetector(
              onTap: () async {
                await NotificationService.instance.markAllAsRead();
                if (mounted) {
                  setState(() {
                    _notifications = _notifications.map((n) => NotificationItem(
                      id: n.id,
                      userId: n.userId,
                      type: n.type,
                      title: n.title,
                      description: n.description,
                      listingId: n.listingId,
                      isRead: true,
                      createdAt: n.createdAt,
                    )).toList();
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  l10n.markAllAsRead,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF00A63E),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Alert Cards
          if (_notifications.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 60),
              child: Center(
                child: Text(
                  l10n.noNotificationsYet,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            )
          else
            ..._notifications.map((alert) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GestureDetector(
                  onTap: () async {
                    if (!alert.isRead) {
                      NotificationService.instance.markAsRead(alert.id);
                      setState(() {
                        final idx = _notifications.indexWhere((n) => n.id == alert.id);
                        if (idx != -1) {
                          _notifications[idx] = NotificationItem(
                            id: alert.id,
                            userId: alert.userId,
                            type: alert.type,
                            title: alert.title,
                            description: alert.description,
                            listingId: alert.listingId,
                            isRead: true,
                            createdAt: alert.createdAt,
                          );
                        }
                      });
                    }
                    if (alert.listingId != null && alert.listingId!.isNotEmpty) {
                      Listing? targetListing;
                      try {
                        targetListing = _myListings.firstWhere((l) => l.id == alert.listingId);
                      } catch (_) {
                        targetListing = null;
                      }
                      if (alert.type == 'new_bid_received' ||
                          alert.type == 'price_offered' ||
                          alert.type == 'deal_closed') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SellerStatusTrackingScreen(
                              listing: targetListing,
                              currentStatus: alert.type == 'deal_closed'
                                  ? 'Deal Closed'
                                  : 'Price Offered',
                            ),
                          ),
                        );
                      } else if (targetListing != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SellerListingDetailsScreen(listing: targetListing),
                          ),
                        );
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon Box
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: alert.iconBgColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SvgPicture.asset(
                            alert.iconAsset,
                            width: 20,
                            height: 20,
                            colorFilter: ColorFilter.mode(
                              alert.iconColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Alert Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    alert.title,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  if (!alert.isRead) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF00A63E),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                alert.description,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF666666),
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                alert.timeFormatted,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // Profile Screen View
  Widget _buildProfileView(AppLocalizations l10n) {
    if (_isProfileLoading && _profile == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF00A63E),
        ),
      );
    }

    final fullImageUrl = ProfileService.instance.getFullImageUrl(_profile?.profilePhotoUrl);
    final displayName = _profile?.displayName.isNotEmpty == true
        ? _profile!.displayName
        : l10n.sellerRoleFallback;
    final companyName = _profile?.companyName.isNotEmpty == true
        ? _profile!.companyName
        : 'SunTech Solar Pvt. Ltd.';
    final email = _profile?.email.isNotEmpty == true ? _profile!.email : '-';
    final phone = _profile?.phoneNumber.isNotEmpty == true ? _profile!.phoneNumber : '-';
    final gst = _profile?.gstNumber.isNotEmpty == true ? _profile!.gstNumber : '-';
    final companyType = _profile?.companyType.isNotEmpty == true
        ? _profile!.companyType
        : 'Private Limited';

    return RefreshIndicator(
      onRefresh: _loadProfileData,
      color: const Color(0xFF00A63E),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Avatar & Name Header
            Row(
              children: [
                // Avatar with edit badge
                Stack(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: fullImageUrl != null
                            ? Image.network(
                                fullImageUrl,
                                width: 72,
                                height: 72,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  width: 72,
                                  height: 72,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF00A63E),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      _getProfileInitials(),
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                width: 72,
                                height: 72,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF00A63E),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    _getProfileInitials(),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () async {
                          final updated = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SellerEditProfileScreen(profile: _profile),
                            ),
                          );
                          if (updated == true) {
                            _loadProfileData();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFF00A63E),
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/edit.svg',
                            width: 12,
                            height: 12,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                // User info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        companyName,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF666666),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          l10n.verifiedSeller,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF00A63E),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Summary Stats Card (Listings, Deals, Earnings)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${(_stats?.listingsCount != null && _stats!.listingsCount > 0) ? _stats!.listingsCount : _myListings.length}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00A63E),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.listingsTitle,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 30,
                    width: 1,
                    color: Colors.grey.shade200,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${_stats?.dealsCount ?? 0}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00A63E),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.dealsTitle,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 30,
                    width: 1,
                    color: Colors.grey.shade200,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          _stats?.totalEarnings ?? 'Rs. 0',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00A63E),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.earningsTitle,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Personal Information Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.personalInformation,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Divider(height: 24, color: Colors.grey.shade100),
                  _buildInfoRow(l10n.fullNameLabel, displayName),
                  Divider(height: 24, color: Colors.grey.shade100),
                  _buildInfoRow(l10n.emailLabel, email),
                  Divider(height: 24, color: Colors.grey.shade100),
                  _buildInfoRow(l10n.phoneLabel, phone),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Company Information Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.companyInformation,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Divider(height: 24, color: Colors.grey.shade100),
                  _buildInfoRow(l10n.companyLabel, companyName),
                  Divider(height: 24, color: Colors.grey.shade100),
                  _buildInfoRow(l10n.gstLabel, gst),
                  Divider(height: 24, color: Colors.grey.shade100),
                  _buildInfoRow(l10n.typeLabel, companyType),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Action Menu Card (Edit Profile, Settings, Logout)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildActionRow(
                    icon: 'assets/icons/edit.svg',
                    label: l10n.editProfile,
                    onTap: () async {
                      final updated = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SellerEditProfileScreen(profile: _profile),
                        ),
                      );
                      if (updated == true) {
                        _loadProfileData();
                      }
                    },
                  ),
                  Divider(height: 1, color: Colors.grey.shade100),
                  _buildActionRow(
                    icon: 'assets/icons/setting.svg',
                    label: l10n.settingsTitle,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SellerSettingsScreen(),
                        ),
                      );
                    },
                  ),
                  Divider(height: 1, color: Colors.grey.shade100),
                  _buildActionRow(
                    icon: null,
                    iconWidget: const Icon(
                      Icons.logout_rounded,
                      color: Color(0xFFEF4444),
                      size: 20,
                    ),
                    label: l10n.logout,
                    textColor: const Color(0xFFEF4444),
                    onTap: () {
                      _showLogoutDialog(l10n);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.logout),
        content: Text(l10n.logoutConfirm),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel, style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await AuthService.instance.logout();
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RoleSelectionScreen(),
                  ),
                  (route) => false,
                );
              }
            },
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF888888),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildActionRow({
    String? icon,
    Widget? iconWidget,
    required String label,
    Color textColor = Colors.black,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: iconWidget ??
          SvgPicture.asset(
            icon!,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(
              textColor,
              BlendMode.srcIn,
            ),
          ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      trailing: RTLHelper.chevronIcon(
        context,
        color: Colors.grey.shade400,
        size: 20,
      ),
    );
  }

  Widget _buildNavItem(String iconPath, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.white : Colors.white70,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.5,
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotchedBottomBarPainter extends CustomPainter {
  final Gradient gradient;

  const NotchedBottomBarPainter({
    this.gradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF00A63E),
        Color(0xFF007D2E),
      ],
    ),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    const double cornerRadius = 24.0;
    const double notchWidth = 124.0;
    const double halfNotch = notchWidth / 2; // 62.0
    const double notchDepth = 28.0;
    final double centerX = size.width / 2;

    final path = Path();
    path.moveTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);
    path.lineTo(centerX - halfNotch, 0);

    // Smooth scoop curve matching Figma FAB BG 124x62
    path.cubicTo(
      centerX - halfNotch + 20, 0,
      centerX - 35, notchDepth,
      centerX, notchDepth,
    );
    path.cubicTo(
      centerX + 35, notchDepth,
      centerX + halfNotch - 20, 0,
      centerX + halfNotch, 0,
    );

    path.lineTo(size.width - cornerRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Draw subtle top shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 8);
    canvas.drawPath(path, shadowPaint);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CustomCenterDockedLocation extends FloatingActionButtonLocation {
  final double offsetY;
  const _CustomCenterDockedLocation({this.offsetY = 0});

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabX = (scaffoldGeometry.scaffoldSize.width - scaffoldGeometry.floatingActionButtonSize.width) / 2.0;
    final double contentBottom = scaffoldGeometry.contentBottom;
    final double fabHeight = scaffoldGeometry.floatingActionButtonSize.height;
    final double fabY = contentBottom - fabHeight / 2.0 + offsetY;
    return Offset(fabX, fabY);
  }
}

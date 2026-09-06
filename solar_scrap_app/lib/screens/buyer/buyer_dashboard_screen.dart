import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/bid.dart';
import '../../models/buyer_profile.dart';
import '../../models/buyer_stats.dart';
import '../../models/listing.dart';
import '../../models/notification_item.dart';
import '../../services/auth_service.dart';
import '../../services/bid_service.dart';
import '../../services/buyer_profile_service.dart';
import '../../services/listing_service.dart';
import '../../services/notification_service.dart';
import '../../services/saved_auctions_service.dart';
import '../role_selection_screen.dart';
import 'buyer_edit_profile_screen.dart';
import 'buyer_change_password_screen.dart';
import 'buyer_settings_screen.dart';
import 'buyer_notifications_screen.dart';
import 'buyer_saved_auctions_screen.dart';
import 'buyer_auction_details_screen.dart';
import 'buyer_bid_details_screen.dart';
import 'buyer_help_center_screen.dart';

class BuyerDashboardScreen extends StatefulWidget {
  final int initialTabIndex;

  const BuyerDashboardScreen({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<BuyerDashboardScreen> createState() => _BuyerDashboardScreenState();
}

class _BuyerDashboardScreenState extends State<BuyerDashboardScreen> {
  late int _selectedTabIndex;

  BuyerProfile? _profile;
  BuyerStats? _stats;
  List<NotificationItem> _notifications = [];
  List<Listing> _listings = [];
  List<Bid> _myBids = [];
  bool _isProfileLoading = false;
  bool _isListingsLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = widget.initialTabIndex;
    SavedAuctionsService.instance.addListener(_onFavoritesChanged);
    _loadDashboardData();
  }

  void _onFavoritesChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isProfileLoading = true;
      _isListingsLoading = true;
    });

    final profileFuture = BuyerProfileService.instance.fetchProfile();
    final statsFuture = BuyerProfileService.instance.fetchStats();
    final notifsFuture = NotificationService.instance.fetchNotifications();
    final listingsFuture = ListingService.instance.fetchAllActiveListings(forceRefresh: true);
    final bidsFuture = BidService.instance.fetchMyBids(forceRefresh: true);

    final results = await Future.wait([profileFuture, statsFuture, notifsFuture, listingsFuture, bidsFuture]);
    if (!mounted) return;

    setState(() {
      if (results[0] != null) {
        _profile = results[0] as BuyerProfile;
      }
      if (results[1] != null) {
        _stats = results[1] as BuyerStats;
      }
      final notifs = results[2] as List<NotificationItem>;
      if (notifs.isNotEmpty) {
        _notifications = notifs;
      } else {
        _notifications = [
          NotificationItem(
            id: '1',
            userId: 'user',
            type: 'bid_winning',
            title: "You're Winning!",
            description: 'Your bid on Monocrystalline Solar Panels is highest.',
            isRead: false,
          ),
          NotificationItem(
            id: '2',
            userId: 'user',
            type: 'auction_new',
            title: 'New Auction Listed',
            description: 'New solar equipment listed on the marketplace.',
            isRead: false,
          ),
        ];
      }
      _listings = results[3] as List<Listing>;
      _myBids = results[4] as List<Bid>;
      _isProfileLoading = false;
      _isListingsLoading = false;
    });
  }

  // Home Tab State
  String _selectedCategory = 'All';
  final TextEditingController _homeSearchController = TextEditingController();

  final List<String> _categories = [
    'All',
    'Solar Panels',
    'Batteries',
    'Inverters',
    'Transformers',
    'Cables',
    'Structure',
  ];

  // Auctions Tab State
  String _selectedAuctionFilter = 'Latest';
  final TextEditingController _auctionSearchController = TextEditingController();

  final List<String> _auctionFilters = [
    'Latest',
    'Lowest Price',
    'Highest Price',
  ];

  // My Bids Tab State
  String _selectedBidStatus = 'Active';
  final TextEditingController _bidsSearchController = TextEditingController();

  final List<String> _bidStatuses = [
    'Active',
    'Winning',
    'Closed',
  ];

  @override
  void dispose() {
    SavedAuctionsService.instance.removeListener(_onFavoritesChanged);
    _homeSearchController.dispose();
    _auctionSearchController.dispose();
    _bidsSearchController.dispose();
    super.dispose();
  }

  // Filtered lists getters
  List<Listing> get _filteredHomeAuctions {
    final query = _homeSearchController.text.trim().toLowerCase();
    return _listings.where((auc) {
      final matchesCategory =
          _selectedCategory == 'All' || auc.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesQuery = query.isEmpty ||
          auc.title.toLowerCase().contains(query) ||
          auc.pickupCity.toLowerCase().contains(query) ||
          auc.locationDisplay.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  List<Listing> get _filteredAuctionsTabList {
    final query = _auctionSearchController.text.trim().toLowerCase();
    var list = _listings.where((auc) {
      return query.isEmpty ||
          auc.title.toLowerCase().contains(query) ||
          auc.category.toLowerCase().contains(query) ||
          auc.pickupCity.toLowerCase().contains(query) ||
          auc.locationDisplay.toLowerCase().contains(query);
    }).toList();

    switch (_selectedAuctionFilter) {
      case 'Lowest Price':
        list.sort((a, b) => a.priceDemand.compareTo(b.priceDemand));
        break;
      case 'Highest Price':
        list.sort((a, b) => b.priceDemand.compareTo(a.priceDemand));
        break;
      case 'Latest':
      default:
        break;
    }

    return list;
  }

  List<Bid> get _filteredBidsList {
    final query = _bidsSearchController.text.trim().toLowerCase();
    return _myBids.where((bid) {
      bool matchesTab = false;
      if (_selectedBidStatus == 'Active') {
        matchesTab = bid.statusGroup == 'Winning' || bid.statusGroup == 'Active';
      } else if (_selectedBidStatus == 'Winning') {
        matchesTab = bid.statusGroup == 'Winning';
      } else if (_selectedBidStatus == 'Closed') {
        matchesTab = bid.statusGroup == 'Closed';
      }

      final matchesQuery = query.isEmpty ||
          bid.titleDisplay.toLowerCase().contains(query) ||
          bid.statusDisplay.toLowerCase().contains(query) ||
          bid.referenceNumber.toLowerCase().contains(query);

      return matchesTab && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: _buildTabContent(),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF00A63E),
              Color(0xFF007D2E),
            ],
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem('assets/icons/home.svg', 'Home', 0),
                _buildNavItem('assets/icons/auction.svg', 'Auctions', 1),
                _buildNavItem('assets/icons/my-bid.svg', 'My Bids', 2),
                _buildNavItem('assets/icons/person.svg', 'Profile', 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String iconPath, String label, int index) {
    bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildAuctionsTab();
      case 2:
        return _buildMyBidsTab();
      case 3:
        return _buildProfileTab();
      default:
        return _buildHomeTab();
    }
  }

  // =================== TAB 1: HOME ===================
  Widget _buildHomeTab() {
    final homeAuctions = _filteredHomeAuctions;
    final featuredListing = _listings.isNotEmpty ? _listings.first : null;

    return RefreshIndicator(
      onRefresh: _loadDashboardData,
      color: const Color(0xFF00A63E),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGreetingHeader(),
            const SizedBox(height: 16),

            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _homeSearchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search auctions, equipment...',
                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF8E8E93),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF8E8E93),
                    size: 20,
                  ),
                  suffixIcon: _homeSearchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                          onPressed: () {
                            _homeSearchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Category Filter Pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((cat) {
                  bool isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFF00A63E),
                                    Color(0xFF007D2E),
                                  ],
                                )
                              : null,
                          color: isSelected ? null : const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          cat,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                            color:
                                isSelected ? Colors.white : const Color(0xFF4B5563),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Featured Auction Hero Card
            _buildFeaturedHeroCard(featuredListing),
            const SizedBox(height: 16),

            // Stats Row
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.description_outlined,
                    iconColor: const Color(0xFF3B82F6),
                    iconBg: const Color(0xFFEFF6FF),
                    value: '${_listings.length}',
                    label: 'Live Auctions',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.access_time,
                    iconColor: const Color(0xFFF59E0B),
                    iconBg: const Color(0xFFFEF3C7),
                    value: '${_stats?.activeBids ?? 0}',
                    label: 'Active Bids',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Latest Auctions Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Latest Auctions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTabIndex = 1;
                    });
                  },
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF00A63E),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Dynamic Auction Cards List
            if (_isListingsLoading)
              _buildLoadingSkeleton()
            else if (homeAuctions.isEmpty)
              _buildEmptyState('No active auctions found in this category')
            else
              ...homeAuctions.map((auc) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildAuctionCard(auc),
                );
              }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedHeroCard(Listing? featured) {
    if (featured == null) {
      return Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF00A63E), Color(0xFF005A20)],
          ),
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'SolarScrap Marketplace',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Verified Solar Scrap Auctions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Explore solar panels, inverters & batteries across Pakistan.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() => _selectedTabIndex = 1);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF00A63E),
                    elevation: 0,
                    minimumSize: const Size(110, 34),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Explore Auctions',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    final fullImageUrl = ListingService.instance.getFullImageUrl(featured.firstImageUrl);
    final hasNetworkImage = fullImageUrl != null &&
        (fullImageUrl.startsWith('http://') || fullImageUrl.startsWith('https://'));

    return Container(
      height: 190,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black87,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (hasNetworkImage)
            Image.network(
              fullImageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  _buildAuctionImageFallback(featured.category),
            )
          else
            _buildAuctionImageFallback(featured.category),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.25),
                  Colors.black.withValues(alpha: 0.8),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 0.8,
                    ),
                  ),
                  child: const Text(
                    'Featured Auction',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      featured.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${featured.quantityDisplay} · ${featured.pickupCity} · ${featured.formattedPrice}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF00A63E),
                            Color(0xFF007D2E),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BuyerAuctionDetailsScreen(
                                listing: featured,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          minimumSize: const Size(110, 34),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          'View Auction',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Column(
      children: List.generate(
        3,
        (index) => Container(
          margin: const EdgeInsets.only(bottom: 16),
          height: 240,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEAEAEA)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 140,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF00A63E),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 180,
                      height: 14,
                      color: const Color(0xFFF3F4F6),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 100,
                      height: 12,
                      color: const Color(0xFFF3F4F6),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =================== TAB 2: AUCTIONS ===================
  Widget _buildAuctionsTab() {
    final auctionsList = _filteredAuctionsTabList;

    return RefreshIndicator(
      onRefresh: _loadDashboardData,
      color: const Color(0xFF00A63E),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGreetingHeader(),
            const SizedBox(height: 16),

            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _auctionSearchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search auctions, equipment...',
                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF8E8E93),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF8E8E93),
                    size: 20,
                  ),
                  suffixIcon: _auctionSearchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                          onPressed: () {
                            _auctionSearchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Filter / Sort Pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _auctionFilters.map((filter) {
                  bool isSelected = _selectedAuctionFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAuctionFilter = filter;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFF00A63E),
                                    Color(0xFF007D2E),
                                  ],
                                )
                              : null,
                          color: isSelected ? null : const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          filter,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                            color:
                                isSelected ? Colors.white : const Color(0xFF4B5563),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Auctions List
            if (_isListingsLoading)
              _buildLoadingSkeleton()
            else if (auctionsList.isEmpty)
              _buildEmptyState('No matching auctions found on marketplace')
            else
              ...auctionsList.map((auc) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildAuctionCard(auc),
                );
              }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // =================== TAB 3: MY BIDS ===================
  Widget _buildMyBidsTab() {
    final bidsList = _filteredBidsList;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGreetingHeader(),
          const SizedBox(height: 16),

          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _bidsSearchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search bids',
                hintStyle: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF8E8E93),
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFF8E8E93),
                  size: 20,
                ),
                suffixIcon: _bidsSearchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                        onPressed: () {
                          _bidsSearchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 13,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Segmented Tab Filter (Active, Winning, Closed)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: _bidStatuses.map((status) {
                bool isSelected = _selectedBidStatus == status;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedBidStatus = status;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected
                              ? const Color(0xFF00A63E)
                              : const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Bids Cards List
          if (bidsList.isEmpty)
            _buildEmptyState('No bids found under $_selectedBidStatus')
          else
            ...bidsList.map((bid) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildBidCard(bid),
              );
            }),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String _getProfileInitials() {
    final name = _profile?.displayName.trim();
    if (name != null && name.isNotEmpty) {
      final parts = name.split(' ');
      if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return name[0].toUpperCase();
    }
    final email = _profile?.email.trim() ?? AuthService.instance.currentUser?.email;
    if (email != null && email.isNotEmpty) {
      return email[0].toUpperCase();
    }
    return 'B';
  }

  // =================== TAB 4: PROFILE ===================
  Widget _buildProfileTab() {
    final profileName = _profile?.displayName.isNotEmpty == true
        ? _profile!.displayName
        : (AuthService.instance.currentUser?.displayName?.isNotEmpty == true
            ? AuthService.instance.currentUser!.displayName!
            : (AuthService.instance.currentUser?.email.isNotEmpty == true
                ? AuthService.instance.currentUser!.email.split('@')[0]
                : 'Buyer'));
    final profileEmail = _profile?.email.isNotEmpty == true
        ? _profile!.email
        : (AuthService.instance.currentUser?.email ?? 'buyer@solarscrap.com');
    final profilePhone = _profile?.phoneNumber.isNotEmpty == true
        ? _profile!.phoneNumber
        : (AuthService.instance.currentUser?.phoneNumber ?? 'Not provided');
    final profileLocation = _profile?.city.isNotEmpty == true
        ? '${_profile?.area.isNotEmpty == true ? '${_profile!.area}, ' : ''}${_profile!.city}'
        : 'Not set';

    if (_isProfileLoading && _profile == null) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF00A63E)),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadDashboardData,
      color: const Color(0xFF00A63E),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Title and Settings Gear
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BuyerSettingsScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3F4F6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.settings_outlined,
                      color: Color(0xFF6B7280),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // User Info Section
            Row(
              children: [
                // Avatar
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push<BuyerProfile>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BuyerEditProfileScreen(profile: _profile),
                      ),
                    );
                    if (result != null && mounted) {
                      setState(() => _profile = result);
                    }
                  },
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(36),
                        child: _buildProfilePhoto(72),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: const Color(0xFF00A63E),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Name, title, badge
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profileName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'Scrap Dealer / Buyer',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF8E8E93),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: const [
                          Icon(
                            Icons.check_circle_outline,
                            size: 14,
                            color: Color(0xFF00A63E),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Verified Buyer',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF00A63E),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: _buildProfileStatCard('${_stats?.totalBids ?? 0}', 'Total Bids'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildProfileStatCard('${_stats?.wonAuctions ?? 0}', 'Won Auctions'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildProfileStatCard('${_stats?.activeBids ?? 0}', 'Active Bids'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Contact Information Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFEAEAEA),
                  width: 1.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CONTACT INFORMATION',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF8E8E93),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildContactRow(Icons.mail_outline, profileEmail),
                  const SizedBox(height: 12),
                  _buildContactRow(Icons.phone_outlined, profilePhone),
                  const SizedBox(height: 12),
                  _buildContactRow(Icons.location_on_outlined, profileLocation),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Action Menu Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFEAEAEA),
                  width: 1.0,
                ),
              ),
              child: Column(
                children: [
                  _buildProfileMenuRow(
                    Icons.edit_outlined,
                    'Edit Profile',
                    onTap: () async {
                      final result = await Navigator.push<BuyerProfile>(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BuyerEditProfileScreen(profile: _profile),
                        ),
                      );
                      if (result != null && mounted) {
                        setState(() => _profile = result);
                      }
                    },
                  ),
                  const Divider(height: 1, color: Color(0xFFF3F4F6)),
                  _buildProfileMenuRow(
                    Icons.lock_outline,
                    'Change Password',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const BuyerChangePasswordScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, color: Color(0xFFF3F4F6)),
                  _buildProfileMenuRow(
                    Icons.notifications_none_outlined,
                    'Notification Settings',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BuyerSettingsScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, color: Color(0xFFF3F4F6)),
                  _buildProfileMenuRow(
                    Icons.favorite_border,
                    'Saved Auctions',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BuyerSavedAuctionsScreen(listings: _listings),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, color: Color(0xFFF3F4F6)),
                  _buildProfileMenuRow(
                    Icons.settings_outlined,
                    'Settings',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BuyerSettingsScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, color: Color(0xFFF3F4F6)),
                  _buildProfileMenuRow(
                    Icons.help_outline,
                    'Help Center',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const BuyerHelpCenterScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Sign Out Button
            InkWell(
              onTap: _showSignOutDialog,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFFEE2E2),
                    width: 1.0,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.logout_rounded,
                      color: Color(0xFFEF4444),
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Sign Out',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePhoto(double size) {
    final photoUrl = _profile?.profilePhotoUrl;
    final fullUrl = BuyerProfileService.instance.getFullImageUrl(photoUrl);
    if (fullUrl != null && fullUrl.isNotEmpty) {
      return Image.network(
        fullUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            color: Color(0xFF00A63E),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              _getProfileInitials(),
              style: TextStyle(
                fontSize: size * 0.38,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFF00A63E),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          _getProfileInitials(),
          style: TextStyle(
            fontSize: size * 0.38,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileStatCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFEAEAEA),
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00A63E),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF8E8E93),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: const Color(0xFF00A63E),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF374151),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileMenuRow(IconData icon, String label, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: const Color(0xFF00A63E),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Sign Out', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to sign out of your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF6B7280))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              AuthService.instance.logout();
              BuyerProfileService.instance.clearCache();
              ListingService.instance.clearCache();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const RoleSelectionScreen(),
                ),
                (route) => false,
              );
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  // =================== HELPER WIDGETS ===================
  Widget _buildGreetingHeader() {
    final String greetingName = _profile?.displayName.isNotEmpty == true
        ? _profile!.displayName
        : (AuthService.instance.currentUser?.displayName?.isNotEmpty == true
            ? AuthService.instance.currentUser!.displayName!
            : (AuthService.instance.currentUser?.email.isNotEmpty == true
                ? AuthService.instance.currentUser!.email.split('@')[0]
                : 'Buyer'));

    final bool hasUnread = _notifications.any((n) => !n.isRead);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Good morning,',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF8E8E93),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              greetingName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BuyerNotificationsScreen(),
              ),
            );
          },
          child: Stack(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_none_outlined,
                  color: Color(0xFF4B5563),
                  size: 20,
                ),
              ),
              if (hasUnread)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
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

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFEAEAEA),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF8E8E93),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAuctionImageFallback(String category) {
    String assetFallback = 'assets/images/buyer-solar.jpg';
    if (category == 'Batteries') assetFallback = 'assets/images/battery.jpg';
    if (category == 'Inverters') assetFallback = 'assets/images/inverter.png';
    if (category == 'Transformers') assetFallback = 'assets/images/structure.png';
    if (category == 'Cables') assetFallback = 'assets/images/cables.jpg';

    return Image.asset(
      assetFallback,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: const Color(0xFFF3F4F6),
        child: const Center(
          child: Icon(Icons.solar_power_outlined, size: 48, color: Color(0xFF9CA3AF)),
        ),
      ),
    );
  }

  Widget _buildAuctionCard(Listing auc) {
    final String aucId = auc.id;
    final bool isFavorite = SavedAuctionsService.instance.isFavorite(aucId);
    final fullImageUrl = ListingService.instance.getFullImageUrl(auc.firstImageUrl);
    final isNetwork = fullImageUrl != null &&
        (fullImageUrl.startsWith('http://') || fullImageUrl.startsWith('https://'));

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BuyerAuctionDetailsScreen(listing: auc),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFEAEAEA),
            width: 1.0,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Large Hero Image with Badges
            SizedBox(
              height: 170,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (isNetwork)
                    Image.network(
                      fullImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildAuctionImageFallback(auc.category),
                    )
                  else
                    _buildAuctionImageFallback(auc.category),

                  // Top Verified Badge
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
                        'Verified',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  // Favorite Heart Button (Interactive & Synced)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () {
                        SavedAuctionsService.instance.toggleFavorite(aucId);
                        setState(() {});
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF4B5563),
                          size: 18,
                        ),
                      ),
                    ),
                  ),

                  // Active Badge Bottom-Left
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
                        children: const [
                          Icon(
                            Icons.access_time,
                            size: 12,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Active',
                            style: TextStyle(
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

            // Details Section
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Verified badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          auc.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.check_circle_outline,
                            size: 13,
                            color: Color(0xFF00A63E),
                          ),
                          SizedBox(width: 3),
                          Text(
                            'Verified',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF00A63E),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Category Tag
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF8EE),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      auc.category,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF00A63E),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Units and Location
                  Row(
                    children: [
                      const Icon(
                        Icons.inventory_2_outlined,
                        size: 13,
                        color: Color(0xFF8E8E93),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        auc.quantityDisplay,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF8E8E93),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: Color(0xFF8E8E93),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          auc.locationDisplay,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF8E8E93),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Price Demand and Bid Now Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Price Demand',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF8E8E93),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            auc.formattedPrice,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00A63E),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF00A63E),
                              Color(0xFF007D2E),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BuyerAuctionDetailsScreen(listing: auc),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            minimumSize: const Size(90, 36),
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text(
                            'Bid Now',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBidCard(Bid bid) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BuyerBidDetailsScreen(bid: bid),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFEAEAEA),
            width: 1.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Builder(
                builder: (context) {
                  final img = bid.displayImage;
                  if (img.startsWith('http://') || img.startsWith('https://')) {
                    return Image.network(
                      img,
                      width: 76,
                      height: 76,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        'assets/images/buyer-solar.jpg',
                        width: 76,
                        height: 76,
                        fit: BoxFit.cover,
                      ),
                    );
                  }
                  return Image.asset(
                    img,
                    width: 76,
                    height: 76,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/buyer-solar.jpg',
                      width: 76,
                      height: 76,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          bid.titleDisplay,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            height: 1.25,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: bid.statusBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          bid.statusDisplay,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: bid.statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    bid.formattedAmount,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00A63E),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${bid.referenceNumber} · ${bid.dateDisplay}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: Color(0xFFEAF8EE),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.solar_power_outlined,
              size: 36,
              color: Color(0xFF00A63E),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            message,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: _loadDashboardData,
            icon: const Icon(Icons.refresh, size: 18, color: Color(0xFF00A63E)),
            label: const Text(
              'Refresh',
              style: TextStyle(color: Color(0xFF00A63E), fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

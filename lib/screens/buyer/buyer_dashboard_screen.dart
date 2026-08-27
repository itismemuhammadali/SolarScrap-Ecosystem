import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../role_selection_screen.dart';
import 'buyer_edit_profile_screen.dart';
import 'buyer_change_password_screen.dart';
import 'buyer_settings_screen.dart';
import 'buyer_notifications_screen.dart';
import 'buyer_terms_conditions_screen.dart';
import 'buyer_saved_auctions_screen.dart';
import 'buyer_auction_details_screen.dart';
import 'buyer_bid_details_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = widget.initialTabIndex;
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
  ];

  // Auctions Tab State
  String _selectedAuctionFilter = 'Latest';
  final TextEditingController _auctionSearchController = TextEditingController();

  final List<String> _auctionFilters = [
    'Latest',
    'Ending Soon',
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

  // Master Auctions Data
  final List<Map<String, dynamic>> _allAuctions = [
    {
      'id': 'auc-1',
      'image': 'assets/images/buyer-solar.jpg',
      'time': '2h 34m',
      'timeMinutes': 154,
      'title': 'Monocrystalline Solar Panels',
      'category': 'Solar Panels',
      'units': '150 units',
      'location': 'Karachi',
      'price': 92000,
      'priceStr': 'PKR 92,000',
      'isFavorite': true,
      'verified': true,
    },
    {
      'id': 'auc-2',
      'image': 'assets/images/man.jpg',
      'time': '2h 34m',
      'timeMinutes': 154,
      'title': 'Thin-Film Solar Panels',
      'category': 'Solar Panels',
      'units': '100 units',
      'location': 'Islamabad',
      'price': 75000,
      'priceStr': 'PKR 75,000',
      'isFavorite': false,
      'verified': true,
    },
    {
      'id': 'auc-3',
      'image': 'assets/images/senary.jpg',
      'time': '1d 3h',
      'timeMinutes': 1620,
      'title': 'String Inverters 5kW',
      'category': 'Inverters',
      'units': '8 units',
      'location': 'Islamabad',
      'price': 75000,
      'priceStr': 'PKR 75,000',
      'isFavorite': false,
      'verified': true,
    },
    {
      'id': 'auc-4',
      'image': 'assets/images/battery.jpg',
      'time': '6h 15m',
      'timeMinutes': 375,
      'title': 'Lithium-Ion Battery Packs 48V',
      'category': 'Batteries',
      'units': '25 units',
      'location': 'Karachi',
      'price': 145000,
      'priceStr': 'PKR 1,45,000',
      'isFavorite': false,
      'verified': true,
    },
    {
      'id': 'auc-5',
      'image': 'assets/images/inverter.png',
      'time': '45m',
      'timeMinutes': 45,
      'title': 'Hybrid Solar Inverter 10kW',
      'category': 'Inverters',
      'units': '12 units',
      'location': 'Lahore',
      'price': 110000,
      'priceStr': 'PKR 1,10,000',
      'isFavorite': true,
      'verified': true,
    },
    {
      'id': 'auc-6',
      'image': 'assets/images/structure.png',
      'time': '2d 4h',
      'timeMinutes': 3120,
      'title': 'Distribution Transformer 50kVA',
      'category': 'Transformers',
      'units': '4 units',
      'location': 'Faisalabad',
      'price': 180000,
      'priceStr': 'PKR 1,80,000',
      'isFavorite': false,
      'verified': true,
    },
  ];

  // Master Bids Data
  final List<Map<String, dynamic>> _allBids = [
    {
      'id': 'bid-1',
      'image': 'assets/images/buyer-solar.jpg',
      'title': 'Monocrystalline Solar\nPanels',
      'status': 'Winning',
      'statusGroup': 'Winning',
      'statusColor': const Color(0xFF00A63E),
      'statusBg': const Color(0xFFEAF8EE),
      'price': 'PKR 92,000',
      'date': 'Jul 22, 2026',
    },
    {
      'id': 'bid-2',
      'image': 'assets/images/inverter.png',
      'title': 'Hybrid Solar Inverter\n10kW Lot',
      'status': 'Winning',
      'statusGroup': 'Winning',
      'statusColor': const Color(0xFF00A63E),
      'statusBg': const Color(0xFFEAF8EE),
      'price': 'PKR 1,10,000',
      'date': 'Jul 22, 2026',
    },
    {
      'id': 'bid-3',
      'image': 'assets/images/senary.jpg',
      'title': 'String Inverters 5kW',
      'status': 'Outbid',
      'statusGroup': 'Active',
      'statusColor': const Color(0xFFD97706),
      'statusBg': const Color(0xFFFEF3C7),
      'price': 'PKR 48,500',
      'date': 'Jul 21, 2026',
    },
    {
      'id': 'bid-4',
      'image': 'assets/images/battery.jpg',
      'title': 'Lithium-Ion Battery\nPacks 48V',
      'status': 'Outbid',
      'statusGroup': 'Active',
      'statusColor': const Color(0xFFD97706),
      'statusBg': const Color(0xFFFEF3C7),
      'price': 'PKR 1,35,000',
      'date': 'Jul 19, 2026',
    },
    {
      'id': 'bid-5',
      'image': 'assets/images/complete-solar-system.jpg',
      'title': 'Complete Solar System\n20kW Lot',
      'status': 'Won',
      'statusGroup': 'Closed',
      'statusColor': const Color(0xFF00A63E),
      'statusBg': const Color(0xFFEAF8EE),
      'price': 'PKR 4,50,000',
      'date': 'Jul 15, 2026',
    },
    {
      'id': 'bid-6',
      'image': 'assets/images/cables.jpg',
      'title': 'High Voltage Copper\nCables (500m)',
      'status': 'Lost',
      'statusGroup': 'Closed',
      'statusColor': const Color(0xFFEF4444),
      'statusBg': const Color(0xFFFEE2E2),
      'price': 'PKR 65,000',
      'date': 'Jul 10, 2026',
    },
  ];

  @override
  void dispose() {
    _homeSearchController.dispose();
    _auctionSearchController.dispose();
    _bidsSearchController.dispose();
    super.dispose();
  }

  // Filtered lists getters
  List<Map<String, dynamic>> get _filteredHomeAuctions {
    final query = _homeSearchController.text.trim().toLowerCase();
    return _allAuctions.where((auc) {
      final matchesCategory =
          _selectedCategory == 'All' || auc['category'] == _selectedCategory;
      final matchesQuery = query.isEmpty ||
          auc['title'].toString().toLowerCase().contains(query) ||
          auc['location'].toString().toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  List<Map<String, dynamic>> get _filteredAuctionsTabList {
    final query = _auctionSearchController.text.trim().toLowerCase();
    var list = _allAuctions.where((auc) {
      return query.isEmpty ||
          auc['title'].toString().toLowerCase().contains(query) ||
          auc['category'].toString().toLowerCase().contains(query) ||
          auc['location'].toString().toLowerCase().contains(query);
    }).toList();

    switch (_selectedAuctionFilter) {
      case 'Ending Soon':
        list.sort((a, b) => (a['timeMinutes'] as int).compareTo(b['timeMinutes'] as int));
        break;
      case 'Lowest Price':
        list.sort((a, b) => (a['price'] as num).compareTo(b['price'] as num));
        break;
      case 'Highest Price':
        list.sort((a, b) => (b['price'] as num).compareTo(a['price'] as num));
        break;
      case 'Latest':
      default:
        break;
    }

    return list;
  }

  List<Map<String, dynamic>> get _filteredBidsList {
    final query = _bidsSearchController.text.trim().toLowerCase();
    return _allBids.where((bid) {
      bool matchesTab = false;
      if (_selectedBidStatus == 'Active') {
        matchesTab = bid['statusGroup'] == 'Winning' || bid['statusGroup'] == 'Active';
      } else if (_selectedBidStatus == 'Winning') {
        matchesTab = bid['statusGroup'] == 'Winning';
      } else if (_selectedBidStatus == 'Closed') {
        matchesTab = bid['statusGroup'] == 'Closed';
      }

      final matchesQuery = query.isEmpty ||
          bid['title'].toString().toLowerCase().contains(query) ||
          bid['status'].toString().toLowerCase().contains(query);

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
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF00A63E),
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
          Container(
            height: 190,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: const DecorationImage(
                image: AssetImage('assets/images/buyer-solar.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.2),
                        Colors.black.withValues(alpha: 0.7),
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
                          const Text(
                            'Monocrystalline Solar Panels',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '150 units · Karachi · Ends in 2h 34m',
                            style: TextStyle(
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
                              onPressed: () {},
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
          ),
          const SizedBox(height: 16),

          // Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.description_outlined,
                  iconColor: const Color(0xFF3B82F6),
                  iconBg: const Color(0xFFEFF6FF),
                  value: '12',
                  label: 'Total Listings',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.access_time,
                  iconColor: const Color(0xFFF59E0B),
                  iconBg: const Color(0xFFFEF3C7),
                  value: '3',
                  label: 'Under Review',
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
          if (homeAuctions.isEmpty)
            _buildEmptyState('No auctions found in this category')
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
    );
  }

  // =================== TAB 2: AUCTIONS ===================
  Widget _buildAuctionsTab() {
    final auctionsList = _filteredAuctionsTabList;

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
          if (auctionsList.isEmpty)
            _buildEmptyState('No matching auctions found')
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

  // =================== TAB 4: PROFILE ===================
  Widget _buildProfileTab() {
    return SingleChildScrollView(
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BuyerEditProfileScreen(),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(36),
                      child: Image.asset(
                        'assets/images/ali-hassan.jpg',
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                      ),
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
                    const Text(
                      'Ali Hassan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Scrap Dealer',
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
                          'Verified Business',
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

          // Stats Cards (24 Total Bids, 7 Won Auctions, 3 Active)
          Row(
            children: [
              Expanded(
                child: _buildProfileStatCard('24', 'Total Bids'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildProfileStatCard('7', 'Won Auctions'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildProfileStatCard('3', 'Active'),
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
                _buildContactRow(Icons.mail_outline, 'ali.hassan@email.com'),
                const SizedBox(height: 12),
                _buildContactRow(Icons.phone_outlined, '+92 300 1234567'),
                const SizedBox(height: 12),
                _buildContactRow(Icons.location_on_outlined, 'SITE Area, Karachi'),
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BuyerEditProfileScreen(),
                      ),
                    );
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
                        builder: (context) =>
                            const BuyerNotificationsScreen(),
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
                            const BuyerSavedAuctionsScreen(),
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
                            const BuyerTermsConditionsScreen(),
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
            onTap: () {
              _showSignOutDialog();
            },
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
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF374151),
            fontWeight: FontWeight.w400,
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
              color: Color(0xFFC7C7CC),
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
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Good morning,',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF8E8E93),
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Abdul Samad',
              style: TextStyle(
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
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.black87,
                  size: 20,
                ),
              ),
              Positioned(
                top: 8,
                right: 10,
                child: Container(
                  width: 8,
                  height: 8,
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

  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
      padding: const EdgeInsets.all(14),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 16,
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 16,
                color: Color(0xFF9CA3AF),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF8E8E93),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuctionCard(Map<String, dynamic> auc) {
    final bool isFavorite = auc['isFavorite'] ?? false;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BuyerAuctionDetailsScreen(auctionData: auc),
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
                Image.asset(
                  auc['image'],
                  fit: BoxFit.cover,
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
                // Favorite Heart Button (Interactive)
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        auc['isFavorite'] = !isFavorite;
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
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite
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
                          auc['time'] ?? '',
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
                        auc['title'] ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (auc['verified'] == true)
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
                    auc['category'] ?? '',
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
                      auc['units'] ?? '',
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
                    Text(
                      auc['location'] ?? '',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF8E8E93),
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
                          auc['priceStr'] ?? '',
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
                                  BuyerAuctionDetailsScreen(auctionData: auc),
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

  Widget _buildBidCard(Map<String, dynamic> bid) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BuyerBidDetailsScreen(bidData: bid),
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
          // Left Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              bid['image'],
              width: 76,
              height: 76,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),

          // Details Column
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
                        bid['title'] ?? '',
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
                        color: bid['statusBg'] ?? const Color(0xFFEAF8EE),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        bid['status'] ?? '',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: bid['statusColor'] ?? const Color(0xFF00A63E),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  bid['price'] ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00A63E),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  bid['date'] ?? '',
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
}

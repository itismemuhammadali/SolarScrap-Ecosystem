import 'package:flutter/material.dart';
import 'buyer_auction_details_screen.dart';

class BuyerSavedAuctionsScreen extends StatefulWidget {
  const BuyerSavedAuctionsScreen({super.key});

  @override
  State<BuyerSavedAuctionsScreen> createState() =>
      _BuyerSavedAuctionsScreenState();
}

class _BuyerSavedAuctionsScreenState extends State<BuyerSavedAuctionsScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _savedAuctions = [
    {
      'id': 'auc-2',
      'image': 'assets/images/man.jpg',
      'time': '2h 34m',
      'title': 'Thin-Film Solar Panels',
      'category': 'Solar Panels',
      'units': '100 units',
      'location': 'Islamabad',
      'priceStr': 'PKR 75,000',
      'isFavorite': true,
      'featured': true,
      'verified': true,
    },
    {
      'id': 'auc-3',
      'image': 'assets/images/senary.jpg',
      'time': '1d 3h',
      'title': 'String Inverters 5kW',
      'category': 'Inverters',
      'units': '8 units',
      'location': 'Islamabad',
      'priceStr': 'PKR 75,000',
      'isFavorite': true,
      'featured': true,
      'verified': true,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredAuctions {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      return _savedAuctions;
    }
    return _savedAuctions.where((auc) {
      final title = (auc['title'] ?? '').toString().toLowerCase();
      final category = (auc['category'] ?? '').toString().toLowerCase();
      final location = (auc['location'] ?? '').toString().toLowerCase();
      return title.contains(query) ||
          category.contains(query) ||
          location.contains(query);
    }).toList();
  }

  void _showBidBottomSheet(Map<String, dynamic> auc) {
    final TextEditingController bidAmountController =
        TextEditingController(text: '76000');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Place Bid on ${auc['title']}',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Current Demand: ${auc['priceStr']}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: bidAmountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Your Bid Amount (PKR)',
                  labelStyle: const TextStyle(color: Color(0xFF00A63E)),
                  prefixText: 'PKR ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF00A63E),
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Bid of PKR ${bidAmountController.text} placed successfully!',
                        ),
                        backgroundColor: const Color(0xFF00A63E),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text(
                    'Submit Bid',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredAuctions;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
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
                    'Saved Auctions',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Search Bar
                  Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) {
                        setState(() {});
                      },
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF111827),
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Search saved...',
                        hintStyle: TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xFF9CA3AF),
                          size: 20,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // Saved Auctions List
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 56,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No saved auctions found',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Saved auctions will appear here.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      itemCount: filtered.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final auc = filtered[index];
                        return _buildSavedAuctionCard(auc);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedAuctionCard(Map<String, dynamic> auc) {
    final bool isFavorite = auc['isFavorite'] ?? true;

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
                if (auc['featured'] == true)
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
                        isFavorite ? Icons.favorite_border : Icons.favorite_border,
                        color: isFavorite
                            ? const Color(0xFF4B5563)
                            : const Color(0xFF9CA3AF),
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
                    ElevatedButton(
                      onPressed: () {
                        _showBidBottomSheet(auc);
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
}

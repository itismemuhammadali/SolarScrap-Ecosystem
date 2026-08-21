import 'package:flutter/material.dart';

class BuyerPlaceBidScreen extends StatefulWidget {
  final Map<String, dynamic>? auctionData;

  const BuyerPlaceBidScreen({
    super.key,
    this.auctionData,
  });

  @override
  State<BuyerPlaceBidScreen> createState() => _BuyerPlaceBidScreenState();
}

class _BuyerPlaceBidScreenState extends State<BuyerPlaceBidScreen> {
  late int _currentBidAmount;
  late int _minimumBidAmount;
  late int _startingPrice;
  late int _currentHighestBid;
  late String _auctionTitle;

  int _selectedPresetIndex = 0; // 0: 93K, 1: 98K, 2: 103K

  @override
  void initState() {
    super.initState();
    final data = widget.auctionData ?? {};

    _auctionTitle =
        data['title']?.toString() ?? 'Monocrystalline Solar Panels';

    // Parse starting price
    _startingPrice = _parsePrice(data['startingBid']?.toString()) ?? 85000;

    // Parse current highest bid
    _currentHighestBid =
        _parsePrice(data['currentBid']?.toString() ?? data['priceStr']?.toString()) ??
            92000;

    // Minimum bid is current highest + 1000
    _minimumBidAmount = _currentHighestBid + 1000;
    _currentBidAmount = _minimumBidAmount;
  }

  int? _parsePrice(String? priceStr) {
    if (priceStr == null) return null;
    final clean = priceStr.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(clean);
  }

  String _formatPrice(int amount) {
    // e.g. 92000 -> "PKR 92,000"
    final str = amount.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i > 0) {
        buffer.write(',');
      }
    }
    return 'PKR ${buffer.toString().split('').reversed.join('')}';
  }

  String _formatK(int amount) {
    // e.g. 93000 -> "93K"
    final k = (amount / 1000).round();
    return '${k}K';
  }

  void _incrementBid() {
    setState(() {
      _currentBidAmount += 1000;
      _selectedPresetIndex = -1;
    });
  }

  void _decrementBid() {
    if (_currentBidAmount > _minimumBidAmount) {
      setState(() {
        _currentBidAmount -= 1000;
        _selectedPresetIndex = -1;
      });
    }
  }

  void _selectPreset(int index, int amount) {
    setState(() {
      _selectedPresetIndex = index;
      _currentBidAmount = amount;
    });
  }

  void _submitBid() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Bid of ${_formatPrice(_currentBidAmount)} placed successfully for $_auctionTitle!',
        ),
        backgroundColor: const Color(0xFF00A63E),
        duration: const Duration(seconds: 2),
      ),
    );
    Navigator.pop(context, _currentBidAmount);
  }

  @override
  Widget build(BuildContext context) {
    final preset1 = _minimumBidAmount;
    final preset2 = _minimumBidAmount + 5000;
    final preset3 = _minimumBidAmount + 10000;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
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
                      const SizedBox(height: 20),

                      // Header Title & Subtitle
                      const Text(
                        'Place Your Bid',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _auctionTitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Price Summary Card
                      Container(
                        padding: const EdgeInsets.all(18),
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
                            // Starting Price
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Starting Price',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                Text(
                                  _formatPrice(_startingPrice),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // Current Highest Bid
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Current Highest Bid',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                Text(
                                  _formatPrice(_currentHighestBid),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF00A63E),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            const Divider(
                              height: 1,
                              color: Color(0xFFF3F4F6),
                            ),
                            const SizedBox(height: 14),

                            // Minimum Bid
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Minimum Bid',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                Text(
                                  _formatPrice(_minimumBidAmount),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF00A63E),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Your Bid Amount (PKR) Section
                      const Text(
                        'Your Bid Amount (PKR)',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Stepper Row: [-] [ 93000 ] [+]
                      Row(
                        children: [
                          // Decrement Button
                          GestureDetector(
                            onTap: _decrementBid,
                            child: Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFFE5E7EB),
                                  width: 1.0,
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.remove,
                                  color: Color(0xFF4B5563),
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Center Bid Amount Display
                          Expanded(
                            child: Container(
                              height: 52,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFF00A63E),
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '$_currentBidAmount',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF00A63E),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Increment Button
                          GestureDetector(
                            onTap: _incrementBid,
                            child: Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: const Color(0xFF00A63E),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Preset Increments Row
                      Row(
                        children: [
                          _buildPresetChip(
                            index: 0,
                            label: _formatK(preset1),
                            amount: preset1,
                          ),
                          const SizedBox(width: 12),
                          _buildPresetChip(
                            index: 1,
                            label: _formatK(preset2),
                            amount: preset2,
                          ),
                          const SizedBox(width: 12),
                          _buildPresetChip(
                            index: 2,
                            label: _formatK(preset3),
                            amount: preset3,
                          ),
                        ],
                      ),

                      const Spacer(),
                      const SizedBox(height: 32),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _submitBid,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00A63E),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPresetChip({
    required int index,
    required String label,
    required int amount,
  }) {
    final bool isSelected = _selectedPresetIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          _selectPreset(index, amount);
        },
        child: Container(
          height: 42,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF00A63E) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF00A63E)
                  : const Color(0xFFE5E7EB),
              width: 1.0,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF4B5563),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

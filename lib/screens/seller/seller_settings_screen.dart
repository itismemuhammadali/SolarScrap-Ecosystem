import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SellerSettingsScreen extends StatefulWidget {
  const SellerSettingsScreen({super.key});

  @override
  State<SellerSettingsScreen> createState() => _SellerSettingsScreenState();
}

class _SellerSettingsScreenState extends State<SellerSettingsScreen> {
  bool _listingUpdates = true;
  bool _priceOffers = true;
  bool _productUpdates = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 56,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0xFFE9E9E9),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 18,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              // Notifications Card
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
                      child: Text(
                        'NOTIFICATIONS',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF8E8E93),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                    _buildSwitchTile(
                      title: 'Listing Updates',
                      value: _listingUpdates,
                      onChanged: (val) {
                        setState(() {
                          _listingUpdates = val;
                        });
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                    _buildSwitchTile(
                      title: 'Price Offers',
                      value: _priceOffers,
                      onChanged: (val) {
                        setState(() {
                          _priceOffers = val;
                        });
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                    _buildSwitchTile(
                      title: 'Product Updates',
                      value: _productUpdates,
                      onChanged: (val) {
                        setState(() {
                          _productUpdates = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Options & Links Card
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
                    _buildLinkTile(
                      title: 'Language',
                      trailingText: 'English',
                      onTap: () {
                        // Handle Language selection
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                    _buildLinkTile(
                      title: 'Terms & Conditions',
                      onTap: () {
                        // Handle Terms & Conditions
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                    _buildLinkTile(
                      title: 'Privacy Policy',
                      onTap: () {
                        // Handle Privacy Policy
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                    _buildLinkTile(
                      title: 'Contact Support',
                      onTap: () {
                        // Handle Contact Support
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Footer
              const Text(
                'Solar Scrap v1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF8E8E93),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '© 2026 Solar Scrap Platform',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF8E8E93),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          CupertinoSwitch(
            value: value,
            activeTrackColor: const Color(0xFF00A63E),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildLinkTile({
    required String title,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            Row(
              children: [
                if (trailingText != null) ...[
                  Text(
                    trailingText,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFFC7C7CC),
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

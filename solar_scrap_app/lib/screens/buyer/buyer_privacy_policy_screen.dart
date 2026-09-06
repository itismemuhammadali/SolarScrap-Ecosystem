import 'package:flutter/material.dart';

class BuyerPrivacyPolicyScreen extends StatelessWidget {
  const BuyerPrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // Header with Back Button and Centered Title
              SizedBox(
                height: 40,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Privacy Policy',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Subheader
              const Text(
                'Last Updated: August 5, 2026',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 16),

              // Policy Section 1
              _buildPolicyCard(
                title: 'Information We Collect',
                content:
                    'We Collect Your Name, Email, Phone Number, Pickup Address, Company Details (If Applicable), And Order Information. We May Also Collect Device, Location, And Usage Data To Improve The App.',
              ),
              const SizedBox(height: 14),

              // Policy Section 2
              _buildPolicyCard(
                title: 'How We Use Your Information',
                content:
                    'Your Information Is Used To Create Your Account, Process Scrap Purchases, Schedule Pickups, Provide Customer Support, Send Important Notifications, And Improve Our Services.',
              ),
              const SizedBox(height: 14),

              // Policy Section 3
              _buildPolicyCard(
                title: 'Data Sharing',
                content:
                    'We Do Not Sell Your Personal Information. We Only Share Necessary Data With Trusted Service Providers Such As Payment Processors, Logistics Partners, And Authorities When Legally Required.',
              ),
              const SizedBox(height: 14),

              // Policy Section 4
              _buildPolicyCard(
                title: 'Location Access',
                content:
                    'With Your Permission, We Use Your Location To Schedule Pickups, Improve Collection Accuracy, And Provide Location-Based Services. You Can Disable Location Access Anytime In Your Device Settings.',
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPolicyCard({
    required String title,
    required String content,
  }) {
    return Container(
      width: double.infinity,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

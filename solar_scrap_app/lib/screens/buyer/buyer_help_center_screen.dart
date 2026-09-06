import 'package:flutter/material.dart';
import 'buyer_terms_conditions_screen.dart';
import 'buyer_privacy_policy_screen.dart';

class BuyerHelpCenterScreen extends StatelessWidget {
  const BuyerHelpCenterScreen({super.key});

  final List<String> _helpTopics = const [
    'Account & Login',
    'Selling Solar Scrap',
    'Pickup & Orders',
    'Notifications',
    'Privacy & Security',
    'Report a Problem',
    'FAQs',
    'Contact Support',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // White Top Header Bar
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 14,
                bottom: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F4F6),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  const Text(
                    'Help Center',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content with #F9F9F9 background
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Help Topics Card (Pure White #FFFFFF)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFE5E7EB),
                          width: 1.0,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Column(
                          children: List.generate(_helpTopics.length, (index) {
                            final topic = _helpTopics[index];
                            final isLast = index == _helpTopics.length - 1;

                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    _handleTopicTap(context, topic);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 16,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          topic,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF1E293B),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.chevron_right,
                                          size: 20,
                                          color: Color(0xFF9CA3AF),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (!isLast)
                                  const Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: Color(0xFFF1F5F9),
                                  ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTopicTap(BuildContext context, String topic) {
    if (topic == 'Privacy & Security') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BuyerPrivacyPolicyScreen(),
        ),
      );
    } else if (topic == 'Terms & Conditions') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BuyerTermsConditionsScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$topic details coming soon!'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}

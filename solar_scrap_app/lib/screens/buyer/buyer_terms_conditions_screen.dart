import 'package:flutter/material.dart';

class BuyerTermsConditionsScreen extends StatelessWidget {
  const BuyerTermsConditionsScreen({super.key});

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
                        'Terms & Conditions',
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

              // FAQs Section Title
              const Text(
                'FAQs',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),

              // FAQ 1
              _buildFaqCard(
                title: '1. How Do I Sell My Solar Scrap?',
                content:
                    'Simply Create An Account, Add Your Scrap Details, Submit A Pickup Request, And Our Team Will Review And Arrange Collection.',
              ),
              const SizedBox(height: 12),

              // FAQ 2
              _buildFaqCard(
                title: '2. What Types Of Scrap Do You Accept?',
                content:
                    'We Accept Various Types Of Solar-Related Scrap, Including Solar Panels, Inverters, Cables, Aluminum Frames, Batteries (Where Applicable), And Other Recyclable Components.',
              ),
              const SizedBox(height: 12),

              // FAQ 3
              _buildFaqCard(
                title: '3. How Will I Know The Value Of My Scrap?',
                content:
                    'Our Team Evaluates Your Scrap Based On Its Type, Quantity, Condition, And Current Market Value Before Confirming The Purchase Price.',
              ),
              const SizedBox(height: 12),

              // FAQ 4
              _buildFaqCard(
                title: '4. How Do I Schedule A Pickup?',
                content:
                    'After Submitting Your Scrap Details, You Can Choose A Preferred Pickup Location And Time. We\'ll Contact You To Confirm The Schedule.',
              ),
              const SizedBox(height: 12),

              // FAQ 5
              _buildFaqCard(
                title: '5. Is My Personal Information Secure?',
                content:
                    'Yes. We Use Industry-Standard Security Measures To Protect Your Personal Information And Never Sell Your Data To Third Parties.',
              ),
              const SizedBox(height: 24),

              // Contact Us Section
              const Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),

              // Contact Info Card
              Container(
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
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.mail_outline,
                          color: Color(0xFF00A63E),
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'support@solarscrap.com',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: const [
                        Icon(
                          Icons.phone_outlined,
                          color: Color(0xFF00A63E),
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Text(
                          '+1 (800) 123-4567',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqCard({
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

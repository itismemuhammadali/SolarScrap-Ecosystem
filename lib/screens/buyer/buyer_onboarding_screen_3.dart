import 'package:flutter/material.dart';

class BuyerOnboardingScreen3 extends StatefulWidget {
  const BuyerOnboardingScreen3({super.key});

  @override
  State<BuyerOnboardingScreen3> createState() => _BuyerOnboardingScreen3State();
}

class _BuyerOnboardingScreen3State extends State<BuyerOnboardingScreen3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BuyerOnboardingPage3Widget(
        image: 'assets/images/buyer_secure_transactions_bg.jpg',
        title: 'Bid Smart, Win More',
        description:
            'Place competitive bids, track your auctions, and secure the best solar scrap deals.',
        onNext: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Onboarding Complete!')),
          );
        },
      ),
    );
  }
}

class BuyerOnboardingPage3Widget extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final VoidCallback onNext;

  const BuyerOnboardingPage3Widget({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Dark Gradient Overlay at bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.5,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
        ),
        // Content
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top spacing
              const SizedBox(height: 20),
              // Main content at bottom
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          // Title
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          // Description
                          Text(
                            description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Pagination Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white30,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white30,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 24,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: const Color(0xFF00A63E),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Next Button (Change to "Get Started" on last screen)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ElevatedButton(
                        onPressed: onNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00A63E),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Get Started →',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

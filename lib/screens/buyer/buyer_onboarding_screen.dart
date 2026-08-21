import 'package:flutter/material.dart';
import 'buyer_onboarding_screen_2.dart';
import 'buyer_onboarding_screen_3.dart';
import 'buyer_login_screen.dart';

class BuyerOnboardingScreen extends StatefulWidget {
  const BuyerOnboardingScreen({super.key});

  @override
  State<BuyerOnboardingScreen> createState() => _BuyerOnboardingScreenState();
}

class _BuyerOnboardingScreenState extends State<BuyerOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to buyer login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BuyerLoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          BuyerOnboardingPageWidget(
            image: 'assets/images/buyer_discover_auctions_bg.jpg',
            title: 'Discover Live Auctions',
            description:
                'Browse active auctions for solar panels, batteries, inverters, transformers, and more.',
            onNext: _nextPage,
            currentPage: 0,
            totalPages: 3,
          ),
          BuyerOnboardingPage2Widget(
            image: 'assets/images/buyer_place_bids_bg.jpg',
            title: 'Place Your Bids',
            description:
                'Bid on items from verified sellers and get the best deals on solar equipment.',
            onNext: _nextPage,
          ),
          BuyerOnboardingPage3Widget(
            image: 'assets/images/buyer_secure_transactions_bg.jpg',
            title: 'Bid Smart, Win More',
            description:
                'Place competitive bids, track your auctions, and secure the best solar scrap deals.',
            onNext: _nextPage,
          ),
        ],
      ),
    );
  }
}

class BuyerOnboardingPageWidget extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final VoidCallback onNext;
  final int currentPage;
  final int totalPages;

  const BuyerOnboardingPageWidget({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.onNext,
    required this.currentPage,
    required this.totalPages,
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
                      children: List.generate(
                        totalPages,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: index == currentPage ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: index == currentPage
                                ? const Color(0xFF00A63E)
                                : Colors.white30,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Next Button
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
                          'Next →',
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'seller_onboarding_screen_2.dart';
import 'seller_onboarding_screen_3.dart';
import 'seller_login_screen.dart';

class SellerOnboardingScreen extends StatefulWidget {
  const SellerOnboardingScreen({super.key});

  @override
  State<SellerOnboardingScreen> createState() => _SellerOnboardingScreenState();
}

class _SellerOnboardingScreenState extends State<SellerOnboardingScreen> {
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
      // Navigate to seller login screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const SellerLoginScreen(),
        ),
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
          OnboardingPageWidget(
            image: 'assets/images/solar_scrap_bg.jpg',
            title: 'List Your Solar Scrap',
            description:
                'Sell solar panels, batteries, inverters,\ntransformers and more — reach thousands of\nverified buyers nationwide.',
            onNext: _nextPage,
            currentPage: 0,
            totalPages: 3,
          ),
          OnboardingPage2Widget(
            image: 'assets/images/market_value_bg.png',
            title: 'Get Best Market Value',
            description:
                'Connect with verified buyers through a\ntransparent auction process. Every listing gets\ncompetitive offers.',
            onNext: _nextPage,
          ),
          OnboardingPage3Widget(
            image: 'assets/images/instant_alerts_bg.png',
            title: 'Get Instant Alerts',
            description:
                'When a room opens, you get a limited-time\nchance to claim it.',
            onNext: _nextPage,
          ),
        ],
      ),
    );
  }
}

class OnboardingPageWidget extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final VoidCallback onNext;
  final int currentPage;
  final int totalPages;

  const OnboardingPageWidget({
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
          height: MediaQuery.of(context).size.height * 0.55,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.35, 0.75, 1.0],
                colors: [
                  Color(0x00121821),
                  Color(0x99121821),
                  Color(0xEE121821),
                  Color(0xFF121821),
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
              // Top Logo matching Figma (117x70 with #FFFFFF drop shadow glow)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x5AFFFFFF),
                          blurRadius: 30,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/solar-scrap-logo-full.png',
                      width: 117,
                      height: 70,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
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
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          // Description
                          Text(
                            description,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xCCFFFFFF), // #FFFFFF 80%
                              height: 1.5,
                              letterSpacing: 0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Pagination Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        totalPages,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: index == currentPage ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: index == currentPage
                                ? const Color(0xFF00A63E)
                                : const Color(0x40FFFFFF),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Next Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ElevatedButton(
                        onPressed: onNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00A63E),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.chevron_right,
                              size: 20,
                              color: Colors.white,
                            ),
                          ],
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

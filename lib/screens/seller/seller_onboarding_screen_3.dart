import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SellerOnboardingScreen3 extends StatefulWidget {
  const SellerOnboardingScreen3({super.key});

  @override
  State<SellerOnboardingScreen3> createState() => _SellerOnboardingScreen3State();
}

class _SellerOnboardingScreen3State extends State<SellerOnboardingScreen3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingPage3Widget(
        image: 'assets/images/instant_alerts_bg.png',
        title: 'Get Instant Alerts',
        description:
            'When a room opens, you get a limited-time\nchance to claim it.',
        onNext: () {
          // Navigation to next screen (e.g., seller dashboard)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Onboarding Complete!')),
          );
        },
      ),
    );
  }
}

class OnboardingPage3Widget extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final VoidCallback onNext;

  const OnboardingPage3Widget({
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
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: const Color(0x40FFFFFF),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: const Color(0x40FFFFFF),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: 24,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: const Color(0xFF00A63E),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Next Button (Get Started on last screen)
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
                              'Get Started',
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

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'seller/seller_onboarding_screen.dart';
import 'buyer/buyer_onboarding_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

enum UserRole { seller, buyer, none }

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole _selectedRole = UserRole.none;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Text(
                  'Select Your Role',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Choose how you want to use Solar Scrap',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 32),

                // Seller Option
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedRole = UserRole.seller;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedRole == UserRole.seller
                            ? const Color(0xFF00A63E)
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      color: _selectedRole == UserRole.seller
                          ? const Color(0xFFE8F5E9)
                          : Colors.white,
                    ),
                    child: Row(
                      children: [
                        // Seller Icon
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: _selectedRole == UserRole.seller
                                ? const Color(0xFF00A63E)
                                : Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons/building.svg',
                              width: 26,
                              height: 26,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Seller Text
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Solar EPC Company /\nScrap Seller',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  height: 1.25,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'List and sell your solar scrap\nequipment',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6A7282),
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Radio Button
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _selectedRole == UserRole.seller
                                  ? const Color(0xFF00A63E)
                                  : Colors.grey.shade400,
                              width: 2,
                            ),
                          ),
                          child: _selectedRole == UserRole.seller
                              ? const Center(
                                  child: Icon(
                                    Icons.circle,
                                    size: 12,
                                    color: Color(0xFF00A63E),
                                  ),
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Buyer Option
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedRole = UserRole.buyer;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedRole == UserRole.buyer
                            ? const Color(0xFF00A63E)
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      color: _selectedRole == UserRole.buyer
                          ? const Color(0xFFE8F5E9)
                          : Colors.white,
                    ),
                    child: Row(
                      children: [
                        // Buyer Icon
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: _selectedRole == UserRole.buyer
                                ? const Color(0xFF00A63E)
                                : Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons/buyer.svg',
                              width: 26,
                              height: 26,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Buyer Text
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Scrap Dealer /\nSolar Buyer',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  height: 1.25,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Browse and buy solar scrap at\nbest prices',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6A7282),
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Radio Button
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _selectedRole == UserRole.buyer
                                  ? const Color(0xFF00A63E)
                                  : Colors.grey.shade400,
                              width: 2,
                            ),
                          ),
                          child: _selectedRole == UserRole.buyer
                              ? const Center(
                                  child: Icon(
                                    Icons.circle,
                                    size: 12,
                                    color: Color(0xFF00A63E),
                                  ),
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Continue Button
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: _selectedRole == UserRole.none
                        ? null
                        : const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF00A63E),
                              Color(0xFF007D2E),
                            ],
                          ),
                    color: _selectedRole == UserRole.none ? Colors.grey.shade300 : null,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ElevatedButton(
                    onPressed: _selectedRole == UserRole.none
                        ? null
                        : () {
                            if (_selectedRole == UserRole.seller) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SellerOnboardingScreen(),
                                ),
                              );
                            } else if (_selectedRole == UserRole.buyer) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const BuyerOnboardingScreen(),
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      disabledBackgroundColor: Colors.transparent,
                      disabledForegroundColor: Colors.grey.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

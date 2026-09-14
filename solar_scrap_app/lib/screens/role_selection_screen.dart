import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'seller/seller_onboarding_screen.dart';
import 'buyer/buyer_onboarding_screen.dart';
import '../l10n/app_localizations.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

enum UserRole { seller, buyer, none }

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole _selectedRole = UserRole.seller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 48,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Text(
                        l10n.selectRoleTitle,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.selectRoleSubtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Seller Option Card
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedRole = UserRole.seller;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 22,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _selectedRole == UserRole.seller
                                  ? const Color(0xFF00A63E)
                                  : const Color(0xFFE2E8F0),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            color: _selectedRole == UserRole.seller
                                ? const Color(0xFFEBF7EE)
                                : Colors.white,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Seller Icon
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: _selectedRole == UserRole.seller
                                      ? const Color(0xFF00A63E)
                                      : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/icons/building.svg',
                                    width: 26,
                                    height: 26,
                                    colorFilter: ColorFilter.mode(
                                      _selectedRole == UserRole.seller
                                          ? Colors.white
                                          : const Color(0xFF475569),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),

                              // Seller Content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            l10n.sellerRoleTitle,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                              height: 1.25,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // Seller Badge & Radio
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (_selectedRole == UserRole.seller)
                                              const Text(
                                                'Seller',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xFF00A63E),
                                                ),
                                              )
                                            else
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFF1F5F9),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: const Text(
                                                  'Seller',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xFF64748B),
                                                  ),
                                                ),
                                              ),
                                            const SizedBox(width: 8),
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: _selectedRole ==
                                                          UserRole.seller
                                                      ? const Color(0xFF00A63E)
                                                      : const Color(0xFFCBD5E1),
                                                  width: 2,
                                                ),
                                              ),
                                              child: _selectedRole ==
                                                      UserRole.seller
                                                  ? const Center(
                                                      child: Icon(
                                                        Icons.circle,
                                                        size: 10,
                                                        color:
                                                            Color(0xFF00A63E),
                                                      ),
                                                    )
                                                  : null,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      l10n.sellerRoleDesc,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF64748B),
                                        height: 1.35,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Buyer Option Card
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedRole = UserRole.buyer;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 22,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _selectedRole == UserRole.buyer
                                  ? const Color(0xFF00A63E)
                                  : const Color(0xFFE2E8F0),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            color: _selectedRole == UserRole.buyer
                                ? const Color(0xFFEBF7EE)
                                : Colors.white,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Buyer Icon
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: _selectedRole == UserRole.buyer
                                      ? const Color(0xFF00A63E)
                                      : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/icons/buyer.svg',
                                    width: 26,
                                    height: 26,
                                    colorFilter: ColorFilter.mode(
                                      _selectedRole == UserRole.buyer
                                          ? Colors.white
                                          : const Color(0xFF475569),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),

                              // Buyer Content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            l10n.buyerRoleTitle,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                              height: 1.25,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // Buyer Badge & Radio
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (_selectedRole == UserRole.buyer)
                                              const Text(
                                                'Buyer',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xFF00A63E),
                                                ),
                                              )
                                            else
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFF1F5F9),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: const Text(
                                                  'Buyer',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xFF64748B),
                                                  ),
                                                ),
                                              ),
                                            const SizedBox(width: 8),
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: _selectedRole ==
                                                          UserRole.buyer
                                                      ? const Color(0xFF00A63E)
                                                      : const Color(0xFFCBD5E1),
                                                  width: 2,
                                                ),
                                              ),
                                              child: _selectedRole ==
                                                      UserRole.buyer
                                                  ? const Center(
                                                      child: Icon(
                                                        Icons.circle,
                                                        size: 10,
                                                        color:
                                                            Color(0xFF00A63E),
                                                      ),
                                                    )
                                                  : null,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      l10n.buyerRoleDesc,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF64748B),
                                        height: 1.35,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Spacer(),
                      const SizedBox(height: 24),

                      // Continue Button (Pinned to Bottom)
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF00A63E),
                              Color(0xFF007D2E),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            final role = _selectedRole == UserRole.none
                                ? UserRole.seller
                                : _selectedRole;
                            if (role == UserRole.seller) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SellerOnboardingScreen(),
                                ),
                              );
                            } else if (role == UserRole.buyer) {
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            l10n.continueButton,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
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
}

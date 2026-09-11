import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../services/auth_service.dart';
import '../role_selection_screen.dart';
import 'seller_dashboard_screen.dart';
import 'seller_new_listing_screen.dart';

class SellerAccountCreatedScreen extends StatefulWidget {
  final String companyName;
  final String location;
  final String? email;
  final String? userId;

  const SellerAccountCreatedScreen({
    super.key,
    required this.companyName,
    required this.location,
    this.email,
    this.userId,
  });

  @override
  State<SellerAccountCreatedScreen> createState() =>
      _SellerAccountCreatedScreenState();
}

class _SellerAccountCreatedScreenState
    extends State<SellerAccountCreatedScreen> {
  bool _isApproved = false;
  bool _isChecking = false;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    final current = AuthService.instance.currentUser;
    _isApproved = current?.isApproved ?? false;

    // Check status immediately
    _checkStatus(silent: true);

    // Poll every 3 seconds while pending
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!_isApproved && mounted) {
        _checkStatus(silent: true);
      }
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkStatus({bool silent = false}) async {
    if (_isChecking) return;
    if (!silent) {
      setState(() => _isChecking = true);
    }

    try {
      final res = await AuthService.instance.checkUserStatus(
        userId: widget.userId,
        email: widget.email,
      );

      final status = (res['status'] as String? ?? '').toLowerCase();
      if (status == 'approved') {
        _pollTimer?.cancel();
        if (mounted) {
          setState(() {
            _isApproved = true;
            _isChecking = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('🎉 Account Verified! Admin has approved your account.'),
              backgroundColor: Color(0xFF00A63E),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 3),
            ),
          );

          // Auto-navigate to dashboard after a short delay
          Future.delayed(const Duration(milliseconds: 1400), () {
            if (mounted && _isApproved) {
              _goToDashboard();
            }
          });
        }
        return;
      } else if (!silent && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Status: Pending Admin Approval. Please approve from the web portal.'),
            backgroundColor: Color(0xFFD97706),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (_) {
      // ignore
    } finally {
      if (mounted && !silent) {
        setState(() => _isChecking = false);
      }
    }
  }

  void _goToDashboard() {
    if (!_isApproved) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const SellerDashboardScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success / Pending Icon
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: _isApproved
                            ? const Color(0xFFE8F5E9)
                            : const Color(0xFFFEF3C7),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          _isApproved
                              ? Icons.verified_rounded
                              : Icons.hourglass_top_rounded,
                          size: 52,
                          color: _isApproved
                              ? const Color(0xFF00A63E)
                              : const Color(0xFFD97706),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: _isApproved
                              ? const Color(0xFF00A63E)
                              : const Color(0xFFFDC700),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            _isApproved ? Icons.check : Icons.access_time_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  _isApproved
                      ? 'Account Approved & Active!'
                      : 'Account Request Submitted',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  _isApproved
                      ? 'Your seller profile has been verified and approved by the Solar Scrap Admin team. You now have full access to create listings and manage sales.'
                      : 'Your seller registration request has been submitted for admin review. Once verified and approved by the admin team, your account will unlock automatically.',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: _isApproved
                        ? const Color(0xFFDCFCE7)
                        : const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _isApproved
                          ? const Color(0xFF86EFAC)
                          : const Color(0xFFFDE68A),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isApproved ? Icons.check_circle : Icons.pending_actions,
                        size: 16,
                        color: _isApproved
                            ? const Color(0xFF16A34A)
                            : const Color(0xFFD97706),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _isApproved
                            ? 'Status: Approved & Verified'
                            : 'Status: Pending Admin Approval',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _isApproved
                              ? const Color(0xFF16A34A)
                              : const Color(0xFFD97706),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Company Info Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFD1FAE5),
                      width: 1.09,
                    ),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/building.svg',
                        width: 22,
                        height: 22,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF00A63E),
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.companyName.isNotEmpty
                                  ? widget.companyName
                                  : 'Solar Scrap Seller',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              _isApproved
                                  ? 'Verified Seller Account · ${widget.location}'
                                  : 'Pending Verification · ${widget.location}',
                              style: TextStyle(
                                fontSize: 12,
                                color: _isApproved
                                    ? const Color(0xFF16A34A)
                                    : const Color(0xFF6B7280),
                                fontWeight: _isApproved
                                    ? FontWeight.w500
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Main Action Button
                if (_isApproved) ...[
                  // Go To Dashboard Button (Approved State)
                  Container(
                    width: double.infinity,
                    height: 54,
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
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00A63E).withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _goToDashboard,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Go To Dashboard',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Create First Listing Button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SellerNewListingScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 54),
                        side: const BorderSide(
                          color: Color(0xFF00A63E),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Create First Listing',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF00A63E),
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  // Pending State: Check Approval Status Button
                  Container(
                    width: double.infinity,
                    height: 54,
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
                      onPressed: _isChecking ? null : () => _checkStatus(silent: false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isChecking
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.refresh_rounded, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Check Approval Status',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Helper text explaining approval
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 18,
                          color: Color(0xFF6B7280),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'App is actively monitoring for admin approval. Once approved on the web portal, access unlocks automatically.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Return to Sign In / Switch Account
                  TextButton.icon(
                    onPressed: () {
                      AuthService.instance.logout();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RoleSelectionScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    icon: const Icon(
                      Icons.logout_rounded,
                      size: 18,
                      color: Color(0xFF6B7280),
                    ),
                    label: const Text(
                      'Switch Account / Return to Sign In',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

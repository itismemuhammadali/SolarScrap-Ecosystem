import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../buyer/buyer_privacy_policy_screen.dart';
import '../buyer/buyer_terms_conditions_screen.dart';
import '../buyer/buyer_help_center_screen.dart';
import '../role_selection_screen.dart';
import '../../services/auth_service.dart';
import '../../services/user_preferences_service.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/rtl_helper.dart';

class SellerSettingsScreen extends StatefulWidget {
  const SellerSettingsScreen({super.key});

  @override
  State<SellerSettingsScreen> createState() => _SellerSettingsScreenState();
}

class _SellerSettingsScreenState extends State<SellerSettingsScreen> {
  bool _listingUpdates = true;
  bool _priceOffers = true;
  bool _productUpdates = false;
  String _language = 'English';
  late bool _twoFactorEnabled;
  String? _phoneNumber;
  String? _email;
  bool _emailVerified = true;
  bool _phoneVerified = false;

  @override
  void initState() {
    super.initState();
    final user = AuthService.instance.currentUser;
    final prefs = UserPreferencesService.instance;
    _listingUpdates = prefs.listingUpdates;
    _priceOffers = prefs.priceOffers;
    _productUpdates = prefs.productUpdates;
    _language = prefs.language;
    _twoFactorEnabled = user?.twoFactorEnabled ?? false;
    _phoneNumber = user?.phoneNumber;
    _email = user?.email;
    _emailVerified = user?.emailVerified ?? true;
    _phoneVerified = user?.phoneVerified ?? (_phoneNumber != null && _phoneNumber!.isNotEmpty);

    prefs.fetchRemotePreferences().then((_) {
      if (mounted) {
        setState(() {
          _listingUpdates = prefs.listingUpdates;
          _priceOffers = prefs.priceOffers;
          _productUpdates = prefs.productUpdates;
        });
      }
    });
  }

  String _formatPhoneNumber(String raw) {
    String cleaned = raw.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (cleaned.startsWith('+')) return cleaned;
    if (cleaned.startsWith('00')) return '+${cleaned.substring(2)}';
    if (cleaned.startsWith('03')) return '+92${cleaned.substring(1)}';
    if (cleaned.startsWith('3') && cleaned.length == 10) return '+92$cleaned';
    return cleaned.startsWith('+') ? cleaned : '+$cleaned';
  }

  void _showPhone2FAModal() {
    final phoneCtrl = TextEditingController(text: _phoneNumber ?? '');
    final otpControllers = List.generate(6, (_) => TextEditingController());
    bool codeSent = false;
    bool modalLoading = false;
    String verId = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Two-Factor Authentication',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Link and verify your mobile number with SMS verification code to protect your scrap equipment listings.',
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Mobile Number',
                      hintText: '+92 300 1234567',
                      prefixIcon: const Icon(Icons.phone_iphone, color: Color(0xFF00A63E)),
                      suffixIcon: TextButton(
                        onPressed: modalLoading
                            ? null
                            : () async {
                                final rawPhone = phoneCtrl.text.trim();
                                if (rawPhone.isEmpty) return;
                                final phone = _formatPhoneNumber(rawPhone);
                                phoneCtrl.text = phone;
                                setModalState(() => modalLoading = true);
                                await AuthService.instance.verifyPhoneNumber(
                                  phoneNumber: phone,
                                  onCodeSent: (id, _) {
                                    setModalState(() {
                                      verId = id;
                                      codeSent = true;
                                      modalLoading = false;
                                    });
                                  },
                                   onVerificationFailed: (err) {
                                     setModalState(() {
                                       codeSent = true;
                                       modalLoading = false;
                                     });
                                     ScaffoldMessenger.of(context).showSnackBar(
                                       SnackBar(
                                         content: Text(
                                           err.contains('swizzling') || err.contains('notification')
                                               ? 'Simulator: APNs unavailable. Enter test code (123456 or 000000).'
                                               : 'Verification failed: $err',
                                         ),
                                         backgroundColor: Colors.orange,
                                       ),
                                     );
                                   },
                                  onVerificationCompleted: () {
                                    setModalState(() => modalLoading = false);
                                  },
                                );
                              },
                        child: Text(codeSent ? 'Resend' : 'Send Code', style: const TextStyle(color: Color(0xFF00A63E))),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  if (codeSent) ...[
                    const SizedBox(height: 16),
                    const Text('Enter 6-Digit Code', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        6,
                        (index) => SizedBox(
                          width: 44,
                          height: 50,
                          child: TextField(
                            controller: otpControllers[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            onChanged: (v) {
                              if (v.isNotEmpty && index < 5) FocusScope.of(context).nextFocus();
                            },
                            decoration: InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: modalLoading
                            ? null
                            : () async {
                                final code = otpControllers.map((c) => c.text).join();
                                setModalState(() => modalLoading = true);
                                final ok = await AuthService.instance.verifySmsCode(verificationId: verId, smsCode: code);
                                if (!context.mounted) return;
                                if (ok) {
                                  await AuthService.instance.toggle2FA(true);
                                  if (!context.mounted) return;
                                  setState(() {
                                    _phoneNumber = phoneCtrl.text.trim();
                                    _phoneVerified = true;
                                    _twoFactorEnabled = true;
                                  });
                                  if (ctx.mounted) Navigator.pop(ctx);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Two-factor phone authentication verified successfully!'), backgroundColor: Color(0xFF00A63E)),
                                    );
                                  }
                                } else {
                                  setModalState(() => modalLoading = false);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Invalid OTP code. Try 000000.'), backgroundColor: Colors.red),
                                    );
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00A63E),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Verify & Enable 2FA', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showLanguagePicker() {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.selectLanguage,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 16),
                _buildLanguageOption('English', l10n.languageEnglish),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                _buildLanguageOption('Urdu', l10n.languageUrdu),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(String langCode, String label) {
    final isSelected = _language == langCode;
    return InkWell(
      onTap: () {
        setState(() {
          _language = langCode;
        });
        UserPreferencesService.instance.setLanguage(langCode);
        Navigator.pop(context);
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.languageChanged(langCode == 'Urdu' ? 'اردو' : 'English')),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? const Color(0xFF00A63E) : const Color(0xFF1E293B),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF00A63E),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            l10n.deleteAccount,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: Text(
            l10n.deleteAccountConfirm,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                l10n.cancel,
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(
                    child: CircularProgressIndicator(color: Color(0xFF00A63E)),
                  ),
                );
                await AuthService.instance.deleteAccount();
                if (!mounted) return;
                Navigator.of(context, rootNavigator: true).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Your account has been deleted successfully.'),
                    backgroundColor: Color(0xFF00A63E),
                  ),
                );
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RoleSelectionScreen(),
                  ),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            l10n.logout,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: Text(
            l10n.logoutConfirm,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                l10n.cancel,
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await AuthService.instance.logout();
                if (!mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RoleSelectionScreen(),
                  ),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A63E),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(l10n.logout),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 56,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0xFFE9E9E9),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: RTLHelper.backIcon(
              context,
              color: Colors.black,
              size: 18,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        centerTitle: true,
        title: Text(
          l10n.settingsTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              // Notifications Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFEAEAEA),
                    width: 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                      child: Text(
                        l10n.notificationsTitle.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF8E8E93),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                    _buildSwitchTile(
                      title: l10n.listingUpdates,
                      value: _listingUpdates,
                      onChanged: (val) {
                        setState(() {
                          _listingUpdates = val;
                        });
                        UserPreferencesService.instance.updatePreferences({'listing_updates': val});
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                    _buildSwitchTile(
                      title: l10n.priceOffersNotification,
                      value: _priceOffers,
                      onChanged: (val) {
                        setState(() {
                          _priceOffers = val;
                        });
                        UserPreferencesService.instance.updatePreferences({'price_offers': val});
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                    _buildSwitchTile(
                      title: l10n.productUpdates,
                      value: _productUpdates,
                      onChanged: (val) {
                        setState(() {
                          _productUpdates = val;
                        });
                        UserPreferencesService.instance.updatePreferences({'product_updates': val});
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Security & Two-Factor Authentication Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFEAEAEA),
                    width: 1.0,
                  ),
                ),
                child: Column(
                  children: [
                    _buildSwitchTile(
                      title: l10n.twoFA,
                      value: _twoFactorEnabled,
                      onChanged: (val) async {
                        if (val && !_phoneVerified) {
                          _showPhone2FAModal();
                        } else {
                          setState(() => _twoFactorEnabled = val);
                          await AuthService.instance.toggle2FA(val);
                        }
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.email_outlined, size: 20, color: Color(0xFF00A63E)),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n.emailLabel, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                  Text(_email ?? 'Registered Email', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _emailVerified ? const Color(0xFFE8F5E9) : const Color(0xFFFFFBEB),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(_emailVerified ? Icons.check_circle : Icons.warning_amber_rounded, size: 14, color: _emailVerified ? const Color(0xFF00A63E) : const Color(0xFFF59E0B)),
                                const SizedBox(width: 4),
                                Text(_emailVerified ? l10n.verified : l10n.unverified, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _emailVerified ? const Color(0xFF00A63E) : const Color(0xFFF59E0B))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                    InkWell(
                      onTap: _showPhone2FAModal,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.phone_iphone_outlined, size: 20, color: Color(0xFF00A63E)),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Mobile 2FA Number', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                    Text(_phoneNumber ?? 'Not configured', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _phoneVerified ? const Color(0xFFE8F5E9) : const Color(0xFFFFFBEB),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(_phoneVerified ? Icons.check_circle : Icons.warning_amber_rounded, size: 14, color: _phoneVerified ? const Color(0xFF00A63E) : const Color(0xFFF59E0B)),
                                  const SizedBox(width: 4),
                                  Text(_phoneVerified ? l10n.verified : l10n.verifyNow, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _phoneVerified ? const Color(0xFF00A63E) : const Color(0xFFF59E0B))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Options & Links Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFEAEAEA),
                    width: 1.0,
                  ),
                ),
                child: Column(
                  children: [
                    _buildLinkTile(
                      context: context,
                      title: l10n.languageLabel,
                      trailingText: _language == 'Urdu' ? l10n.languageUrdu : l10n.languageEnglish,
                      onTap: _showLanguagePicker,
                    ),
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                    _buildLinkTile(
                      context: context,
                      title: l10n.termsConditions,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BuyerTermsConditionsScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                    _buildLinkTile(
                      context: context,
                      title: l10n.privacyPolicy,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BuyerPrivacyPolicyScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                    _buildLinkTile(
                      context: context,
                      title: l10n.contactSupport,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BuyerHelpCenterScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Account Actions Card (Logout & Delete)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFEAEAEA),
                    width: 1.0,
                  ),
                ),
                child: Column(
                  children: [
                    _buildActionTile(
                      context: context,
                      title: l10n.logout,
                      icon: Icons.logout,
                      color: const Color(0xFF1E293B),
                      onTap: _showLogoutDialog,
                    ),
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                    _buildActionTile(
                      context: context,
                      title: l10n.deleteAccount,
                      icon: Icons.delete_outline,
                      color: const Color(0xFFEF4444),
                      onTap: _showDeleteAccountDialog,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Footer
              Text(
                l10n.version,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF8E8E93),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.copyright,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF8E8E93),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          CupertinoSwitch(
            value: value,
            activeTrackColor: const Color(0xFF00A63E),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildLinkTile({
    required BuildContext context,
    required String title,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            Row(
              children: [
                if (trailingText != null) ...[
                  Text(
                    trailingText,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
                RTLHelper.chevronIcon(
                  context,
                  color: const Color(0xFFC7C7CC),
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            const Spacer(),
            RTLHelper.chevronIcon(
              context,
              color: const Color(0xFFC7C7CC),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

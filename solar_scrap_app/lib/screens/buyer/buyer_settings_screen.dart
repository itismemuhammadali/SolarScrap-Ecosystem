import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/user_preferences_service.dart';
import '../role_selection_screen.dart';
import 'buyer_privacy_policy_screen.dart';
import 'buyer_terms_conditions_screen.dart';
import 'buyer_help_center_screen.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/rtl_helper.dart';

class BuyerSettingsScreen extends StatefulWidget {
  const BuyerSettingsScreen({super.key});

  @override
  State<BuyerSettingsScreen> createState() => _BuyerSettingsScreenState();
}

class _BuyerSettingsScreenState extends State<BuyerSettingsScreen> {
  late bool _newAuctions;
  late bool _bidUpdates;
  late bool _closingSoonAlerts;
  late bool _winningNotifications;
  late String _language;
  late bool _twoFactorEnabled;
  String? _phoneNumber;
  String? _email;
  bool _emailVerified = true;
  bool _phoneVerified = false;

  @override
  void initState() {
    super.initState();
    final prefs = UserPreferencesService.instance;
    final user = AuthService.instance.currentUser;
    _newAuctions = prefs.newAuctions;
    _bidUpdates = prefs.bidUpdates;
    _closingSoonAlerts = prefs.closingSoonAlerts;
    _winningNotifications = prefs.winningNotifications;
    _language = prefs.language;
    _twoFactorEnabled = user?.twoFactorEnabled ?? false;
    _phoneNumber = user?.phoneNumber;
    _email = user?.email;
    _emailVerified = user?.emailVerified ?? true;
    _phoneVerified = user?.phoneVerified ?? (_phoneNumber != null && _phoneNumber!.isNotEmpty);

    prefs.fetchRemotePreferences().then((_) {
      if (mounted) {
        setState(() {
          _newAuctions = prefs.newAuctions;
          _bidUpdates = prefs.bidUpdates;
          _closingSoonAlerts = prefs.closingSoonAlerts;
          _winningNotifications = prefs.winningNotifications;
        });
      }
    });
  }

  void _showLanguagePicker() {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
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
          UserPreferencesService.instance.setLanguage(langCode);
        });
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
                color: isSelected
                    ? const Color(0xFF00A63E)
                    : const Color(0xFF1E293B),
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
                  builder: (_) => const Center(child: CircularProgressIndicator(color: Color(0xFF00A63E))),
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
                    'Link and verify your mobile number with SMS verification code to protect your scrap bids.',
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // Back Button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3F4F6),
                    shape: BoxShape.circle,
                  ),
                  child: RTLHelper.backIcon(
                    context,
                    color: Colors.black87,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                l10n.settingsTitle,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 24),

              // Notifications Section Header
              Text(
                l10n.notificationsTitle,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),

              // Notifications Card
              Container(
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
                    _buildSwitchRow(
                      title: l10n.newAuctions,
                      value: _newAuctions,
                      onChanged: (val) {
                        setState(() {
                          _newAuctions = val;
                        });
                        UserPreferencesService.instance.updatePreferences({'new_auctions': val});
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFF3F4F6)),
                    _buildSwitchRow(
                      title: l10n.bidUpdates,
                      value: _bidUpdates,
                      onChanged: (val) {
                        setState(() {
                          _bidUpdates = val;
                        });
                        UserPreferencesService.instance.updatePreferences({'bid_updates': val});
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFF3F4F6)),
                    _buildSwitchRow(
                      title: l10n.closingSoonAlerts,
                      value: _closingSoonAlerts,
                      onChanged: (val) {
                        setState(() {
                          _closingSoonAlerts = val;
                        });
                        UserPreferencesService.instance.updatePreferences({'closing_soon_alerts': val});
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFF3F4F6)),
                    _buildSwitchRow(
                      title: l10n.winningNotifications,
                      value: _winningNotifications,
                      onChanged: (val) {
                        setState(() {
                          _winningNotifications = val;
                        });
                        UserPreferencesService.instance.updatePreferences({'winning_notifications': val});
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Security & 2FA Section Header
              Text(
                l10n.securitySection,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),

              // Security & 2FA Card
              Container(
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
                    _buildSwitchRow(
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
                    const Divider(height: 1, color: Color(0xFFF3F4F6)),
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
                    const Divider(height: 1, color: Color(0xFFF3F4F6)),
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
              const SizedBox(height: 24),

              // General Section Header
              Text(
                l10n.preferencesSection,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),

              // General Options Card
              Container(
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
                    _buildOptionRow(
                      context: context,
                      icon: Icons.language,
                      title: l10n.languageLabel,
                      trailingText: _language == 'Urdu' ? l10n.languageUrdu : l10n.languageEnglish,
                      onTap: _showLanguagePicker,
                    ),
                    const Divider(height: 1, color: Color(0xFFF3F4F6)),
                    _buildOptionRow(
                      context: context,
                      icon: Icons.shield_outlined,
                      title: l10n.privacyPolicy,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const BuyerPrivacyPolicyScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFF3F4F6)),
                    _buildOptionRow(
                      context: context,
                      icon: Icons.description_outlined,
                      title: l10n.termsConditions,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const BuyerTermsConditionsScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFF3F4F6)),
                    _buildOptionRow(
                      context: context,
                      icon: Icons.help_outline,
                      title: l10n.helpCenter,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const BuyerHelpCenterScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Delete Account Button
              InkWell(
                onTap: _showDeleteAccountDialog,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFFEE2E2),
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.delete_outline,
                        color: Color(0xFFEF4444),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.deleteAccount,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF111827),
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

  Widget _buildOptionRow({
    required BuildContext context,
    required IconData icon,
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
          children: [
            Icon(
              icon,
              size: 20,
              color: const Color(0xFF00A63E),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF111827),
                ),
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(width: 4),
            ],
            RTLHelper.chevronIcon(
              context,
              color: const Color(0xFFD1D5DB),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

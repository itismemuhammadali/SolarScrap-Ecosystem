import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/rtl_helper.dart';

class BuyerPrivacyPolicyScreen extends StatelessWidget {
  const BuyerPrivacyPolicyScreen({super.key});

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

              // Header with Back Button and Centered Title
              SizedBox(
                height: 40,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerStart,
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
                          child: Center(
                            child: RTLHelper.backIcon(
                              context,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        l10n.privacyPolicy,
                        style: const TextStyle(
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

              // Subheader
              Text(
                l10n.privacyPolicyLastUpdated,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 16),

              // Policy Section 1
              _buildPolicyCard(
                title: l10n.privacyPolicyInfoCollectTitle,
                content: l10n.privacyPolicyInfoCollectDesc,
              ),
              const SizedBox(height: 14),

              // Policy Section 2
              _buildPolicyCard(
                title: l10n.privacyPolicyHowUseTitle,
                content: l10n.privacyPolicyHowUseDesc,
              ),
              const SizedBox(height: 14),

              // Policy Section 3
              _buildPolicyCard(
                title: l10n.privacyPolicyDataSharingTitle,
                content: l10n.privacyPolicyDataSharingDesc,
              ),
              const SizedBox(height: 14),

              // Policy Section 4
              _buildPolicyCard(
                title: l10n.privacyPolicyLocationAccessTitle,
                content: l10n.privacyPolicyLocationAccessDesc,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPolicyCard({
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

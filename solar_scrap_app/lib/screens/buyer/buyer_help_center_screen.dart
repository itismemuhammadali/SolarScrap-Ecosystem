import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/rtl_helper.dart';
import 'buyer_privacy_policy_screen.dart';
import 'buyer_terms_conditions_screen.dart';

class _HelpTopicItem {
  final String id;
  final String Function(AppLocalizations) getTitle;

  const _HelpTopicItem(this.id, this.getTitle);
}

class BuyerHelpCenterScreen extends StatelessWidget {
  const BuyerHelpCenterScreen({super.key});

  static final List<_HelpTopicItem> _helpTopics = [
    _HelpTopicItem('account_login', (l) => l.helpTopicAccountLogin),
    _HelpTopicItem('selling_scrap', (l) => l.helpTopicSellingScrap),
    _HelpTopicItem('pickup_orders', (l) => l.helpTopicPickupOrders),
    _HelpTopicItem('notifications', (l) => l.notificationsTitle),
    _HelpTopicItem('privacy_security', (l) => l.helpTopicPrivacySecurity),
    _HelpTopicItem('report_problem', (l) => l.helpTopicReportProblem),
    _HelpTopicItem('faqs', (l) => l.helpTopicFaqs),
    _HelpTopicItem('contact_support', (l) => l.contactSupport),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // White Top Header Bar
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 14,
                bottom: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F4F6),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: RTLHelper.backIcon(
                          context,
                          color: Colors.black,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    l10n.helpCenter,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content with #F9F9F9 background
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Help Topics Card (Pure White #FFFFFF)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFE5E7EB),
                          width: 1.0,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Column(
                          children: List.generate(_helpTopics.length, (index) {
                            final topicItem = _helpTopics[index];
                            final topicTitle = topicItem.getTitle(l10n);
                            final isLast = index == _helpTopics.length - 1;

                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    _handleTopicTap(context, topicItem.id, topicTitle, l10n);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 16,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          topicTitle,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF1E293B),
                                          ),
                                        ),
                                        RTLHelper.chevronIcon(
                                          context,
                                          size: 20,
                                          color: const Color(0xFF9CA3AF),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (!isLast)
                                  const Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: Color(0xFFF1F5F9),
                                  ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTopicTap(BuildContext context, String topicId, String topicTitle, AppLocalizations l10n) {
    if (topicId == 'privacy_security') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BuyerPrivacyPolicyScreen(),
        ),
      );
    } else if (topicId == 'terms_conditions') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BuyerTermsConditionsScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.detailsComingSoon(topicTitle)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}

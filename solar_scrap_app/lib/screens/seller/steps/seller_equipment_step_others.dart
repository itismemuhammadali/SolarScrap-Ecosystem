import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/listing_draft.dart';
import '../../../utils/rtl_helper.dart';
import '../seller_upload_images_screen.dart';

class SellerEquipmentStepOthers extends StatefulWidget {
  final bool isCompleteSolarSystem;
  final ListingDraft? draft;

  const SellerEquipmentStepOthers({
    super.key,
    this.isCompleteSolarSystem = true,
    this.draft,
  });

  @override
  State<SellerEquipmentStepOthers> createState() =>
      _SellerEquipmentStepOthersState();
}

class _SellerEquipmentStepOthersState extends State<SellerEquipmentStepOthers> {
  final TextEditingController _commentsController = TextEditingController();
  final TextEditingController _priceDemandController = TextEditingController();
  String _totalPriceDemand = 'Rs 0';

  @override
  void initState() {
    super.initState();
    _priceDemandController.addListener(() {
      setState(() {
        if (_priceDemandController.text.isNotEmpty) {
          _totalPriceDemand = _priceDemandController.text.startsWith('Rs')
              ? _priceDemandController.text
              : 'Rs, ${_priceDemandController.text}';
        } else {
          _totalPriceDemand = 'Rs 0';
        }
      });
    });
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isMultiline = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF18181B),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: isMultiline ? 110 : null,
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: TextField(
            controller: controller,
            maxLines: isMultiline ? null : 1,
            expands: isMultiline,
            textAlignVertical:
                isMultiline ? TextAlignVertical.top : TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 13,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
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
        leading: IconButton(
          icon: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: RTLHelper.backIcon(
              context,
              color: Colors.black,
              size: 18,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          l10n.othersComponentsTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress indicator
              Builder(
                builder: (context) {
                  final bool isHybrid = (widget.draft?.specs['inverter_type'] as String?)?.trim().toLowerCase() != 'on-grid';
                  final int totalSteps = isHybrid ? 7 : 6;
                  final String stepText = l10n.stepXOfYWithDetail(totalSteps, totalSteps, l10n.stepFinalDetails);

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            stepText,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF71717A),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Text(
                            '100%',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF00A63E),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: List.generate(totalSteps, (index) {
                          return Expanded(
                            child: Container(
                              height: 4,
                              margin: EdgeInsets.only(right: index < totalSteps - 1 ? 6 : 0),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00A63E),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),

              // Comments (optional)
              _buildTextField(
                label: l10n.commentsOptional,
                hint: l10n.othersCommentsHint,
                controller: _commentsController,
                isMultiline: true,
              ),

              // Price Demand
              _buildTextField(
                label: l10n.priceDemand,
                hint: 'Rs, 64,00000',
                controller: _priceDemandController,
              ),

              // Total Price Demand
              Text(
                l10n.totalPriceDemand,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF18181B),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Center(
                  child: Text(
                    _totalPriceDemand,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Back and Continue buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 52),
                        side: const BorderSide(
                          color: Color(0xFF00A63E),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        l10n.back,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF00A63E),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 52,
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
                          final currentDraft = widget.draft ?? ListingDraft(category: 'Complete Solar System');
                          currentDraft.specs['others_comments'] = _commentsController.text.trim();

                          final clean = _priceDemandController.text.replaceAll(RegExp(r'[^0-9.]'), '');
                          currentDraft.priceDemand = double.tryParse(clean) ?? 0.0;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SellerUploadImagesScreen(
                                draft: currentDraft,
                                selectedCategory: 'Complete Solar System',
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 52),
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          l10n.continueButton,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentsController.dispose();
    _priceDemandController.dispose();
    super.dispose();
  }
}

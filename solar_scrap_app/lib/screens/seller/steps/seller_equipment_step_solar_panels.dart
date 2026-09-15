import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/listing_draft.dart';
import '../../../utils/rtl_helper.dart';
import '../seller_upload_images_screen.dart';
import 'seller_equipment_step_inverters.dart';

class SellerEquipmentStepSolarPanels extends StatefulWidget {
  final bool isCompleteSolarSystem;
  final ListingDraft? draft;

  const SellerEquipmentStepSolarPanels({
    super.key,
    this.isCompleteSolarSystem = false,
    this.draft,
  });

  @override
  State<SellerEquipmentStepSolarPanels> createState() =>
      _SellerEquipmentStepSolarPanelsState();
}

class _SellerEquipmentStepSolarPanelsState
    extends State<SellerEquipmentStepSolarPanels> {
  final TextEditingController _panelsCountController = TextEditingController();
  final TextEditingController _wattsController = TextEditingController();
  final TextEditingController _priceDemandController = TextEditingController();
  String _selectedCondition = 'Scrap';

  @override
  void initState() {
    super.initState();
    if (widget.draft != null) {
      final specs = widget.draft!.specs;
      if (specs['panels_count'] != null) {
        _panelsCountController.text = specs['panels_count'].toString();
      }
      if (specs['watts_per_panel'] != null) {
        _wattsController.text = specs['watts_per_panel'].toString();
      }
      if (specs['panel_condition'] != null &&
          specs['panel_condition'].toString().isNotEmpty) {
        _selectedCondition = specs['panel_condition'].toString();
      }
      if (widget.draft!.priceDemand != null && widget.draft!.priceDemand! > 0) {
        _priceDemandController.text =
            widget.draft!.priceDemand!.toInt().toString();
      }
    }
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
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
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: TextField(
            controller: controller,
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
        const SizedBox(height: 14),
      ],
    );
  }

  Widget _buildConditionChip(
    String label,
    String value, {
    bool expand = false,
    int flex = 1,
  }) {
    final sel = _selectedCondition.trim().toLowerCase();
    final val = value.trim().toLowerCase();
    final isSelected = sel == val || (sel.startsWith('good') && val.startsWith('good'));

    final chip = GestureDetector(
      onTap: () {
        setState(() {
          _selectedCondition = value;
        });
      },
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE6F9ED) : Colors.white,
          border: Border.all(
            color: isSelected
                ? const Color(0xFF00A63E)
                : const Color(0xFFE5E7EB),
            width: 1.09,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF00A63E)
                    : const Color(0xFF71717A),
              ),
            ),
          ),
        ),
      ),
    );

    if (expand) {
      return Expanded(flex: flex, child: chip);
    }
    return chip;
  }

  Widget _buildConditionOptions(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.panelCondition,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF18181B),
          ),
        ),
        const SizedBox(height: 10),
        // Row 1: 3 buttons stretched across full width
        Row(
          children: [
            _buildConditionChip(l10n.conditionScrap, 'Scrap', expand: true),
            const SizedBox(width: 8),
            _buildConditionChip(l10n.conditionBulletHit, 'Bullet Hit', expand: true),
            const SizedBox(width: 8),
            _buildConditionChip(l10n.conditionShatterGlass, 'Shatter glass', expand: true),
          ],
        ),
        const SizedBox(height: 10),
        // Row 2: 2 buttons (Good Condition takes flex 2 width to fit comfortably on 1 line, Other takes flex 1)
        Row(
          children: [
            _buildConditionChip(l10n.conditionGood, 'Good Condition', expand: true, flex: 2),
            const SizedBox(width: 8),
            _buildConditionChip(l10n.conditionOther, 'Other', expand: true, flex: 1),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  double _parsePrice(String text) {
    final clean = text.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(clean) ?? 0.0;
  }

  void _onContinue() {
    final currentDraft = widget.draft ?? ListingDraft(
      category: widget.isCompleteSolarSystem ? 'Complete Solar System' : 'Solar Panels',
    );

    final panelCount = int.tryParse(_panelsCountController.text.trim());
    final watts = int.tryParse(_wattsController.text.trim());

    currentDraft.specs['panels_count'] = panelCount ?? _panelsCountController.text.trim();
    currentDraft.specs['watts_per_panel'] = watts ?? _wattsController.text.trim();
    currentDraft.specs['panel_condition'] = _selectedCondition;

    if (!widget.isCompleteSolarSystem) {
      currentDraft.priceDemand = _parsePrice(_priceDemandController.text);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SellerUploadImagesScreen(
            draft: currentDraft,
            selectedCategory: 'Solar Panels',
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SellerEquipmentStepInverters(
            isCompleteSolarSystem: true,
            draft: currentDraft,
          ),
        ),
      );
    }
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
          widget.isCompleteSolarSystem
              ? l10n.completeSystemPanelsTitle
              : l10n.equipmentDetailsTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress indicator
              Builder(
                builder: (context) {
                  final int totalSteps = widget.isCompleteSolarSystem ? 7 : 6;
                  final int currentStep = 2;
                  final String stepText = widget.isCompleteSolarSystem
                      ? l10n.stepXOfYWithDetail(2, totalSteps, l10n.stepDetailPanels)
                      : l10n.stepXOfY(2, 6);
                  final String percentText = widget.isCompleteSolarSystem ? '29%' : '33%';

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
                          Text(
                            percentText,
                            style: const TextStyle(
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
                              margin: EdgeInsets.only(
                                  right: index < totalSteps - 1 ? 6 : 0),
                              decoration: BoxDecoration(
                                color: index < currentStep
                                    ? const Color(0xFF00A63E)
                                    : const Color(0xFFE5E7EB),
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
              const SizedBox(height: 16),

              // Category Banner / Capsule
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F9ED),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/solar_scrap_icon.svg',
                      width: 18,
                      height: 18,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF00A63E),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.isCompleteSolarSystem
                          ? l10n.completeSystemBannerPanels
                          : l10n.categoryPanels,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF00A63E),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Number of Panels
              _buildTextField(
                label: l10n.numberOfPanels,
                hint: 'e.g. 200',
                controller: _panelsCountController,
              ),

              // Watts per Panel (W)
              _buildTextField(
                label: l10n.wattsPerPanelUnit,
                hint: 'e.g. 400',
                controller: _wattsController,
              ),

              // Price Demand (only for individual category)
              if (!widget.isCompleteSolarSystem)
                _buildTextField(
                  label: l10n.priceDemand,
                  hint: 'Rs 45, 000 000',
                  controller: _priceDemandController,
                ),

              // Panel Condition
              _buildConditionOptions(l10n),
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
                        onPressed: _onContinue,
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
    _panelsCountController.dispose();
    _wattsController.dispose();
    _priceDemandController.dispose();
    super.dispose();
  }
}

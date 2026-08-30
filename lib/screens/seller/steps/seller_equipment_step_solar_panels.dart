import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../models/listing_draft.dart';
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
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildConditionChip(String condition, {bool expand = false}) {
    final isSelected = _selectedCondition == condition;
    final chip = GestureDetector(
      onTap: () {
        setState(() {
          _selectedCondition = condition;
        });
      },
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
          child: Text(
            condition,
            textAlign: TextAlign.center,
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
    );

    if (expand) {
      return Expanded(child: chip);
    }
    return chip;
  }

  Widget _buildConditionOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Panel Condition',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF18181B),
          ),
        ),
        const SizedBox(height: 10),
        // Row 1: 3 buttons stretched across full width
        Row(
          children: [
            _buildConditionChip('Scrap', expand: true),
            const SizedBox(width: 8),
            _buildConditionChip('Bullet Hit', expand: true),
            const SizedBox(width: 8),
            _buildConditionChip('Shatter lass', expand: true),
          ],
        ),
        const SizedBox(height: 10),
        // Row 2: 2 buttons matching width of Row 1
        Row(
          children: [
            _buildConditionChip('Good Conditions', expand: true),
            const SizedBox(width: 8),
            _buildConditionChip('Other', expand: true),
            const SizedBox(width: 8),
            const Expanded(child: SizedBox()),
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
            child: const Icon(
              Icons.arrow_back,
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
              ? 'Complete System: Panels'
              : 'Equipment Details',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.isCompleteSolarSystem
                        ? 'Step 1 of 5 (Complete System)'
                        : 'Step 2 of 7',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF71717A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    widget.isCompleteSolarSystem ? '20%' : '29%',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF00A63E),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Progress bar
              Row(
                children: List.generate(widget.isCompleteSolarSystem ? 5 : 7, (index) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: EdgeInsets.only(
                          right: index < (widget.isCompleteSolarSystem ? 4 : 6)
                              ? 6
                              : 0),
                      decoration: BoxDecoration(
                        color: index <= 0
                            ? const Color(0xFF00A63E)
                            : const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
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
                          ? 'Complete System · Solar Panels'
                          : 'Solar Panels',
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
                label: 'Number of Panels',
                hint: 'e.g. 200',
                controller: _panelsCountController,
              ),

              // Watts per Panel (W)
              _buildTextField(
                label: 'Watts per Panel (W)',
                hint: 'e.g. 400',
                controller: _wattsController,
              ),

              // Price Demand (only for individual category)
              if (!widget.isCompleteSolarSystem)
                _buildTextField(
                  label: 'Price Demand',
                  hint: 'Rs 45, 000 000',
                  controller: _priceDemandController,
                ),

              // Panel Condition
              _buildConditionOptions(),
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
                      child: const Text(
                        'Back',
                        style: TextStyle(
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
                        child: const Text(
                          'Continue',
                          style: TextStyle(
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

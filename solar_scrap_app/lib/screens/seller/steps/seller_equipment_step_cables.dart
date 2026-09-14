import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/listing_draft.dart';
import '../../../utils/rtl_helper.dart';
import '../seller_upload_images_screen.dart';
import 'seller_equipment_step_structure.dart';

class SellerEquipmentStepCables extends StatefulWidget {
  final bool isCompleteSolarSystem;
  final ListingDraft? draft;

  const SellerEquipmentStepCables({
    super.key,
    this.isCompleteSolarSystem = false,
    this.draft,
  });

  @override
  State<SellerEquipmentStepCables> createState() =>
      _SellerEquipmentStepCablesState();
}

class _SellerEquipmentStepCablesState extends State<SellerEquipmentStepCables> {
  String _selectedCableType = 'AC';
  String _selectedConductor = 'Copper';
  String _selectedInsulation = 'PVC';

  final TextEditingController _cableSizeController = TextEditingController();
  final TextEditingController _priceDemandController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();

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
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: TextField(
            controller: controller,
            maxLines: isMultiline ? 4 : 1,
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

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    String Function(String)? labelBuilder,
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
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              icon: const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Icons.keyboard_arrow_down, color: Color(0xFF71717A)),
              ),
              items: items
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          labelBuilder != null ? labelBuilder(item) : item,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF18181B),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  Widget _buildOptionButtons({
    required String label,
    required List<String> options,
    required String selectedValue,
    required Function(String) onChanged,
    String Function(String)? labelBuilder,
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
        const SizedBox(height: 10),
        Row(
          children: options.map((option) {
            final isSelected = selectedValue == option;
            final displayText = labelBuilder != null ? labelBuilder(option) : option;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    onChanged(option);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  margin: EdgeInsets.only(right: option != options.last ? 8 : 0),
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
                      displayText,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? const Color(0xFF00A63E)
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),
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
          l10n.equipmentDetails,
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
                  final int totalSteps = widget.isCompleteSolarSystem ? (isHybrid ? 7 : 6) : 6;
                  final int currentStep = widget.isCompleteSolarSystem ? (isHybrid ? 5 : 4) : 2;
                  final String stepText = widget.isCompleteSolarSystem
                      ? l10n.stepXOfYWithDetail(currentStep, totalSteps, l10n.stepDetailCables)
                      : l10n.stepXOfY(2, 6);
                  final String percentText =
                      '${((currentStep / totalSteps) * 100).round()}%';

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
                              margin: EdgeInsets.only(right: index < totalSteps - 1 ? 6 : 0),
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
                    const Icon(
                      Icons.cable,
                      color: Color(0xFF00A63E),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.isCompleteSolarSystem
                          ? l10n.completeSystemBannerCables
                          : l10n.categoryCables,
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

                    // Cable Type
                    _buildOptionButtons(
                      label: l10n.cableType,
                      options: ['AC', 'DC'],
                      selectedValue: _selectedCableType,
                      onChanged: (val) => _selectedCableType = val,
                      labelBuilder: (t) => t == 'AC' ? l10n.cableTypeAC : l10n.cableTypeDC,
                    ),

                    // Cable Conductor
                    _buildOptionButtons(
                      label: l10n.cableConductor,
                      options: ['Copper', 'AL'],
                      selectedValue: _selectedConductor,
                      onChanged: (val) => _selectedConductor = val,
                      labelBuilder: (c) => c == 'Copper' ? l10n.conductorCopper : l10n.conductorAL,
                    ),

                    // Insulation Type
                    _buildDropdown(
                      label: l10n.insulationType,
                      value: _selectedInsulation,
                      items: ['PVC', 'Rubber', 'Thermoplastic'],
                      onChanged: (val) => setState(() {
                        if (val != null) _selectedInsulation = val;
                      }),
                      labelBuilder: (i) {
                        switch (i) {
                          case 'PVC':
                            return l10n.insulationPVC;
                          case 'Rubber':
                            return l10n.insulationRubber;
                          case 'Thermoplastic':
                            return l10n.insulationThermoplastic;
                          default:
                            return i;
                        }
                      },
                    ),

                    // Cable Size
                    _buildTextField(
                      label: l10n.cableSize,
                      hint: l10n.cableSizeHint,
                      controller: _cableSizeController,
                    ),

                    // Price Demand (only if not Complete Solar System)
                    if (!widget.isCompleteSolarSystem)
                      _buildTextField(
                        label: l10n.priceDemand,
                        hint: 'Rs, 64,00000',
                        controller: _priceDemandController,
                      ),

              // Comments
              _buildTextField(
                label: l10n.commentsOptional,
                hint: l10n.commentsHint,
                controller: _commentsController,
                isMultiline: true,
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
                          final currentDraft = widget.draft ?? ListingDraft(
                            category: widget.isCompleteSolarSystem ? 'Complete Solar System' : 'Cables',
                          );

                          currentDraft.specs['cable_type'] = _selectedCableType;
                          currentDraft.specs['cable_conductor'] = _selectedConductor;
                          currentDraft.specs['insulation_type'] = _selectedInsulation;
                          currentDraft.specs['cable_size'] = _cableSizeController.text.trim();
                          currentDraft.specs['cable_comments'] = _commentsController.text.trim();

                          if (!widget.isCompleteSolarSystem) {
                            final clean = _priceDemandController.text.replaceAll(RegExp(r'[^0-9.]'), '');
                            currentDraft.priceDemand = double.tryParse(clean) ?? 0.0;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SellerUploadImagesScreen(
                                  draft: currentDraft,
                                  selectedCategory: 'Cables',
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SellerEquipmentStepStructure(
                                  isCompleteSolarSystem: true,
                                  draft: currentDraft,
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 52),
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
    _cableSizeController.dispose();
    _priceDemandController.dispose();
    _commentsController.dispose();
    super.dispose();
  }
}

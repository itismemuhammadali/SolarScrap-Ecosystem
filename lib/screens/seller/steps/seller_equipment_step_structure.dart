import 'package:flutter/material.dart';
import '../../../models/listing_draft.dart';
import '../seller_upload_images_screen.dart';
import 'seller_equipment_step_others.dart';

class SellerEquipmentStepStructure extends StatefulWidget {
  final bool isCompleteSolarSystem;
  final ListingDraft? draft;

  const SellerEquipmentStepStructure({
    super.key,
    this.isCompleteSolarSystem = false,
    this.draft,
  });

  @override
  State<SellerEquipmentStepStructure> createState() =>
      _SellerEquipmentStepStructureState();
}

class _SellerEquipmentStepStructureState
    extends State<SellerEquipmentStepStructure> {
  String _selectedStructureType = 'Elevated';
  String _selectedStructureMetal = 'AL';

  final TextEditingController _priceDemandController = TextEditingController();

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

  Widget _buildOptionButtons({
    required String label,
    required List<String> options,
    required String selectedValue,
    required Function(String) onChanged,
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
                      option,
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
        title: const Text(
          'Structure Details',
          style: TextStyle(
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
                  final bool isHybrid = (widget.draft?.specs['inverter_type'] as String?)?.trim().toLowerCase() == 'hybrid';
                  final int totalSteps = widget.isCompleteSolarSystem ? (isHybrid ? 5 : 4) : 7;
                  final int currentStep = widget.isCompleteSolarSystem ? (isHybrid ? 5 : 4) : 2;
                  final String stepText = widget.isCompleteSolarSystem
                      ? 'Step $currentStep of $totalSteps (Structure)'
                      : 'Step 2 of 7';
                  final String percentText = widget.isCompleteSolarSystem
                      ? '${((currentStep / totalSteps) * 100).round()}%'
                      : '29%';

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
                      Icons.grid_view,
                      color: Color(0xFF00A63E),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.isCompleteSolarSystem
                          ? 'Complete System · Structure'
                          : 'Structure',
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

                    // Structure Type
                    _buildOptionButtons(
                      label: 'Structure Type',
                      options: ['Elevated', 'Non Elevated'],
                      selectedValue: _selectedStructureType,
                      onChanged: (val) => _selectedStructureType = val,
                    ),

                    // Structure Metal
                    _buildOptionButtons(
                      label: 'Structure Metal',
                      options: ['AL', 'GL', 'Hot dip'],
                      selectedValue: _selectedStructureMetal,
                      onChanged: (val) => _selectedStructureMetal = val,
                    ),

              // Price Demand (only if not Complete Solar System)
              if (!widget.isCompleteSolarSystem)
                _buildTextField(
                  label: 'Price Demand',
                  hint: 'Rs, 64,00000',
                  controller: _priceDemandController,
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
                        onPressed: () {
                          final currentDraft = widget.draft ?? ListingDraft(
                            category: widget.isCompleteSolarSystem ? 'Complete Solar System' : 'Structure',
                          );

                          currentDraft.specs['structure_type'] = _selectedStructureType;
                          currentDraft.specs['structure_metal'] = _selectedStructureMetal;

                          if (!widget.isCompleteSolarSystem) {
                            final clean = _priceDemandController.text.replaceAll(RegExp(r'[^0-9.]'), '');
                            currentDraft.priceDemand = double.tryParse(clean) ?? 0.0;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SellerUploadImagesScreen(
                                  draft: currentDraft,
                                  selectedCategory: 'Structure',
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SellerEquipmentStepOthers(
                                  isCompleteSolarSystem: true,
                                  draft: currentDraft,
                                ),
                              ),
                            );
                          }
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
    _priceDemandController.dispose();
    super.dispose();
  }
}

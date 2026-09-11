import 'package:flutter/material.dart';
import '../../../models/listing_draft.dart';
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
                          item,
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
          'Equipment Details',
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
                  final bool isHybrid = (widget.draft?.specs['inverter_type'] as String?)?.trim().toLowerCase() != 'on-grid';
                  final int totalSteps = widget.isCompleteSolarSystem ? (isHybrid ? 7 : 6) : 6;
                  final int currentStep = widget.isCompleteSolarSystem ? (isHybrid ? 5 : 4) : 2;
                  final String stepText = widget.isCompleteSolarSystem
                      ? 'Step $currentStep of $totalSteps (Cables)'
                      : 'Step 2 of 6';
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
                          ? 'Complete System · Cables'
                          : 'Cables',
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
                      label: 'Cable Type',
                      options: ['AC', 'DC'],
                      selectedValue: _selectedCableType,
                      onChanged: (val) => _selectedCableType = val,
                    ),

                    // Cable Conductor
                    _buildOptionButtons(
                      label: 'Cable Conductor',
                      options: ['Copper', 'AL'],
                      selectedValue: _selectedConductor,
                      onChanged: (val) => _selectedConductor = val,
                    ),

                    // Insulation Type
                    _buildDropdown(
                      label: 'Insulation Type',
                      value: _selectedInsulation,
                      items: ['PVC', 'Rubber', 'Thermoplastic'],
                      onChanged: (val) => setState(() {
                        if (val != null) _selectedInsulation = val;
                      }),
                    ),

                    // Cable Size
                    _buildTextField(
                      label: 'Cable size',
                      hint: 'e.g 12 meter',
                      controller: _cableSizeController,
                    ),

                    // Price Demand (only if not Complete Solar System)
                    if (!widget.isCompleteSolarSystem)
                      _buildTextField(
                        label: 'Price Demand',
                        hint: 'Rs, 64,00000',
                        controller: _priceDemandController,
                      ),

              // Comments
              _buildTextField(
                label: 'Comments (optional)',
                hint: 'Describe in details ......',
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
    _cableSizeController.dispose();
    _priceDemandController.dispose();
    _commentsController.dispose();
    super.dispose();
  }
}

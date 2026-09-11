import 'package:flutter/material.dart';
import '../../../models/listing_draft.dart';
import '../seller_upload_images_screen.dart';
import 'seller_equipment_step_cables.dart';

class SellerEquipmentStepBatteries extends StatefulWidget {
  final bool isCompleteSolarSystem;
  final ListingDraft? draft;

  const SellerEquipmentStepBatteries({
    super.key,
    this.isCompleteSolarSystem = false,
    this.draft,
  });

  @override
  State<SellerEquipmentStepBatteries> createState() =>
      _SellerEquipmentStepBatteriesState();
}

class _SellerEquipmentStepBatteriesState
    extends State<SellerEquipmentStepBatteries> {
  String _selectedBatteryType = 'Lithium';
  String _selectedCondition = 'Working';

  final TextEditingController _batteryCountController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _priceDemandController = TextEditingController();
  final TextEditingController _purchaseYearController = TextEditingController();
  final TextEditingController _yearsUsedController = TextEditingController();

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
    final bool isLithium = _selectedBatteryType == 'Lithium';

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
                  final int totalSteps = widget.isCompleteSolarSystem ? 7 : 6;
                  final int currentStep = widget.isCompleteSolarSystem ? 4 : 2;
                  final String stepText = widget.isCompleteSolarSystem
                      ? 'Step 4 of $totalSteps (Batteries)'
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
                    const Icon(
                      Icons.battery_charging_full,
                      color: Color(0xFF00A63E),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.isCompleteSolarSystem
                          ? 'Complete System · Batteries'
                          : 'Batteries',
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

                    // Battery Type
                    _buildOptionButtons(
                      label: 'Battery Type',
                      options: ['Lithium', 'Lead Acid', 'Tabular'],
                      selectedValue: _selectedBatteryType,
                      onChanged: (val) => _selectedBatteryType = val,
                    ),

                    // Number of Batteries
                    _buildTextField(
                      label: 'Number of Batteries',
                      hint: 'Enter Battery count',
                      controller: _batteryCountController,
                    ),

                    // Battery Capacity (kW for Lithium, Amp for Lead Acid & Tabular)
                    _buildTextField(
                      label: isLithium
                          ? 'Battery Capacity (kW)'
                          : 'Battery Capacity (Amp)',
                      hint: isLithium ? 'e.g 5 kw' : 'e.g 200 amp',
                      controller: _capacityController,
                    ),

                    // Manufacturer / Brand
                    _buildTextField(
                      label: 'Manufacturer / Brand',
                      hint: 'Enter brand name',
                      controller: _brandController,
                    ),

                    // Price Demand (only if not Complete Solar System)
                    if (!widget.isCompleteSolarSystem)
                      _buildTextField(
                        label: 'Price Demand',
                        hint: 'Rs 45, 000 000',
                        controller: _priceDemandController,
                      ),

                    // Purchase Year
                    _buildTextField(
                      label: 'Purchase Year',
                      hint: 'e.g. 2019',
                      controller: _purchaseYearController,
                    ),

                    // No. of year used
                    _buildTextField(
                      label: 'No. of year used',
                      hint: 'e.g. 1 year',
                      controller: _yearsUsedController,
                    ),

              // Battery Conditions
              _buildOptionButtons(
                label: 'Battery Conditions',
                options: ['Working', 'Non working'],
                selectedValue: _selectedCondition,
                onChanged: (val) => _selectedCondition = val,
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
                            category: widget.isCompleteSolarSystem ? 'Complete Solar System' : 'Batteries',
                          );

                          final bCount = int.tryParse(_batteryCountController.text.trim());

                          currentDraft.specs['battery_type'] = _selectedBatteryType;
                          currentDraft.specs['battery_count'] = bCount ?? _batteryCountController.text.trim();
                          currentDraft.specs['battery_capacity'] = _capacityController.text.trim();
                          currentDraft.specs['battery_brand'] = _brandController.text.trim();
                          currentDraft.specs['battery_purchase_year'] = _purchaseYearController.text.trim();
                          currentDraft.specs['battery_years_used'] = _yearsUsedController.text.trim();
                          currentDraft.specs['battery_condition'] = _selectedCondition;

                          if (!widget.isCompleteSolarSystem) {
                            final clean = _priceDemandController.text.replaceAll(RegExp(r'[^0-9.]'), '');
                            currentDraft.priceDemand = double.tryParse(clean) ?? 0.0;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SellerUploadImagesScreen(
                                  draft: currentDraft,
                                  selectedCategory: 'Batteries',
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SellerEquipmentStepCables(
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
    _batteryCountController.dispose();
    _capacityController.dispose();
    _brandController.dispose();
    _priceDemandController.dispose();
    _purchaseYearController.dispose();
    _yearsUsedController.dispose();
    super.dispose();
  }
}


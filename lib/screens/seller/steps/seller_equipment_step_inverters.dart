import 'package:flutter/material.dart';
import '../seller_upload_images_screen.dart';
import 'seller_equipment_step_cables.dart';

class SellerEquipmentStepInverters extends StatefulWidget {
  final bool isCompleteSolarSystem;

  const SellerEquipmentStepInverters({
    super.key,
    this.isCompleteSolarSystem = false,
  });

  @override
  State<SellerEquipmentStepInverters> createState() =>
      _SellerEquipmentStepInvertersState();
}

class _SellerEquipmentStepInvertersState
    extends State<SellerEquipmentStepInverters> {
  String _selectedInverterType = 'Hybrid';
  String _selectedCondition = 'Working';

  final TextEditingController _ratedPowerController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _priceDemandController = TextEditingController();

  final List<String> _conditions = ['Working', 'Non working'];

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.isCompleteSolarSystem
                        ? 'Step 3 of 5 (Complete System)'
                        : 'Step 2 of 7',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF71717A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    widget.isCompleteSolarSystem ? '60%' : '29%',
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
                        color: index <= (widget.isCompleteSolarSystem ? 2 : 1)
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
                    const Icon(
                      Icons.bolt,
                      color: Color(0xFF00A63E),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.isCompleteSolarSystem
                          ? 'Complete System · Inverters'
                          : 'Inverters',
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

              // Inverter Type
              _buildOptionButtons(
                label: 'Inverter Type',
                options: ['Hybrid', 'On Grid'],
                selectedValue: _selectedInverterType,
                onChanged: (val) => _selectedInverterType = val,
              ),

                    // Rated Power
                    _buildTextField(
                      label: 'Rated Power',
                      hint: '200 kW',
                      controller: _ratedPowerController,
                    ),

                    // Brand
                    _buildTextField(
                      label: 'Brand',
                      hint: 'Enter Brand name',
                      controller: _brandController,
                    ),

                    // Price Demand
                    _buildTextField(
                      label: 'Price Demand',
                      hint: 'Rs, 64,00000',
                      controller: _priceDemandController,
                    ),

              // Condition
              _buildOptionButtons(
                label: 'Condition',
                options: _conditions,
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
                          if (widget.isCompleteSolarSystem) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SellerEquipmentStepCables(
                                  isCompleteSolarSystem: true,
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SellerUploadImagesScreen(
                                  selectedCategory: 'Inverters',
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
    _ratedPowerController.dispose();
    _brandController.dispose();
    _priceDemandController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import '../seller_upload_images_screen.dart';

class SellerEquipmentStepCompleteSystem extends StatefulWidget {
  const SellerEquipmentStepCompleteSystem({super.key});

  @override
  State<SellerEquipmentStepCompleteSystem> createState() =>
      _SellerEquipmentStepCompleteSystemState();
}

class _SellerEquipmentStepCompleteSystemState
    extends State<SellerEquipmentStepCompleteSystem> {
  String _selectedInverterType = 'Hybrid';
  String _selectedCondition = 'Good';

  final TextEditingController _systemSizeController = TextEditingController();
  final TextEditingController _inverterCapacityController = TextEditingController();
  final TextEditingController _priceDemandController = TextEditingController();

  final List<String> _conditions = ['Good', 'Fair', 'Damaged'];

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
          'Complete System Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress indicator
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Step 2 of 7',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF71717A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '29%',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF00A63E),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // 7-segment progress bar
                    Row(
                      children: List.generate(7, (index) {
                        return Expanded(
                          child: Container(
                            height: 4,
                            margin: EdgeInsets.only(right: index < 6 ? 6 : 0),
                            decoration: BoxDecoration(
                              color: index <= 1
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
                        children: const [
                          Icon(
                            Icons.solar_power,
                            color: Color(0xFF00A63E),
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Complete Solar System',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF00A63E),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Systems Size
                    _buildTextField(
                      label: 'System Size (kW)',
                      hint: 'e.g 6 kW',
                      controller: _systemSizeController,
                    ),

                    // Inverter Type
                    _buildOptionButtons(
                      label: 'Inverter Type',
                      options: ['Hybrid', 'On Grid'],
                      selectedValue: _selectedInverterType,
                      onChanged: (val) => _selectedInverterType = val,
                    ),

                    // Solar Inverter Capacity
                    _buildTextField(
                      label: 'Solar Inverter Capacity (kW)',
                      hint: 'e.g 3 kW',
                      controller: _inverterCapacityController,
                    ),

                    // Price Demand
                    _buildTextField(
                      label: 'Price Demand',
                      hint: 'Rs, 64,000000',
                      controller: _priceDemandController,
                    ),

                    // Condition
                    _buildOptionButtons(
                      label: 'Condition',
                      options: _conditions,
                      selectedValue: _selectedCondition,
                      onChanged: (val) => _selectedCondition = val,
                    ),
                  ],
                ),
              ),
            ),

            // Back and Continue buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
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
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const SellerUploadImagesScreen(
                              selectedCategory: 'Complete Solar System',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A63E),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _systemSizeController.dispose();
    _inverterCapacityController.dispose();
    _priceDemandController.dispose();
    super.dispose();
  }
}

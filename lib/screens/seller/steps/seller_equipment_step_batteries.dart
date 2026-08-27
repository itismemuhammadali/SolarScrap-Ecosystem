import 'package:flutter/material.dart';
import '../seller_upload_images_screen.dart';

class SellerEquipmentStepBatteries extends StatefulWidget {
  const SellerEquipmentStepBatteries({super.key});

  @override
  State<SellerEquipmentStepBatteries> createState() =>
      _SellerEquipmentStepBatteriesState();
}

class _SellerEquipmentStepBatteriesState
    extends State<SellerEquipmentStepBatteries> {
  String _selectedBatteryType = 'Lithium';
  String _selectedCondition = 'Working';

  Widget _buildTextField({
    required String label,
    required String hint,
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
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextField(
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 12),
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
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            bool isSelected = selectedValue == option;
            return GestureDetector(
              onTap: () {
                setState(() {
                  onChanged(option);
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFE8F5E9) : Colors.white,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF00A63E)
                        : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? const Color(0xFF00A63E) : Colors.grey,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Step 1 of 2',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                        const Text(
                          '50%',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF00A63E),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: 0.5,
                        minHeight: 2,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF00A63E),
                        ),
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
                      onChanged: (_) {},
                    ),

                    // Battery Capacity
                    _buildTextField(
                      label: 'Battery Capacity (kW)',
                      hint: 'e.g 5 kw',
                      onChanged: (_) {},
                    ),

                    // Manufacturer / Brand
                    _buildTextField(
                      label: 'Manufacturer / Brand',
                      hint: 'Enter brand name',
                      onChanged: (_) {},
                    ),

                    // Price Demand
                    _buildTextField(
                      label: 'Price Demand',
                      hint: 'Rs 45,000,000',
                      onChanged: (_) {},
                    ),

                    // Purchase Year
                    _buildTextField(
                      label: 'Purchase Year',
                      hint: 'e.g. 2019',
                      onChanged: (_) {},
                    ),

                    // No. of year used
                    _buildTextField(
                      label: 'No. of year used',
                      hint: 'e.g. 1 year',
                      onChanged: (_) {},
                    ),

                    // Battery Conditions
                    _buildOptionButtons(
                      label: 'Battery Conditions',
                      options: ['Working', 'Non working'],
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                              selectedCategory: 'Batteries',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
}

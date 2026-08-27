import 'package:flutter/material.dart';
import '../seller_upload_images_screen.dart';

class SellerEquipmentStepAC extends StatefulWidget {
  const SellerEquipmentStepAC({super.key});

  @override
  State<SellerEquipmentStepAC> createState() => _SellerEquipmentStepACState();
}

class _SellerEquipmentStepACState extends State<SellerEquipmentStepAC> {
  String _selectedEquipmentType = 'Split AC';
  String _selectedCondition = 'Good';

  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
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

  Widget _buildConditionOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Condition',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF18181B),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: _conditions.map((condition) {
            final isSelected = _selectedCondition == condition;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCondition = condition;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  margin: EdgeInsets.only(
                    right: condition != _conditions.last ? 8 : 0,
                  ),
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
                            Icons.ac_unit,
                            color: Color(0xFF00A63E),
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'AC',
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

                    // Equipment Type
                    _buildDropdown(
                      label: 'Equipment Type',
                      value: _selectedEquipmentType,
                      items: ['Split AC', 'Window AC', 'Central AC', 'Cooler'],
                      onChanged: (val) => setState(() {
                        if (val != null) _selectedEquipmentType = val;
                      }),
                    ),

                    // Brand
                    _buildTextField(
                      label: 'Brand',
                      hint: 'Enter Brand',
                      controller: _brandController,
                    ),

                    // Quantity
                    _buildTextField(
                      label: 'Quantity',
                      hint: 'Enter Quantity',
                      controller: _quantityController,
                    ),

                    // Price Demand
                    _buildTextField(
                      label: 'Price Demand',
                      hint: 'Rs. 64,00000',
                      controller: _priceDemandController,
                    ),

                    // Condition
                    _buildConditionOptions(),
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
                              selectedCategory: 'AC',
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
    _brandController.dispose();
    _quantityController.dispose();
    _priceDemandController.dispose();
    super.dispose();
  }
}

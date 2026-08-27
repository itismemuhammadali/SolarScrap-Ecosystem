import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../seller_upload_images_screen.dart';

class SellerEquipmentStepSolarPanels extends StatefulWidget {
  const SellerEquipmentStepSolarPanels({super.key});

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
        const SizedBox(height: 14),
      ],
    );
  }

  Widget _buildConditionChip(String condition) {
    final isSelected = _selectedCondition == condition;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCondition = condition;
        });
      },
      child: Container(
        height: 42.17,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
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
        // Row 1: 3 buttons
        Row(
          children: [
            Expanded(child: _buildConditionChip('Scrap')),
            const SizedBox(width: 8),
            Expanded(child: _buildConditionChip('Bullet Hit')),
            const SizedBox(width: 8),
            Expanded(child: _buildConditionChip('Shatter glass')),
          ],
        ),
        const SizedBox(height: 10),
        // Row 2: 2 buttons
        Row(
          children: [
            Expanded(child: _buildConditionChip('Good Conditions')),
            const SizedBox(width: 8),
            Expanded(child: _buildConditionChip('Other')),
          ],
        ),
        const SizedBox(height: 16),
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
                          const Text(
                            'Solar Panels',
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

                    // Price Demand
                    _buildTextField(
                      label: 'Price Demand',
                      hint: 'Rs 45, 000 000',
                      controller: _priceDemandController,
                    ),

                    // Panel Condition
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
                              selectedCategory: 'Solar Panels',
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
    _panelsCountController.dispose();
    _wattsController.dispose();
    _priceDemandController.dispose();
    super.dispose();
  }
}

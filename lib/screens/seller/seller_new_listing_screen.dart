import 'package:flutter/material.dart';
import 'steps/seller_equipment_step_batteries.dart';
import 'steps/seller_equipment_step_inverters.dart';
import 'steps/seller_equipment_step_cables.dart';
import 'steps/seller_equipment_step_ac.dart';
import 'steps/seller_equipment_step_complete_system.dart';
import 'steps/seller_equipment_step_structure.dart';

class SellerNewListingScreen extends StatefulWidget {
  const SellerNewListingScreen({super.key});

  @override
  State<SellerNewListingScreen> createState() => _SellerNewListingScreenState();
}

class _SellerNewListingScreenState extends State<SellerNewListingScreen> {
  String? _selectedCategory;

  final List<Map<String, String>> categories = [
    {
      'name': 'Solar Panels',
      'image': 'assets/images/solar-panel.jpg',
    },
    {
      'name': 'Batteries',
      'image': 'assets/images/battery.jpg',
    },
    {
      'name': 'Inverters',
      'image': 'assets/images/inverter.png',
    },
    {
      'name': 'Cables',
      'image': 'assets/images/cables.jpg',
    },
    {
      'name': 'Structure',
      'image': 'assets/images/structure.png',
    },
    {
      'name': 'Complete Solar System',
      'image': 'assets/images/complete-solar-system.jpg',
    },
    {
      'name': 'AC',
      'image': 'assets/images/AC.PNG',
    },
  ];

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
          'New Listing',
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
                          'Step 1 of 7',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                        const Text(
                          '14%',
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
                        value: 0.14,
                        minHeight: 2,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF00A63E),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Title
                    const Text(
                      'Equipment Category',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'What type of equipment are you selling?',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Category Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.92,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final isSelected = _selectedCategory == category['name'];

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = category['name'];
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF00A63E)
                                    : Colors.grey.shade300,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              color: isSelected
                                  ? const Color(0xFFE8F5E9)
                                  : Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Image
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: AssetImage(category['image']!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),

                                // Category Name
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 3),
                                  child: Text(
                                    category['name']!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                // Selection indicator
                                if (isSelected) ...[
                                  const SizedBox(height: 4),
                                  Container(
                                    width: 5,
                                    height: 5,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF00A63E),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Continue Button (always visible at bottom)
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedCategory != null
                      ? () {
                          // Route to appropriate equipment details screen
                          Widget nextScreen;
                          switch (_selectedCategory) {
                            case 'Batteries':
                              nextScreen = const SellerEquipmentStepBatteries();
                              break;
                            case 'Inverters':
                              nextScreen = const SellerEquipmentStepInverters();
                              break;
                            case 'Cables':
                              nextScreen = const SellerEquipmentStepCables();
                              break;
                            case 'AC':
                              nextScreen = const SellerEquipmentStepAC();
                              break;
                            case 'Complete Solar System':
                              nextScreen = const SellerEquipmentStepCompleteSystem();
                              break;
                            case 'Structure':
                              nextScreen = const SellerEquipmentStepStructure();
                              break;
                            case 'Solar Panels':
                              // TODO: Create screen for Solar Panels
                              nextScreen = const SellerEquipmentStepAC();
                              break;
                            default:
                              nextScreen = const SellerEquipmentStepAC();
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => nextScreen),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedCategory != null
                        ? const Color(0xFF00A63E)
                        : Colors.grey.shade300,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
      ),
    );
  }
}

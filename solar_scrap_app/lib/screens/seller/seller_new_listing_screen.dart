import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../models/listing_draft.dart';
import '../../utils/rtl_helper.dart';
import '../../widgets/app_button.dart';
import 'steps/seller_equipment_step_solar_panels.dart';
import 'steps/seller_equipment_step_batteries.dart';
import 'steps/seller_equipment_step_inverters.dart';
import 'steps/seller_equipment_step_cables.dart';
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
  ];

  String _getCategoryDisplayName(String name, AppLocalizations l10n) {
    switch (name) {
      case 'Solar Panels':
        return l10n.categoryPanels;
      case 'Batteries':
        return l10n.categoryBatteries;
      case 'Inverters':
        return l10n.categoryInverters;
      case 'Cables':
        return l10n.categoryCables;
      case 'Structure':
        return l10n.categoryStructure;
      case 'Complete Solar System':
        return l10n.completeSolarSystem;
      default:
        return name;
    }
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
          l10n.newListingTitle,
          style: const TextStyle(
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
                    // Dynamic progress indicator based on category selection
                    Builder(
                      builder: (context) {
                        final bool isComplete = _selectedCategory == 'Complete Solar System';
                        final int totalSteps = isComplete ? 7 : 6;
                        final String percent = isComplete ? '14%' : '17%';
                        return Column(
                           children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  l10n.stepXOfY(1, totalSteps),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF71717A),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  percent,
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
                                      color: index == 0
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
                    const SizedBox(height: 20),

                    // Title
                    Text(
                      l10n.equipmentCategory,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF18181B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.whatTypeOfEquipment,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF71717A),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Category Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.98,
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
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF00A63E)
                                    : const Color(0xFFE5E7EB),
                                width: isSelected ? 1.5 : 1,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              color: isSelected
                                  ? const Color(0xFFE6F9ED)
                                  : Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Larger Image
                                Container(
                                  width: 82,
                                  height: 82,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      category['image']!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        width: 82,
                                        height: 82,
                                        color: Colors.grey.shade100,
                                        child: const Icon(
                                          Icons.image_not_supported,
                                          color: Colors.grey,
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Category Name
                                Text(
                                  _getCategoryDisplayName(category['name']!, l10n),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? const Color(0xFF00A63E)
                                        : const Color(0xFF18181B),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                // Selection indicator dot
                                if (isSelected) ...[
                                  const SizedBox(height: 6),
                                  Container(
                                    width: 6,
                                    height: 6,
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
              child: AppButton(
                text: l10n.continueButton,
                isEnabled: _selectedCategory != null,
                onPressed: _selectedCategory != null
                    ? () {
                        final draft = ListingDraft(category: _selectedCategory);

                        // Route to appropriate equipment details screen
                        Widget nextScreen;
                        switch (_selectedCategory) {
                          case 'Batteries':
                            nextScreen = SellerEquipmentStepBatteries(draft: draft);
                            break;
                          case 'Inverters':
                            nextScreen = SellerEquipmentStepInverters(draft: draft);
                            break;
                          case 'Cables':
                            nextScreen = SellerEquipmentStepCables(draft: draft);
                            break;
                          case 'Complete Solar System':
                            nextScreen = SellerEquipmentStepSolarPanels(
                              isCompleteSolarSystem: true,
                              draft: draft,
                            );
                            break;
                          case 'Structure':
                            nextScreen = SellerEquipmentStepStructure(draft: draft);
                            break;
                          case 'Solar Panels':
                            nextScreen = SellerEquipmentStepSolarPanels(draft: draft);
                            break;
                          default:
                            nextScreen = SellerEquipmentStepSolarPanels(draft: draft);
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => nextScreen),
                        );
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

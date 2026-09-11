import 'package:flutter/material.dart';
import '../../models/listing_draft.dart';
import '../../services/profile_service.dart';
import 'seller_contact_information_screen.dart';

class SellerPickupLocationScreen extends StatefulWidget {
  final ListingDraft? draft;

  const SellerPickupLocationScreen({
    this.draft,
    super.key,
  });

  @override
  State<SellerPickupLocationScreen> createState() =>
      _SellerPickupLocationScreenState();
}

class _SellerPickupLocationScreenState
    extends State<SellerPickupLocationScreen> {
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _prefillLocation();
  }

  Future<void> _prefillLocation() async {
    // If draft already has location, use that
    if (widget.draft?.pickupCity != null && widget.draft!.pickupCity!.isNotEmpty) {
      _cityController.text = widget.draft!.pickupCity!;
      _areaController.text = widget.draft!.pickupArea ?? '';
      _addressController.text = widget.draft!.pickupAddress ?? '';
      return;
    }

    // Otherwise pre-fill from user profile
    final profile = await ProfileService.instance.fetchProfile();
    if (profile != null && mounted) {
      setState(() {
        if (_cityController.text.isEmpty && profile.city.isNotEmpty) {
          _cityController.text = profile.city;
        }
        if (_areaController.text.isEmpty && profile.area.isNotEmpty) {
          _areaController.text = profile.area;
        }
        if (_addressController.text.isEmpty && profile.address.isNotEmpty) {
          _addressController.text = profile.address;
        }
      });
    }
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
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
            controller: controller,
            maxLines: isMultiline ? 4 : 1,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 12, right: 8),
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.grey.shade400,
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  void _onContinue() {
    final currentDraft = widget.draft ?? ListingDraft();
    currentDraft.pickupCity = _cityController.text.trim();
    currentDraft.pickupArea = _areaController.text.trim().isNotEmpty ? _areaController.text.trim() : null;
    currentDraft.pickupAddress = _addressController.text.trim();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SellerContactInformationScreen(
          draft: currentDraft,
        ),
      ),
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
          'Pickup Location',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress indicator
              Builder(
                builder: (context) {
                  final bool isComplete = widget.draft?.category == 'Complete Solar System';
                  final int totalSteps = isComplete ? 4 : 6;
                  final int currentStep = isComplete ? 2 : 4;
                  final String stepText = isComplete
                      ? 'Listing Details · Step 2 of 4 (Location)'
                      : 'Step 4 of 6';
                  final String percentText = isComplete ? '50%' : '67%';

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
              const SizedBox(height: 20),

              // City
              _buildTextField(
                label: 'City',
                hint: 'Karachi',
                controller: _cityController,
                icon: Icons.location_on_outlined,
              ),

              // Area / Locality
              _buildTextField(
                label: 'Area / Locality (optional)',
                hint: 'DHA Phase 7, karachi',
                controller: _areaController,
                icon: Icons.location_on_outlined,
              ),

              // Complete Address
              _buildTextField(
                label: 'Complete Address',
                hint: 'Street, building, area details...',
                controller: _addressController,
                icon: Icons.location_on_outlined,
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
                        onPressed: _onContinue,
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
    _cityController.dispose();
    _areaController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}

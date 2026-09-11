import 'package:flutter/material.dart';
import '../../models/listing_draft.dart';
import '../../services/profile_service.dart';
import 'seller_listing_preview_screen.dart';

class SellerContactInformationScreen extends StatefulWidget {
  final ListingDraft? draft;

  const SellerContactInformationScreen({
    this.draft,
    super.key,
  });

  @override
  State<SellerContactInformationScreen> createState() =>
      _SellerContactInformationScreenState();
}

class _SellerContactInformationScreenState
    extends State<SellerContactInformationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _prefillContactInfo();
  }

  Future<void> _prefillContactInfo() async {
    // If draft already has contact info, use that
    if (widget.draft?.contactName != null && widget.draft!.contactName!.isNotEmpty) {
      _nameController.text = widget.draft!.contactName!;
      _phoneController.text = widget.draft!.contactPhone ?? '';
      _emailController.text = widget.draft!.contactEmail ?? '';
      return;
    }

    // Otherwise load from profile service
    final profile = await ProfileService.instance.fetchProfile();
    if (profile != null && mounted) {
      setState(() {
        if (_nameController.text.isEmpty && profile.displayName.isNotEmpty) {
          _nameController.text = profile.displayName;
        }
        if (_phoneController.text.isEmpty && profile.phoneNumber.isNotEmpty) {
          _phoneController.text = profile.phoneNumber;
        }
        if (_emailController.text.isEmpty && profile.email.isNotEmpty) {
          _emailController.text = profile.email;
        }
      });
    }
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
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
    currentDraft.contactName = _nameController.text.trim();
    currentDraft.contactPhone = _phoneController.text.trim();
    currentDraft.contactEmail = _emailController.text.trim();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SellerListingPreviewScreen(
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
          'Contact Information',
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
                  final int currentStep = isComplete ? 3 : 5;
                  final String stepText = isComplete
                      ? 'Listing Details · Step 3 of 4 (Contact)'
                      : 'Step 5 of 6';
                  final String percentText = isComplete ? '75%' : '83%';

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

              // Info banner
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.info_outline,
                      color: Color(0xFF2563EB),
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Pre-filled from your profile. Edit if needed.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF2563EB),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Full Name
              _buildTextField(
                label: 'Full Name',
                hint: 'Abdul Samad',
                controller: _nameController,
                icon: Icons.person_outline,
              ),

              // Phone Number
              _buildTextField(
                label: 'Phone Number',
                hint: '+92 3012345678',
                controller: _phoneController,
                icon: Icons.phone_outlined,
              ),

              // Email address
              _buildTextField(
                label: 'Email address',
                hint: 'abdul@suntech.com',
                controller: _emailController,
                icon: Icons.email_outlined,
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
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SellerEditProfileScreen extends StatefulWidget {
  const SellerEditProfileScreen({super.key});

  @override
  State<SellerEditProfileScreen> createState() =>
      _SellerEditProfileScreenState();
}

class _SellerEditProfileScreenState extends State<SellerEditProfileScreen> {
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _companyController;
  late TextEditingController _cityController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: 'Abdul Samad');
    _phoneController = TextEditingController(text: '+92 3012345678');
    _emailController = TextEditingController(text: 'abdul@suntech.com');
    _companyController = TextEditingController(text: 'SunTech Solar Pvt. Ltd.');
    _cityController = TextEditingController(text: 'Karachi');
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 56,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0xFFE9E9E9),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 18,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar with initials
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF00A63E),
                          Color(0xFF007D2E),
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'RM',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00A63E),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Full Name Field
              _buildInputField(
                label: 'Full Name',
                controller: _fullNameController,
                placeholder: 'Abdul Samad',
                iconAsset: 'assets/icons/person.svg',
              ),
              const SizedBox(height: 16),

              // Phone Number Field
              _buildInputField(
                label: 'Phone Number',
                controller: _phoneController,
                placeholder: '+92 3012345678',
                iconAsset: 'assets/icons/phone_call.svg',
              ),
              const SizedBox(height: 16),

              // Email Address Field
              _buildInputField(
                label: 'Email address',
                controller: _emailController,
                placeholder: 'abdul@suntech.com',
                iconAsset: 'assets/icons/email.svg',
              ),
              const SizedBox(height: 16),

              // Company Name Field
              _buildInputField(
                label: 'Company Name',
                controller: _companyController,
                placeholder: 'SunTech Solar Pvt. Ltd.',
                iconAsset: 'assets/icons/building.svg',
              ),
              const SizedBox(height: 16),

              // City Field
              _buildInputField(
                label: 'City',
                controller: _cityController,
                placeholder: 'Karachi',
                iconAsset: 'assets/icons/building.svg',
              ),
              const SizedBox(height: 32),

              // Save Changes Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile updated successfully!'),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    required String iconAsset,
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
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
              width: 1.0,
            ),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: const TextStyle(
                fontSize: 13,
                color: Color(0xFF9CA3AF),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset(
                  iconAsset,
                  width: 18,
                  height: 18,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF1E293B),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

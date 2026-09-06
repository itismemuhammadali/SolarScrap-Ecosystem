import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/buyer_profile.dart';
import '../../services/auth_service.dart';
import '../../services/buyer_profile_service.dart';

class BuyerEditProfileScreen extends StatefulWidget {
  final BuyerProfile? profile;

  const BuyerEditProfileScreen({super.key, this.profile});

  @override
  State<BuyerEditProfileScreen> createState() => _BuyerEditProfileScreenState();
}

class _BuyerEditProfileScreenState extends State<BuyerEditProfileScreen> {
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _cityController;
  late TextEditingController _areaController;

  File? _selectedImageFile;
  String? _profilePhotoUrl;
  bool _isSaving = false;
  bool _isUploadingPhoto = false;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    final user = AuthService.instance.currentUser;
    _fullNameController = TextEditingController(
      text: p?.displayName.isNotEmpty == true
          ? p!.displayName
          : (user?.displayName ?? ''),
    );
    _phoneController = TextEditingController(
      text: p?.phoneNumber.isNotEmpty == true
          ? p!.phoneNumber
          : (user?.phoneNumber ?? ''),
    );
    _cityController = TextEditingController(
      text: p?.city ?? '',
    );
    _areaController = TextEditingController(
      text: p?.area ?? '',
    );
    _profilePhotoUrl = p?.profilePhotoUrl;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  String _getInitials() {
    final name = _fullNameController.text.trim();
    if (name.isNotEmpty) {
      final parts = name.split(' ');
      if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return name[0].toUpperCase();
    }
    final email = widget.profile?.email ?? AuthService.instance.currentUser?.email;
    if (email != null && email.isNotEmpty) {
      return email[0].toUpperCase();
    }
    return 'B';
  }

  Future<void> _pickAndUploadPhoto() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        imageQuality: 85,
      );

      if (picked != null) {
        final file = File(picked.path);
        setState(() {
          _selectedImageFile = file;
          _isUploadingPhoto = true;
        });

        final uploadedUrl =
            await BuyerProfileService.instance.uploadProfilePhoto(file);
        if (mounted) {
          setState(() {
            _isUploadingPhoto = false;
            if (uploadedUrl != null) {
              _profilePhotoUrl = uploadedUrl;
            }
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isUploadingPhoto = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not pick photo: $e')),
        );
      }
    }
  }

  Future<void> _handleSave() async {
    final name = _fullNameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your full name')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final updateData = {
      'display_name': name,
      'phone_number': _phoneController.text.trim(),
      'city': _cityController.text.trim(),
      'area': _areaController.text.trim(),
      if (_profilePhotoUrl != null) 'profile_photo_url': _profilePhotoUrl,
    };

    final updatedProfile =
        await BuyerProfileService.instance.updateProfile(updateData);

    if (!mounted) return;
    setState(() => _isSaving = false);

    final currentUser = AuthService.instance.currentUser;
    final finalProfile = updatedProfile ??
        (widget.profile?.copyWith(
              displayName: name,
              phoneNumber: _phoneController.text.trim(),
              city: _cityController.text.trim(),
              area: _areaController.text.trim(),
              profilePhotoUrl: _profilePhotoUrl,
            ) ??
            BuyerProfile(
              userId: currentUser?.userId ?? 'buyer',
              email: currentUser?.email ?? '',
              role: 'buyer',
              displayName: name,
              phoneNumber: _phoneController.text.trim(),
              city: _cityController.text.trim(),
              area: _areaController.text.trim(),
              profilePhotoUrl: _profilePhotoUrl,
            ));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: Color(0xFF00A63E),
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.pop(context, finalProfile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),

                      // Back Button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF3F4F6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.black87,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Title
                      const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Avatar Section
                      Center(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: _pickAndUploadPhoto,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFFE5E7EB),
                                        width: 2,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: _isUploadingPhoto
                                          ? const Center(
                                              child: SizedBox(
                                                width: 24,
                                                height: 24,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Color(0xFF00A63E),
                                                ),
                                              ),
                                            )
                                          : _buildAvatarImage(),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 2,
                                    right: 2,
                                    child: Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF00A63E),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Tap to change photo',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF9CA3AF),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Full Name Field
                      _buildInputField(
                        label: 'Full Name',
                        controller: _fullNameController,
                        hintText: 'Enter your full name',
                      ),
                      const SizedBox(height: 18),

                      // Phone Number Field
                      _buildInputField(
                        label: 'Phone Number',
                        controller: _phoneController,
                        hintText: 'e.g. +92 300 1234567',
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 18),

                      // City Field
                      _buildInputField(
                        label: 'City',
                        controller: _cityController,
                        hintText: 'e.g. Karachi, Lahore, Islamabad',
                      ),
                      const SizedBox(height: 18),

                      // Area Field
                      _buildInputField(
                        label: 'Area / Street Address',
                        controller: _areaController,
                        hintText: 'e.g. SITE Area, Gulberg',
                      ),

                      const Spacer(),
                      const SizedBox(height: 24),

                      // Save Changes Button
                      Container(
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFF00A63E), Color(0xFF007D2E)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _handleSave,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAvatarImage() {
    if (_selectedImageFile != null) {
      return Image.file(
        _selectedImageFile!,
        width: 90,
        height: 90,
        fit: BoxFit.cover,
      );
    }
    final fullUrl = BuyerProfileService.instance.getFullImageUrl(_profilePhotoUrl);
    if (fullUrl != null && fullUrl.isNotEmpty) {
      return Image.network(
        fullUrl,
        width: 90,
        height: 90,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 90,
          height: 90,
          decoration: const BoxDecoration(
            color: Color(0xFF00A63E),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              _getInitials(),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }
    return Container(
      width: 90,
      height: 90,
      decoration: const BoxDecoration(
        color: Color(0xFF00A63E),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          _getInitials(),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
              width: 1.0,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF111827),
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                fontSize: 14,
                color: Color(0xFF9CA3AF),
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../l10n/app_localizations.dart';
import '../../models/registration_data.dart';
import '../../utils/permission_helper.dart';
import '../../utils/rtl_helper.dart';
import '../../widgets/location_picker_widget.dart';
import 'buyer_create_account_verify_otp_screen.dart';

class BuyerCreateAccountDetailsScreen extends StatefulWidget {
  final RegistrationData data;

  const BuyerCreateAccountDetailsScreen({
    super.key,
    required this.data,
  });

  @override
  State<BuyerCreateAccountDetailsScreen> createState() =>
      _BuyerCreateAccountDetailsScreenState();
}

class _BuyerCreateAccountDetailsScreenState
    extends State<BuyerCreateAccountDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  late final TextEditingController _companyNameController;
  late final TextEditingController _gstController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _areaController;

  File? _profileImage;
  String _companyType = 'Scrap Dealer';
  double? _latitude;
  double? _longitude;

  final List<String> _businessTypes = [
    'Scrap Dealer',
    'Recycler',
    'Trader / Broker',
    'Solar EPC Contractor',
    'Manufacturer',
    'Other Business',
  ];

  String _getBusinessTypeName(BuildContext context, String type) {
    final l10n = AppLocalizations.of(context);
    switch (type) {
      case 'Scrap Dealer':
        return l10n.businessTypeScrapDealer;
      case 'Recycler':
        return l10n.businessTypeRecycler;
      case 'Trader / Broker':
        return l10n.businessTypeTraderBroker;
      case 'Solar EPC Contractor':
        return l10n.businessTypeSolarEpc;
      case 'Manufacturer':
        return l10n.businessTypeManufacturer;
      case 'Other Business':
        return l10n.businessTypeOtherBusiness;
      default:
        return type;
    }
  }

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.data.fullName);
    _companyNameController =
        TextEditingController(text: widget.data.companyName);
    _gstController = TextEditingController(text: widget.data.gstNumber ?? '');
    _addressController = TextEditingController(text: widget.data.address);
    _cityController = TextEditingController(text: widget.data.city);
    _areaController = TextEditingController(text: widget.data.area);
    _companyType = widget.data.companyType ?? 'Scrap Dealer';
    _latitude = widget.data.latitude;
    _longitude = widget.data.longitude;
    _profileImage = widget.data.profilePhotoFile;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _companyNameController.dispose();
    _gstController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  void _showImagePickerModal() {
    PermissionHelper.showImagePickerModal(
      context,
      hasExistingPhoto: _profileImage != null,
      onSourceSelected: (source) async {
        try {
          final picker = ImagePicker();
          final picked = await picker.pickImage(source: source);
          if (picked != null) {
            setState(() => _profileImage = File(picked.path));
          }
        } catch (_) {}
      },
      onRemovePhoto: () {
        setState(() => _profileImage = null);
      },
    );
  }

  void _handleContinue() {
    if (!_formKey.currentState!.validate()) return;

    widget.data.fullName = _fullNameController.text.trim();
    widget.data.companyName = _companyNameController.text.trim();
    widget.data.companyType = _companyType;
    widget.data.gstNumber = _gstController.text.trim().isNotEmpty
        ? _gstController.text.trim()
        : null;
    widget.data.address = _addressController.text.trim();
    widget.data.city = _cityController.text.trim();
    widget.data.area = _areaController.text.trim();
    widget.data.latitude = _latitude;
    widget.data.longitude = _longitude;
    widget.data.profilePhotoFile = _profileImage;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BuyerCreateAccountVerifyOtpScreen(data: widget.data),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Back Button and Centered Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: RTLHelper.backIcon(context, color: Colors.black, size: 20),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    Text(
                      l10n.businessAndLocation,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
                const SizedBox(height: 16),

                // Synchronized Step Progress Indicator: Step 2 of 3 (66%)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.step2Of3BusinessDetails,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    Text(
                      '66%',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF00A63E),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00A63E),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00A63E),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Profile Photo Picker
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: _showImagePickerModal,
                            child: Container(
                              width: 84,
                              height: 84,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFF3F4F6),
                                border: Border.all(
                                  color: _profileImage != null
                                      ? const Color(0xFF00A63E)
                                      : const Color(0xFFE2E8F0),
                                  width: 2.5,
                                ),
                                image: _profileImage != null
                                    ? DecorationImage(
                                        image: FileImage(_profileImage!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: _profileImage == null
                                  ? const Icon(
                                      Icons.business,
                                      size: 38,
                                      color: Color(0xFF94A3B8),
                                    )
                                  : null,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _showImagePickerModal,
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00A63E),
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 13,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _profileImage != null
                            ? l10n.changePhoto
                            : l10n.uploadProfileLogo,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF00A63E),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Full Name
                Text(
                  l10n.contactPersonRequired,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _fullNameController,
                  style: GoogleFonts.poppins(fontSize: 14),
                  decoration: _inputDecoration(
                    hint: 'e.g. John Doe',
                    icon: Icons.person_outline,
                  ),
                  validator: (val) =>
                      val == null || val.trim().isEmpty ? l10n.enterNameError : null,
                ),
                const SizedBox(height: 16),

                // Company Name
                Text(
                  l10n.companyYardNameRequired,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _companyNameController,
                  style: GoogleFonts.poppins(fontSize: 14),
                  decoration: _inputDecoration(
                    hint: 'e.g. EcoSolar Scrap Solutions',
                    icon: Icons.storefront_outlined,
                  ),
                  validator: (val) => val == null || val.trim().isEmpty
                      ? l10n.enterCompanyNameError
                      : null,
                ),
                const SizedBox(height: 16),

                // Business Type Dropdown
                Text(
                  l10n.businessTypeRequired,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _companyType,
                  items: _businessTypes
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(_getBusinessTypeName(context, type),
                              style: GoogleFonts.poppins(fontSize: 14)),
                        ),
                      )
                      .toList(),
                  onChanged: (val) =>
                      setState(() => _companyType = val ?? 'Scrap Dealer'),
                  decoration: _inputDecoration(
                    hint: l10n.selectBusinessType,
                    icon: Icons.category_outlined,
                  ),
                ),
                const SizedBox(height: 16),

                // GST / Tax ID (Optional)
                Text(
                  l10n.gstNtnOptional,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _gstController,
                  style: GoogleFonts.poppins(fontSize: 14),
                  decoration: _inputDecoration(
                    hint: 'e.g. 27ABCDE1234F1Z5',
                    icon: Icons.badge_outlined,
                  ),
                ),
                const SizedBox(height: 24),

                // Interactive Location Map Picker
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.businessLocationRequired,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      l10n.pinOnMap,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF00A63E),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LocationPickerWidget(
                  initialLatitude: _latitude,
                  initialLongitude: _longitude,
                  onLocationSelected: (locationData) {
                    setState(() {
                      _addressController.text = locationData.fullAddress;
                      _cityController.text = locationData.city;
                      _areaController.text = locationData.area;
                      _latitude = locationData.latitude;
                      _longitude = locationData.longitude;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Address Line
                Text(
                  l10n.streetAddressRequired,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _addressController,
                  style: GoogleFonts.poppins(fontSize: 14),
                  decoration: _inputDecoration(
                    hint: 'Plot No., Industrial Area, Street Address',
                    icon: Icons.location_on_outlined,
                  ),
                  validator: (val) => val == null || val.trim().isEmpty
                      ? l10n.enterStreetAddressError
                      : null,
                ),
                const SizedBox(height: 16),

                // City & Area
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.cityRequired,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _cityController,
                            style: GoogleFonts.poppins(fontSize: 14),
                            decoration: _inputDecoration(
                              hint: 'e.g. Lahore',
                              icon: Icons.location_city_outlined,
                            ),
                            validator: (val) =>
                                val == null || val.trim().isEmpty
                                    ? l10n.enterCityError
                                    : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.areaDistrictLabel,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _areaController,
                            style: GoogleFonts.poppins(fontSize: 14),
                            decoration: _inputDecoration(
                              hint: 'e.g. Gulberg',
                              icon: Icons.map_outlined,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Continue to Phone Verification Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _handleContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A63E),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      l10n.continueToMobileVerification,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
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
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF94A3B8), size: 20),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF00A63E)),
      ),
    );
  }
}

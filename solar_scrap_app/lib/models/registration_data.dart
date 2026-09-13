import 'dart:io';

class RegistrationData {
  final String role;
  String fullName;
  String email;
  String phoneNumber;
  String companyName;
  String city;
  String area;
  String address;
  String? companyType;
  String? gstNumber;
  String? password;
  String? authProvider;
  bool emailVerified;
  bool phoneVerified;
  bool twoFactorEnabled;
  String? fcmToken;
  File? profilePhotoFile;
  double? latitude;
  double? longitude;

  RegistrationData({
    required this.role,
    this.fullName = '',
    this.email = '',
    this.phoneNumber = '',
    this.companyName = '',
    this.city = '',
    this.area = '',
    this.address = '',
    this.companyType,
    this.gstNumber,
    this.password,
    this.authProvider = 'password',
    this.emailVerified = false,
    this.phoneVerified = false,
    this.twoFactorEnabled = false,
    this.fcmToken,
    this.profilePhotoFile,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'company_name': companyName,
      'city': city,
      'area': area,
      'address': address,
      'company_type': companyType,
      if (gstNumber != null) 'gst_number': gstNumber,
      if (password != null) 'password': password,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      'email_verified': emailVerified,
      'phone_verified': phoneVerified,
      'two_factor_enabled': twoFactorEnabled,
      if (fcmToken != null) 'fcm_token': fcmToken,
    };
  }
}

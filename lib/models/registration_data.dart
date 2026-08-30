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
  String? password;
  File? profilePhotoFile;

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
    this.password,
    this.profilePhotoFile,
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
      if (password != null) 'password': password,
    };
  }
}

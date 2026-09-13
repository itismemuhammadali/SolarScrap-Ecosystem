class SellerProfile {
  final String userId;
  final String email;
  final String role;
  final String displayName;
  final String phoneNumber;
  final String companyName;
  final String city;
  final String area;
  final String address;
  final String companyType;
  final String gstNumber;
  final String? profilePhotoUrl;
  final String status;
  final double? latitude;
  final double? longitude;

  SellerProfile({
    required this.userId,
    required this.email,
    required this.role,
    this.displayName = '',
    this.phoneNumber = '',
    this.companyName = '',
    this.city = '',
    this.area = '',
    this.address = '',
    this.companyType = 'Private Limited',
    this.gstNumber = '',
    this.profilePhotoUrl,
    this.status = 'approved',
    this.latitude,
    this.longitude,
  });

  bool get isApproved => status.toLowerCase() == 'approved';
  bool get isPending => status.toLowerCase() == 'pending';

  factory SellerProfile.fromJson(Map<String, dynamic> json) {
    return SellerProfile(
      userId: json['user_id'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'seller',
      displayName: json['display_name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      companyName: json['company_name'] ?? '',
      city: json['city'] ?? '',
      area: json['area'] ?? '',
      address: json['address'] ?? '',
      companyType: json['company_type'] ?? 'Private Limited',
      gstNumber: json['gst_number'] ?? '',
      profilePhotoUrl: json['profile_photo_url'],
      status: json['status'] ?? 'approved',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'email': email,
      'role': role,
      'display_name': displayName,
      'phone_number': phoneNumber,
      'company_name': companyName,
      'city': city,
      'area': area,
      'address': address,
      'company_type': companyType,
      'gst_number': gstNumber,
      if (profilePhotoUrl != null) 'profile_photo_url': profilePhotoUrl,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    };
  }

  SellerProfile copyWith({
    String? displayName,
    String? phoneNumber,
    String? companyName,
    String? city,
    String? area,
    String? address,
    String? companyType,
    String? gstNumber,
    String? profilePhotoUrl,
  }) {
    return SellerProfile(
      userId: userId,
      email: email,
      role: role,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      companyName: companyName ?? this.companyName,
      city: city ?? this.city,
      area: area ?? this.area,
      address: address ?? this.address,
      companyType: companyType ?? this.companyType,
      gstNumber: gstNumber ?? this.gstNumber,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
    );
  }
}

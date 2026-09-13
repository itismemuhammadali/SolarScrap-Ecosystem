class BuyerProfile {
  final String userId;
  final String email;
  final String role;
  final String displayName;
  final String phoneNumber;
  final String city;
  final String area;
  final String address;
  final String? profilePhotoUrl;
  final bool isVerified;
  final String status;
  final double? latitude;
  final double? longitude;

  BuyerProfile({
    required this.userId,
    required this.email,
    required this.role,
    this.displayName = '',
    this.phoneNumber = '',
    this.city = '',
    this.area = '',
    this.address = '',
    this.profilePhotoUrl,
    this.isVerified = false,
    this.status = 'approved',
    this.latitude,
    this.longitude,
  });

  bool get isApproved => status.toLowerCase() == 'approved';
  bool get isPending => status.toLowerCase() == 'pending';

  factory BuyerProfile.fromJson(Map<String, dynamic> json) {
    final rawStatus = json['status']?.toString() ?? 'approved';
    return BuyerProfile(
      userId: json['user_id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? 'buyer',
      displayName: json['display_name']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      area: json['area']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      profilePhotoUrl: json['profile_photo_url']?.toString(),
      isVerified: rawStatus.toLowerCase() == 'approved' || json['is_verified'] == true,
      status: rawStatus,
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
      'city': city,
      'area': area,
      'address': address,
      if (profilePhotoUrl != null) 'profile_photo_url': profilePhotoUrl,
      'is_verified': isVerified,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    };
  }

  BuyerProfile copyWith({
    String? displayName,
    String? phoneNumber,
    String? city,
    String? area,
    String? address,
    String? profilePhotoUrl,
    bool? isVerified,
  }) {
    return BuyerProfile(
      userId: userId,
      email: email,
      role: role,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      city: city ?? this.city,
      area: area ?? this.area,
      address: address ?? this.address,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}

class Listing {
  final String id;
  final String sellerId;
  final String category;
  final String status;
  final double priceDemand;
  final Map<String, dynamic> specs;
  final List<String> imageUrls;
  final String pickupCity;
  final String? pickupArea;
  final String pickupAddress;
  final String contactName;
  final String contactPhone;
  final String contactEmail;
  final String? createdAt;
  final String? updatedAt;

  Listing({
    required this.id,
    required this.sellerId,
    required this.category,
    required this.status,
    required this.priceDemand,
    required this.specs,
    required this.imageUrls,
    required this.pickupCity,
    this.pickupArea,
    required this.pickupAddress,
    required this.contactName,
    required this.contactPhone,
    required this.contactEmail,
    this.createdAt,
    this.updatedAt,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['id']?.toString() ?? '',
      sellerId: json['seller_id']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      status: json['status']?.toString() ?? 'active',
      priceDemand: (json['price_demand'] as num?)?.toDouble() ?? 0.0,
      specs: json['specs'] is Map ? Map<String, dynamic>.from(json['specs']) : {},
      imageUrls: json['image_urls'] is List
          ? List<String>.from(json['image_urls'].map((e) => e.toString()))
          : [],
      pickupCity: json['pickup_city']?.toString() ?? '',
      pickupArea: json['pickup_area']?.toString(),
      pickupAddress: json['pickup_address']?.toString() ?? '',
      contactName: json['contact_name']?.toString() ?? '',
      contactPhone: json['contact_phone']?.toString() ?? '',
      contactEmail: json['contact_email']?.toString() ?? '',
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'seller_id': sellerId,
      'category': category,
      'status': status,
      'price_demand': priceDemand,
      'specs': specs,
      'image_urls': imageUrls,
      'pickup_city': pickupCity,
      'pickup_area': pickupArea,
      'pickup_address': pickupAddress,
      'contact_name': contactName,
      'contact_phone': contactPhone,
      'contact_email': contactEmail,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

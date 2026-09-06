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

  /// Computed display title
  String get title {
    if (category == 'Solar Panels') {
      final type = specs['panel_type'] ?? 'Solar Panels';
      final count = specs['panels_count'] ?? specs['quantity'];
      final watts = specs['watts_per_panel'];
      if (count != null && watts != null) {
        return '$count× $type (${watts}W)';
      } else if (watts != null) {
        return '$type (${watts}W)';
      }
      return type.toString();
    } else if (category == 'Batteries') {
      final type = specs['battery_type'] ?? 'Batteries';
      final count = specs['battery_count'] ?? specs['quantity'];
      final ah = specs['battery_ah'] ?? specs['capacity'];
      if (count != null && ah != null) {
        return '$count× $type Battery ($ah)';
      }
      return type.toString();
    } else if (category == 'Inverters') {
      final brand = specs['inverter_brand'] ?? 'Solar Inverter';
      final cap = specs['inverter_capacity_kw'] ?? specs['capacity'];
      if (cap != null) {
        return '$brand ${cap}kW Inverter';
      }
      return brand.toString();
    } else if (category == 'Transformers') {
      final kva = specs['transformer_kva'] ?? specs['capacity'];
      if (kva != null) {
        return 'Distribution Transformer ${kva}kVA';
      }
      return 'Distribution Transformer';
    } else if (category == 'Cables') {
      final length = specs['cable_length_meters'] ?? specs['length'];
      if (length != null) {
        return 'Solar Copper Cables (${length}m)';
      }
      return 'Solar Copper Cables';
    }
    return category.isNotEmpty ? category : 'Solar Scrap Equipment';
  }

  /// Quantity display string
  String get quantityDisplay {
    if (specs['panels_count'] != null) return '${specs['panels_count']} units';
    if (specs['battery_count'] != null) return '${specs['battery_count']} units';
    if (specs['inverter_count'] != null) return '${specs['inverter_count']} units';
    if (specs['cable_length_meters'] != null) return '${specs['cable_length_meters']} meters';
    if (specs['quantity'] != null) return '${specs['quantity']} units';
    return '1 lot';
  }

  /// Formatted price with commas, e.g. "PKR 92,000"
  String get formattedPrice {
    final intVal = priceDemand.toInt();
    final str = intVal.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i > 0) {
        buffer.write(',');
      }
    }
    return 'PKR ${buffer.toString().split('').reversed.join('')}';
  }

  /// Formatted location
  String get locationDisplay {
    if (pickupArea != null && pickupArea!.isNotEmpty && pickupCity.isNotEmpty) {
      return '$pickupArea, $pickupCity';
    }
    return pickupCity.isNotEmpty ? pickupCity : 'Pakistan';
  }

  /// First image URL if any
  String? get firstImageUrl => imageUrls.isNotEmpty ? imageUrls.first : null;

  /// Formatted creation date
  String get createdFormatted {
    if (createdAt == null || createdAt!.isEmpty) return 'Recently';
    try {
      final dt = DateTime.parse(createdAt!);
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      final min = dt.minute.toString().padLeft(2, '0');
      return '${months[dt.month - 1]} ${dt.day}, $hour:$min $ampm';
    } catch (_) {
      return 'Recently';
    }
  }
}

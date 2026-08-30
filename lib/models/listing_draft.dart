class ListingDraft {
  String? category;
  double? priceDemand;
  Map<String, dynamic> specs;
  List<String> imageUrls; // Can be local file paths initially or uploaded remote URLs
  String? pickupCity;
  String? pickupArea;
  String? pickupAddress;
  String? contactName;
  String? contactPhone;
  String? contactEmail;

  ListingDraft({
    this.category,
    this.priceDemand,
    Map<String, dynamic>? specs,
    List<String>? imageUrls,
    this.pickupCity,
    this.pickupArea,
    this.pickupAddress,
    this.contactName,
    this.contactPhone,
    this.contactEmail,
  })  : specs = specs ?? {},
        imageUrls = imageUrls ?? [];

  Map<String, dynamic> toJson() {
    return {
      'category': category ?? '',
      'price_demand': priceDemand ?? 0.0,
      'specs': specs,
      'image_urls': imageUrls,
      'pickup_city': pickupCity ?? '',
      'pickup_area': pickupArea,
      'pickup_address': pickupAddress ?? '',
      'contact_name': contactName ?? '',
      'contact_phone': contactPhone ?? '',
      'contact_email': contactEmail ?? '',
    };
  }

  /// Helper to get a human-readable title for preview
  String get displayTitle {
    if (category == 'Solar Panels') {
      final count = specs['panels_count'] ?? '';
      final watts = specs['watts_per_panel'] ?? '';
      if (count.toString().isNotEmpty && watts.toString().isNotEmpty) {
        return '${count}x Solar Panels ${watts}W';
      }
      return 'Solar Panels';
    } else if (category == 'Batteries') {
      final type = specs['battery_type'] ?? '';
      final count = specs['battery_count'] ?? '';
      final brand = specs['battery_brand'] ?? '';
      if (brand.toString().isNotEmpty) {
        return '$brand $type Batteries (${count}x)';
      }
      return '$type Batteries';
    } else if (category == 'Inverters') {
      final type = specs['inverter_type'] ?? '';
      final power = specs['rated_power'] ?? '';
      final brand = specs['inverter_brand'] ?? '';
      if (brand.toString().isNotEmpty) {
        return '$brand $type Inverter $power';
      }
      return '$type Inverter';
    } else if (category == 'Cables') {
      final type = specs['cable_type'] ?? '';
      final size = specs['cable_size'] ?? '';
      return '$type Cables $size';
    } else if (category == 'Structure') {
      final type = specs['structure_type'] ?? '';
      final metal = specs['structure_metal'] ?? '';
      return '$type ($metal) Mounting Structure';
    } else if (category == 'Complete Solar System') {
      return 'Complete Solar System';
    }
    return category ?? 'Equipment Listing';
  }

  /// Helper to get subtitle/tag for preview
  String get displaySubtitle {
    if (category == 'Solar Panels') {
      final condition = specs['panel_condition'] ?? 'Good Condition';
      return 'Solar Panels · $condition';
    } else if (category == 'Batteries') {
      final condition = specs['battery_condition'] ?? 'Working';
      final cap = specs['battery_capacity'] ?? '';
      return 'Batteries · $cap · $condition';
    } else if (category == 'Inverters') {
      final condition = specs['inverter_condition'] ?? 'Working';
      return 'Inverters · $condition';
    } else if (category == 'Cables') {
      final cond = specs['cable_conductor'] ?? '';
      final ins = specs['insulation_type'] ?? '';
      return 'Cables · $cond · $ins';
    } else if (category == 'Structure') {
      final metal = specs['structure_metal'] ?? '';
      return 'Structure · $metal';
    } else if (category == 'Complete Solar System') {
      return 'Full Solar System Package';
    }
    return category ?? '';
  }
}

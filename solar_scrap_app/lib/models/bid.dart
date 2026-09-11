import 'package:flutter/material.dart';

class Bid {
  final String id;
  final String listingId;
  final String sellerId;
  final String buyerId;
  final String buyerName;
  final double amount;
  final String status;
  final String referenceNumber;
  final String? listingTitle;
  final String? listingCategory;
  final String? listingImage;
  final String? createdAt;
  final String? updatedAt;

  Bid({
    required this.id,
    required this.listingId,
    required this.sellerId,
    required this.buyerId,
    required this.buyerName,
    required this.amount,
    required this.status,
    required this.referenceNumber,
    this.listingTitle,
    this.listingCategory,
    this.listingImage,
    this.createdAt,
    this.updatedAt,
  });

  factory Bid.fromJson(Map<String, dynamic> json) {
    return Bid(
      id: json['id']?.toString() ?? '',
      listingId: json['listing_id']?.toString() ?? '',
      sellerId: json['seller_id']?.toString() ?? '',
      buyerId: json['buyer_id']?.toString() ?? '',
      buyerName: json['buyer_name']?.toString() ?? 'Buyer',
      amount: (json['amount'] is num) ? (json['amount'] as num).toDouble() : 0.0,
      status: json['status']?.toString() ?? 'pending',
      referenceNumber: json['reference_number']?.toString() ?? '# BID',
      listingTitle: json['listing_title']?.toString(),
      listingCategory: json['listing_category']?.toString(),
      listingImage: json['listing_image']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'listing_id': listingId,
      'seller_id': sellerId,
      'buyer_id': buyerId,
      'buyer_name': buyerName,
      'amount': amount,
      'status': status,
      'reference_number': referenceNumber,
      'listing_title': listingTitle,
      'listing_category': listingCategory,
      'listing_image': listingImage,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  String get formattedAmount {
    final str = amount.toInt().toString();
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

  String get titleDisplay {
    if (listingTitle != null && listingTitle!.isNotEmpty) {
      return listingTitle!;
    }
    if (listingCategory != null && listingCategory!.isNotEmpty) {
      return listingCategory!;
    }
    return 'Solar Equipment';
  }

  String get statusDisplay {
    switch (status.toLowerCase()) {
      case 'accepted':
      case 'won':
        return 'Won';
      case 'rejected':
      case 'lost':
        return 'Lost';
      case 'outbid':
        return 'Outbid';
      case 'winning':
        return 'Winning';
      case 'pending':
        return 'Pending';
      case 'active':
      default:
        return 'Active';
    }
  }

  String get statusGroup {
    final s = status.toLowerCase();
    if (s == 'accepted' || s == 'won' || s == 'rejected' || s == 'lost' || s == 'closed') {
      return 'Closed';
    }
    if (s == 'winning') {
      return 'Winning';
    }
    return 'Active';
  }

  Color get statusColor {
    switch (statusDisplay) {
      case 'Won':
      case 'Winning':
        return const Color(0xFF00A63E);
      case 'Pending':
      case 'Active':
        return const Color(0xFF2563EB);
      case 'Outbid':
        return const Color(0xFFD97706);
      case 'Lost':
      case 'Closed':
      default:
        return const Color(0xFFEF4444);
    }
  }

  Color get statusBg {
    switch (statusDisplay) {
      case 'Won':
      case 'Winning':
        return const Color(0xFFEAF8EE);
      case 'Pending':
      case 'Active':
        return const Color(0xFFEFF6FF);
      case 'Outbid':
        return const Color(0xFFFEF3C7);
      case 'Lost':
      case 'Closed':
      default:
        return const Color(0xFFFEE2E2);
    }
  }

  String get fallbackAsset {
    final cat = (listingCategory ?? '').toLowerCase();
    final title = titleDisplay.toLowerCase();
    if (cat.contains('battery') || title.contains('batter')) return 'assets/images/battery.jpg';
    if (cat.contains('inverter') || title.contains('inverter')) return 'assets/images/inverter.png';
    if (cat.contains('cable') || title.contains('cable')) return 'assets/images/cables.jpg';
    if (cat.contains('complete') || title.contains('complete')) return 'assets/images/complete-solar-system.jpg';
    if (cat.contains('structure') || title.contains('structure')) return 'assets/images/structure.jpg';
    return 'assets/images/buyer-solar.jpg';
  }

  String get displayImage {
    if (listingImage != null && listingImage!.isNotEmpty) {
      return listingImage!;
    }
    return fallbackAsset;
  }

  String get dateDisplay {
    if (createdAt == null || createdAt!.isEmpty) return 'Recent';
    try {
      final dt = DateTime.parse(createdAt!);
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return 'Recent';
    }
  }
}

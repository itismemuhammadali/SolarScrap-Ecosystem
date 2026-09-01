import 'package:flutter/material.dart';

class NotificationItem {
  final String id;
  final String userId;
  final String type;
  final String title;
  final String description;
  final String? listingId;
  final bool isRead;
  final String? createdAt;

  NotificationItem({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.description,
    this.listingId,
    this.isRead = false,
    this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'listing_created',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      listingId: json['listing_id']?.toString(),
      isRead: json['is_read'] == true,
      createdAt: json['created_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'title': title,
      'description': description,
      'listing_id': listingId,
      'is_read': isRead,
      'created_at': createdAt,
    };
  }

  NotificationItem copyWith({
    String? id,
    String? userId,
    String? type,
    String? title,
    String? description,
    String? listingId,
    bool? isRead,
    String? createdAt,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      listingId: listingId ?? this.listingId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  IconData get iconData {
    switch (type) {
      case 'bid_winning':
      case 'bid_won':
      case 'deal_closed':
        return Icons.workspace_premium_outlined;
      case 'bid_outbid':
      case 'bid_updated':
      case 'new_bid_received':
        return Icons.trending_up_rounded;
      case 'price_offered':
        return Icons.payments_outlined;
      case 'auction_ending_soon':
      case 'auction_ending_24h':
      case 'listing_under_review':
        return Icons.access_time_outlined;
      case 'listing_published':
      case 'auction_live':
      case 'auction_new':
        return Icons.local_offer_outlined;
      case 'listing_rejected':
      case 'bid_lost':
        return Icons.highlight_off_outlined;
      case 'pickup_scheduled':
        return Icons.local_shipping_outlined;
      case 'account_verified':
      case 'profile_verified':
      case 'bid_confirmed':
      default:
        return Icons.shield_outlined;
    }
  }

  String get iconAsset {
    switch (type) {
      case 'price_offered':
      case 'deal_closed':
      case 'bid_winning':
      case 'bid_won':
        return 'assets/icons/dollar.svg';
      case 'listing_under_review':
      case 'auction_ending_soon':
        return 'assets/icons/clock.svg';
      case 'auction_live':
      case 'bid_updated':
      case 'new_bid_received':
        return 'assets/icons/stocks.svg';
      case 'listing_published':
      case 'listing_created':
      case 'profile_verified':
      case 'account_verified':
      default:
        return 'assets/icons/bell.svg';
    }
  }

  Color get iconBgColor {
    switch (type) {
      case 'price_offered':
      case 'deal_closed':
      case 'bid_winning':
      case 'bid_won':
      case 'bid_confirmed':
        return const Color(0xFFEAF8EE); // Soft Green
      case 'listing_under_review':
      case 'bid_outbid':
      case 'bid_updated':
        return const Color(0xFFEFF6FF); // Soft Blue
      case 'auction_live':
      case 'listing_published':
      case 'auction_new':
        return const Color(0xFFFFFBEB); // Soft Amber
      case 'auction_ending_soon':
      case 'auction_ending_24h':
      case 'listing_rejected':
      case 'bid_lost':
        return const Color(0xFFFFF1F2); // Soft Red
      case 'account_verified':
      case 'profile_verified':
      case 'listing_created':
      default:
        return const Color(0xFFF3F4F6); // Soft Gray
    }
  }

  Color get iconColor {
    switch (type) {
      case 'price_offered':
      case 'deal_closed':
      case 'bid_winning':
      case 'bid_won':
      case 'bid_confirmed':
        return const Color(0xFF00A63E); // Brand Green
      case 'listing_under_review':
      case 'bid_outbid':
      case 'bid_updated':
        return const Color(0xFF2563EB); // Blue
      case 'auction_live':
      case 'listing_published':
      case 'auction_new':
        return const Color(0xFFD97706); // Amber
      case 'auction_ending_soon':
      case 'auction_ending_24h':
      case 'listing_rejected':
      case 'bid_lost':
        return const Color(0xFFEF4444); // Red
      case 'account_verified':
      case 'profile_verified':
      case 'listing_created':
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }

  Color get unreadBgColor {
    switch (type) {
      case 'price_offered':
      case 'deal_closed':
      case 'bid_winning':
      case 'bid_won':
      case 'bid_confirmed':
        return const Color(0xFFF4FBF6);
      case 'auction_live':
      case 'listing_published':
      case 'auction_new':
        return const Color(0xFFFFFDF5);
      case 'auction_ending_soon':
      case 'auction_ending_24h':
      case 'listing_rejected':
      case 'bid_lost':
        return const Color(0xFFFFF7F7);
      default:
        return const Color(0xFFFAFAFA);
    }
  }

  Color get unreadBorderColor {
    switch (type) {
      case 'price_offered':
      case 'deal_closed':
      case 'bid_winning':
      case 'bid_won':
      case 'bid_confirmed':
        return const Color(0xFFD6F3DD);
      case 'auction_live':
      case 'listing_published':
      case 'auction_new':
        return const Color(0xFFFEF3C7);
      case 'auction_ending_soon':
      case 'auction_ending_24h':
      case 'listing_rejected':
      case 'bid_lost':
        return const Color(0xFFFEE2E2);
      default:
        return const Color(0xFFE5E7EB);
    }
  }

  String get timeFormatted {
    if (createdAt == null || createdAt!.isEmpty) return 'Just now';
    try {
      final dt = DateTime.parse(createdAt!);
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays == 1) return 'Yesterday';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return createdAt!;
    }
  }
}

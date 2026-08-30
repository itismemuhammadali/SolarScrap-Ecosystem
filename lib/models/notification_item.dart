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

  String get iconAsset {
    switch (type) {
      case 'price_offered':
      case 'deal_closed':
        return 'assets/icons/dollar.svg';
      case 'listing_under_review':
        return 'assets/icons/clock.svg';
      case 'auction_live':
        return 'assets/icons/stocks.svg';
      case 'listing_created':
      case 'profile_verified':
      default:
        return 'assets/icons/bell.svg';
    }
  }

  Color get iconBgColor {
    switch (type) {
      case 'price_offered':
      case 'deal_closed':
      case 'profile_verified':
        return const Color(0xFFDCFCE7);
      case 'listing_under_review':
        return const Color(0xFFEFF6FF);
      case 'auction_live':
        return const Color(0xFFF3E8FF);
      case 'listing_created':
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  Color get iconColor {
    switch (type) {
      case 'price_offered':
      case 'deal_closed':
      case 'profile_verified':
        return const Color(0xFF16A34A);
      case 'listing_under_review':
        return const Color(0xFF2563EB);
      case 'auction_live':
        return const Color(0xFF9333EA);
      case 'listing_created':
      default:
        return const Color(0xFF6B7280);
    }
  }

  String get timeFormatted {
    if (createdAt == null || createdAt!.isEmpty) return 'Just now';
    try {
      final dt = DateTime.parse(createdAt!);
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
      if (diff.inHours < 24) return '${diff.inHours} hr ago';
      if (diff.inDays < 7) return '${diff.inDays} days ago';
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return 'Recently';
    }
  }
}

import 'package:flutter/material.dart';
import '../../models/notification_item.dart';
import '../../services/notification_service.dart';
import 'buyer_dashboard_screen.dart';

class BuyerNotificationsScreen extends StatefulWidget {
  const BuyerNotificationsScreen({super.key});

  @override
  State<BuyerNotificationsScreen> createState() =>
      _BuyerNotificationsScreenState();
}

class _BuyerNotificationsScreenState extends State<BuyerNotificationsScreen> {
  bool _isLoading = false;
  List<NotificationItem> _notifications = [];

  final List<NotificationItem> _fallbackNotifications = [
    NotificationItem(
      id: 'bn-1',
      userId: 'user',
      type: 'bid_winning',
      title: "You're Winning!",
      description:
          'Your bid on Monocrystalline Solar Panels is currently the highest.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 2)).toIso8601String(),
      isRead: false,
    ),
    NotificationItem(
      id: 'bn-2',
      userId: 'user',
      type: 'auction_new',
      title: 'New Auction Listed',
      description:
          '100kVA Transformer available in Lahore. Starting at PKR 180,000.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)).toIso8601String(),
      isRead: false,
    ),
    NotificationItem(
      id: 'bn-3',
      userId: 'user',
      type: 'auction_ending_soon',
      title: 'Auction Ending Soon',
      description: 'Lithium Battery Bank auction closes in 1 hour.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 45)).toIso8601String(),
      isRead: false,
    ),
    NotificationItem(
      id: 'bn-4',
      userId: 'user',
      type: 'bid_outbid',
      title: 'Bid Outbid',
      description: 'Someone placed a higher bid on String Inverters 5kW.',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      isRead: true,
    ),
    NotificationItem(
      id: 'bn-5',
      userId: 'user',
      type: 'profile_verified',
      title: 'Profile Verified',
      description: 'Your business profile has been successfully verified.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      isRead: true,
    ),
    NotificationItem(
      id: 'bn-6',
      userId: 'user',
      type: 'auction_new',
      title: 'New Auction in Karachi',
      description: 'DC Cable Bundle listed near your area.',
      createdAt: DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      isRead: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    final list = await NotificationService.instance.fetchNotifications();
    if (!mounted) return;

    setState(() {
      if (list.isNotEmpty) {
        _notifications = list;
      } else {
        _notifications = List.from(_fallbackNotifications);
      }
      _isLoading = false;
    });
  }

  Future<void> _markAllAsRead() async {
    setState(() {
      _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    });
    await NotificationService.instance.markAllAsRead();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _markSingleAsRead(NotificationItem item) async {
    if (!item.isRead) {
      final index = _notifications.indexWhere((n) => n.id == item.id);
      if (index != -1) {
        setState(() {
          _notifications[index] = item.copyWith(isRead: true);
        });
        await NotificationService.instance.markAsRead(item.id);
      }
    }

    if (!mounted) return;

    if (item.type.contains('bid')) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const BuyerDashboardScreen(initialTabIndex: 2),
        ),
        (route) => false,
      );
    } else if (item.type.contains('auction') || item.type.contains('listing')) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const BuyerDashboardScreen(initialTabIndex: 1),
        ),
        (route) => false,
      );
    }
  }

  bool _isToday(String? dateStr) {
    if (dateStr == null) return true;
    try {
      final dt = DateTime.parse(dateStr);
      final now = DateTime.now();
      return dt.year == now.year && dt.month == now.month && dt.day == now.day;
    } catch (_) {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final todayList = _notifications.where((n) => _isToday(n.createdAt)).toList();
    final earlierList = _notifications.where((n) => !_isToday(n.createdAt)).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),

                  // Back Button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F4F6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.black87,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Header with Title and "Mark All Read"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.5,
                        ),
                      ),
                      if (_notifications.any((n) => !n.isRead))
                        GestureDetector(
                          onTap: _markAllAsRead,
                          child: const Text(
                            'Mark All Read',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF00A63E),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // Notification List or Loader
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF00A63E),
                      ),
                    )
                  : _notifications.isEmpty
                      ? _buildEmptyState()
                      : ListView(
                          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                          children: [
                            if (todayList.isNotEmpty) ...[
                              _buildSectionHeader('Today'),
                              const SizedBox(height: 8),
                              ...todayList.map((item) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _buildNotificationCard(item),
                                  )),
                            ],
                            if (earlierList.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              _buildSectionHeader('Earlier'),
                              const SizedBox(height: 8),
                              ...earlierList.map((item) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _buildNotificationCard(item),
                                  )),
                            ],
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Color(0xFF9CA3AF),
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem item) {
    final bool isUnread = !item.isRead;
    final Color bgColor = isUnread ? item.unreadBgColor : Colors.white;
    final Color borderColor =
        isUnread ? item.unreadBorderColor : const Color(0xFFE5E7EB);

    return GestureDetector(
      onTap: () => _markSingleAsRead(item),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: 1.0,
          ),
          boxShadow: isUnread
              ? [
                  BoxShadow(
                    color: item.iconColor.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: item.iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  item.iconData,
                  color: item.iconColor,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight:
                                isUnread ? FontWeight.bold : FontWeight.w600,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(left: 8),
                          decoration: const BoxDecoration(
                            color: Color(0xFF00A63E),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF4B5563),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.timeFormatted,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_off_outlined,
              size: 32,
              color: Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'We will notify you about your bids and new auctions.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF64748B),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

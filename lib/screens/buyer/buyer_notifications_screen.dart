import 'package:flutter/material.dart';

class BuyerNotificationItem {
  final String id;
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color iconColor;
  final Color? iconBgColor;
  final Color? unreadBgColor;
  final Color? unreadBorderColor;
  bool isUnread;

  BuyerNotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.iconColor,
    this.iconBgColor,
    this.unreadBgColor,
    this.unreadBorderColor,
    this.isUnread = false,
  });
}

class BuyerNotificationsScreen extends StatefulWidget {
  const BuyerNotificationsScreen({super.key});

  @override
  State<BuyerNotificationsScreen> createState() =>
      _BuyerNotificationsScreenState();
}

class _BuyerNotificationsScreenState extends State<BuyerNotificationsScreen> {
  final List<BuyerNotificationItem> _notifications = [
    BuyerNotificationItem(
      id: '1',
      title: "You're Winning!",
      description:
          'Your bid on Monocrystalline Solar Panels is currently the highest.',
      time: '2m ago',
      icon: Icons.workspace_premium_outlined,
      iconColor: const Color(0xFF00A63E),
      unreadBgColor: const Color(0xFFEAF8EE),
      unreadBorderColor: const Color(0xFFD6F3DD),
      isUnread: true,
    ),
    BuyerNotificationItem(
      id: '2',
      title: 'New Auction Listed',
      description:
          '100kVA Transformer available in Lahore. Starting at PKR 180,000.',
      time: '15m ago',
      icon: Icons.local_offer_outlined,
      iconColor: const Color(0xFFD97706),
      unreadBgColor: const Color(0xFFFFFBEB),
      unreadBorderColor: const Color(0xFFFEF3C7),
      isUnread: true,
    ),
    BuyerNotificationItem(
      id: '3',
      title: 'Auction Ending Soon',
      description: 'Lithium Battery Bank auction closes in 1 hour.',
      time: '45m ago',
      icon: Icons.access_time_outlined,
      iconColor: const Color(0xFFEF4444),
      unreadBgColor: const Color(0xFFFFF1F2),
      unreadBorderColor: const Color(0xFFFEE2E2),
      isUnread: true,
    ),
    BuyerNotificationItem(
      id: '4',
      title: 'Bid Outbid',
      description:
          'Someone placed a higher bid on String Inverters 5kW.',
      time: '2h ago',
      icon: Icons.trending_up_rounded,
      iconColor: const Color(0xFF2563EB),
      iconBgColor: const Color(0xFFEFF6FF),
      isUnread: false,
    ),
    BuyerNotificationItem(
      id: '5',
      title: 'Profile Verified',
      description:
          'Your business profile has been successfully verified.',
      time: '1d ago',
      icon: Icons.shield_outlined,
      iconColor: const Color(0xFF6B7280),
      iconBgColor: const Color(0xFFF3F4F6),
      isUnread: false,
    ),
    BuyerNotificationItem(
      id: '6',
      title: 'New Auction in Karachi',
      description: 'DC Cable Bundle listed near your area.',
      time: '1d ago',
      icon: Icons.local_offer_outlined,
      iconColor: const Color(0xFFD97706),
      iconBgColor: const Color(0xFFFEF3C7),
      isUnread: false,
    ),
  ];

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isUnread = false;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),

                  // Back Button
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
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

            // List of Notifications
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                itemCount: _notifications.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = _notifications[index];
                  return _buildNotificationCard(item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(BuyerNotificationItem item) {
    final bool isUnread = item.isUnread;
    final Color bgColor = isUnread
        ? (item.unreadBgColor ?? Colors.white)
        : Colors.white;
    final Color borderColor = isUnread
        ? (item.unreadBorderColor ?? const Color(0xFFE5E7EB))
        : const Color(0xFFE5E7EB);

    return GestureDetector(
      onTap: () {
        if (item.isUnread) {
          setState(() {
            item.isUnread = false;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: 1.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leading Icon
            if (item.iconBgColor != null)
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: item.iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    item.icon,
                    color: item.iconColor,
                    size: 18,
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(top: 2, right: 4),
                child: Icon(
                  item.icon,
                  color: item.iconColor,
                  size: 22,
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
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
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
                  const SizedBox(height: 5),
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
                    item.time,
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
}

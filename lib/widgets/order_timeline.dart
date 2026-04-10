import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/order.dart';

class OrderTimeline extends StatelessWidget {
  final OrderStatus currentStatus;

  const OrderTimeline({
    super.key,
    required this.currentStatus,
  });

  @override
  Widget build(BuildContext context) {
    final statuses = [
      _TimelineItem(
        status: OrderStatus.confirmed,
        title: 'Order Confirmed',
        subtitle: 'Your order has been received',
        icon: Icons.check_circle,
      ),
      _TimelineItem(
        status: OrderStatus.preparing,
        title: 'Preparing',
        subtitle: 'Chef is preparing your food',
        icon: Icons.restaurant,
      ),
      _TimelineItem(
        status: OrderStatus.ready,
        title: 'Ready',
        subtitle: 'Your order is ready',
        icon: Icons.takeout_dining,
      ),
      _TimelineItem(
        status: OrderStatus.outForDelivery,
        title: 'Out for Delivery',
        subtitle: 'On the way to you',
        icon: Icons.delivery_dining,
      ),
      _TimelineItem(
        status: OrderStatus.delivered,
        title: 'Delivered',
        subtitle: 'Enjoy your meal!',
        icon: Icons.home,
      ),
    ];

    return Column(
      children: statuses.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final isCompleted = _isStatusCompleted(item.status);
        final isCurrent = item.status == currentStatus;
        final isLast = index == statuses.length - 1;

        return _buildTimelineItem(
          item: item,
          isCompleted: isCompleted,
          isCurrent: isCurrent,
          isLast: isLast,
        );
      }).toList(),
    );
  }

  bool _isStatusCompleted(OrderStatus status) {
    final statusOrder = [
      OrderStatus.pending,
      OrderStatus.confirmed,
      OrderStatus.preparing,
      OrderStatus.ready,
      OrderStatus.outForDelivery,
      OrderStatus.delivered,
    ];

    final currentIndex = statusOrder.indexOf(currentStatus);
    final statusIndex = statusOrder.indexOf(status);

    return statusIndex <= currentIndex;
  }

  Widget _buildTimelineItem({
    required _TimelineItem item,
    required bool isCompleted,
    required bool isCurrent,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isCompleted ? AppTheme.primaryColor : Colors.grey.shade200,
                shape: BoxShape.circle,
                border: isCurrent
                    ? Border.all(color: AppTheme.primaryColor, width: 3)
                    : null,
                boxShadow: isCurrent
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                item.icon,
                size: 20,
                color: isCompleted ? Colors.white : Colors.grey,
              ),
            ),
            if (!isLast)
              Container(
                width: 3,
                height: 50,
                color: isCompleted ? AppTheme.primaryColor : Colors.grey.shade200,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isCompleted ? AppTheme.textPrimary : Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: isCompleted ? AppTheme.textSecondary : Colors.grey.shade400,
                  ),
                ),
                if (!isLast) const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TimelineItem {
  final OrderStatus status;
  final String title;
  final String subtitle;
  final IconData icon;

  _TimelineItem({
    required this.status,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
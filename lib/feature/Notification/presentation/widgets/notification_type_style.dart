import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';

/// Icon + color + short title for a [NotificationResponse.type] string
/// (the backend enum's name, e.g. "OrderShipped").
class NotificationTypeStyle {
  const NotificationTypeStyle({
    required this.icon,
    required this.color,
    required this.title,
  });

  final IconData icon;
  final Color color;
  final String title;

  factory NotificationTypeStyle.of(String type) => switch (type) {
        'OrderPaid' => const NotificationTypeStyle(
            icon: Icons.payments_outlined,
            color: AppColors.warning,
            title: 'Payment Successful',
          ),
        'OrderShipped' => const NotificationTypeStyle(
            icon: Icons.local_shipping_outlined,
            color: AppColors.info,
            title: 'Order Shipped',
          ),
        'OrderDelivered' => const NotificationTypeStyle(
            icon: Icons.home_outlined,
            color: AppColors.success,
            title: 'Order Delivered',
          ),
        'OrderCancelled' => const NotificationTypeStyle(
            icon: Icons.cancel_outlined,
            color: AppColors.error,
            title: 'Order Cancelled',
          ),
        'PrescriptionApproved' => const NotificationTypeStyle(
            icon: Icons.check_circle_outline,
            color: AppColors.deepTeal,
            title: 'Prescription Approved',
          ),
        'PrescriptionRejected' => const NotificationTypeStyle(
            icon: Icons.error_outline,
            color: AppColors.error,
            title: 'Prescription Rejected',
          ),
        _ => const NotificationTypeStyle(
            icon: Icons.notifications_outlined,
            color: AppColors.textSecondary,
            title: 'Notification',
          ),
      };
}

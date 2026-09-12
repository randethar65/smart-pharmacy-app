import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/feature/Notification/data/models/notification_response.dart';
import 'package:smart_pharmacy/feature/Notification/presentation/widgets/notification_type_style.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.notification,
    required this.timeLabel,
    this.onTap,
  });

  final NotificationResponse notification;
  final String timeLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final style = NotificationTypeStyle.of(notification.type);

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: style.color.withValues(alpha: 0.15),
                  child: Icon(style.icon, size: 22, color: style.color),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        style.title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontFamily: "PlusJakartaSans",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontFamily: "Inter",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        timeLabel,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontFamily: "Inter",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!notification.isRead)
            Positioned(
              top: 14,
              right: 14,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.deepTeal,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

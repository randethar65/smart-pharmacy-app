import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';

/// One row in the profile menu: circular icon + label + trailing.
/// [trailing] defaults to a chevron when [onTap] is set. Pass [color] for a
/// destructive row (Log out); [showDot] adds an unread badge on the icon.
class ProfileMenuTile extends StatelessWidget {
  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.trailing,
    this.color,
    this.showDot = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? color;
  final bool showDot;    // نقطة حمرا على الأيقونة (إشعارات غير مقروءة)

  @override
  Widget build(BuildContext context) {
    final fg = color ?? AppColors.textPrimary;
    final iconColor = color ?? AppColors.deepTeal;
    final circleBg =
        color != null ? color!.withValues(alpha: 0.12) : AppColors.blue;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: circleBg,
              child: Badge(
                  isLabelVisible: showDot,        // يظهر/يختفي
  smallSize: 8,     
  backgroundColor:AppColors.badgeColor,              // حجم النقطة
                child: Icon(icon, size: 20, color: iconColor)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: fg,
                ),
              ),
            ),
            if (trailing != null)
              trailing!
            else if (onTap != null)
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';

/// Big circular status icon with a soft halo, plus an optional small
/// corner badge (used for the ✕ on the rejected state).
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.color,
    required this.halo,
    required this.icon,
    this.cornerIcon,
  });

  final Color color;
  final Color halo;
  final IconData icon;
  final IconData? cornerIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(shape: BoxShape.circle, color: halo),
          ),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            child: Icon(icon, size: 34, color: Colors.white),
          ),
          if (cornerIcon != null)
            Positioned(
              right: 14,
              bottom: 22,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  border: Border.all(color: AppColors.background, width: 2),
                ),
                child: Icon(cornerIcon, size: 12, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}

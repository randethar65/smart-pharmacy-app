
import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';

/// Coral "Rx Required" pill, shown when the medicine needs a prescription.
class RxBadge extends StatelessWidget {
  const RxBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.medication_outlined, size: 14, color: AppColors.accent),
          SizedBox(width: 4),
          Text(
            'Rx Required',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}



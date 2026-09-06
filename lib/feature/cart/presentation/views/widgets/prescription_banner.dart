import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';

/// Coral notice shown above the cart when some items need a prescription.
class PrescriptionBanner extends StatelessWidget {
  const PrescriptionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.assignment_outlined, size: 18, color: AppColors.accent),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Some items need a prescription — you'll add it after checkout.",
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.4,
                color: AppColors.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';

/// Live "Password must contain:" panel. Each rule is a `(label, satisfied)`
/// pair; satisfied rules turn into a filled check.
class PasswordChecklist extends StatelessWidget {
  const PasswordChecklist({super.key, required this.rules});

  final List<(String, bool)> rules;
//  ('At least 8 characters', _has8),
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.infoSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Password must contain:',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          //  ('At least 8 characters', _has8),
          for (final (text, met) in rules)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Icon(
                    met ? Icons.check_circle : Icons.check_circle_outline,
                    size: 16,
                    color: met ? AppColors.success : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    text,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color:
                          met ? AppColors.textPrimary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

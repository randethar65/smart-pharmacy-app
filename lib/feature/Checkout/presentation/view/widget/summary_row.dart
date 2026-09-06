import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';

/// A label/value line in the order summary. [emphasize] styles it as the
/// grand total (bigger, bold, teal value).
class SummaryRow extends StatelessWidget {
  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: emphasize ? 'PlusJakartaSans' : 'Inter',
            fontSize: emphasize ? 18 : 14,
            fontWeight: emphasize ? FontWeight.w700 : FontWeight.w400,
            color: emphasize ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: emphasize ? 20 : 14,
            fontWeight: FontWeight.w700,
            color: emphasize ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

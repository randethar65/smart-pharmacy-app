

import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';

/// "Resend code in 0:29" → tappable "Resend code" once the timer hits zero.
class ResendRow extends StatelessWidget {
  const ResendRow({super.key, required this.secondsLeft, required this.onResend});

  final int secondsLeft;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    if (secondsLeft > 0) {
      final mm = secondsLeft ~/ 60;
      final ss = (secondsLeft % 60).toString().padLeft(2, '0');
      return Text(
        'Resend code in $mm:$ss',
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 13,
          color: AppColors.textSecondary,
        ),
      );
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onResend,
      child: const Text(
        'Resend code',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }
}



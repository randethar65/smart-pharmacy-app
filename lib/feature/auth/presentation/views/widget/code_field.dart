import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';

/// 6-box verification code input (pinput), themed for filled / focused / error.
class CodeField extends StatelessWidget {
  const CodeField({
    required this.controller,
    required this.hasError,
    required this.onChanged,
  });

  final TextEditingController controller;
  final bool hasError;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final base = PinTheme(
      width: 48,
      height: 56,
      textStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      decoration: BoxDecoration(
        color: AppColors.field,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent),
      ),
    );

    return Pinput(
      length: 6,
      controller: controller,
      onChanged: (_) => onChanged(),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      forceErrorState: hasError,
      defaultPinTheme: base,
      submittedPinTheme: base,
      focusedPinTheme: base.copyDecorationWith(
        color: AppColors.surface,
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      errorPinTheme: base.copyDecorationWith(
        color: AppColors.surface,
        border: Border.all(color: AppColors.error, width: 1.5),
      ),
    );
  }
}
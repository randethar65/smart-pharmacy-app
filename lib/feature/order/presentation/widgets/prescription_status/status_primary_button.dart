import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';

/// Full-width pill button used at the bottom of every status state.
class StatusPrimaryButton extends StatelessWidget {
  const StatusPrimaryButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.bg = AppColors.deepTeal,
    this.fg = Colors.white,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

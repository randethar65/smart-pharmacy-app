import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';

/// One of the two "pick a prescription image" tiles (Take photo / Gallery).
class SourceCard extends StatelessWidget {
  const SourceCard({
    super.key,
    required this.icon,
    required this.label,
    required this.circleColor,
    required this.background,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color circleColor;
  final Color background;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: circleColor,
              child: Icon(icon, size: 22, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

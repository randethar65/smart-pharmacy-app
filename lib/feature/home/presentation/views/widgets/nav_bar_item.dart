import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';

/// A single icon+label tab in [NavWidget]. Purely presentational — [onTap]
/// and [isSelected] are driven entirely by the parent.
class NavBarItem extends StatelessWidget {
  const NavBarItem({
    super.key,
    required this.svgUri,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String svgUri;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.deepTeal : AppColors.ink;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
        SvgPicture.asset(
            svgUri,
            height: 20,
            width: 20,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

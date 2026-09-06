import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';

/// A full-width horizontal dashed line.
class DashedDivider extends StatelessWidget {
  const DashedDivider({
    super.key,
    this.dashWidth = 4,
    this.gap = 4,
    this.thickness = 1,
    this.color = AppColors.border,
  });

  final double dashWidth;
  final double gap;
  final double thickness;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = (constraints.maxWidth / (dashWidth + gap)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count,
            (_) => SizedBox(
              width: dashWidth,
              height: thickness,
              child: DecoratedBox(decoration: BoxDecoration(color: color)),
            ),
          ),
        );
      },
    );
  }
}

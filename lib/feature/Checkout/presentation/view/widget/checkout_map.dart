import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';

/// Static map preview at the top of the delivery card. Swap the asset for a
/// real map (or an OSM static-map URL) later if needed.
class CheckoutMap extends StatelessWidget {
  const CheckoutMap({super.key, this.height = 130});

  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        'assets/images/Map Placeholder.png',
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: height,
          color: AppColors.field,
          alignment: Alignment.center,
          child: const Icon(Icons.map_outlined, color: AppColors.textSecondary),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_pharmacy/feature/home/presentation/views/widgets/product_item_skeleton.dart';

/// Shimmering placeholder grid shown while [ProductCubit] is loading —
/// same layout as [ProductsGrid], just fed fake cards instead of real ones.
class ProductsGridSkeleton extends StatelessWidget {
  const ProductsGridSkeleton({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      // A subtle base/highlight pair (like AppColors.field → white) barely
      // shows movement on a light page background — this pair is the
      // standard, higher-contrast shimmer look.
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      period: const Duration(milliseconds: 1200),
      child: MasonryGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        itemCount: itemCount,
        itemBuilder: (context, index) => const ProductItemSkeleton(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmering placeholder row shown while [CategoryCubit] is loading — same
/// height/padding/spacing as [CategoriesRow] so there's no layout jump once
/// the real pills swap in.
class CategoryPillsSkeleton extends StatelessWidget {
  const CategoryPillsSkeleton({super.key});

  static const _widths = [50.0, 110.0, 80.0, 95.0, 70.0];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        period: const Duration(milliseconds: 1200),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _widths.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) => Container(
            width: _widths[i],
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}

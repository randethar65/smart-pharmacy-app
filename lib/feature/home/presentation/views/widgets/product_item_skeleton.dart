import 'package:flutter/material.dart';

/// Placeholder card shaped like [ProductItem], shown (wrapped in a
/// [Shimmer]) while products are loading. All blocks are plain white —
/// the shimmer's own gradient supplies the "loading" look.
class ProductItemSkeleton extends StatelessWidget {
  const ProductItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 8),
            _bar(width: double.infinity, height: 14),
            const SizedBox(height: 6),
            _bar(width: 70, height: 14),
            const SizedBox(height: 8),
            _bar(width: 50, height: 12),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _bar(width: 48, height: 18),
                CircleAvatar(radius: 16, backgroundColor: Colors.grey.shade300),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _bar({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

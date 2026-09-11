import 'package:flutter/material.dart';

/// Placeholder card shaped like [OrderItem], shown (wrapped in a [Shimmer])
/// while orders are loading. All blocks are plain grey — the shimmer's own
/// gradient supplies the "loading" look.
class OrderItemSkeleton extends StatelessWidget {
  const OrderItemSkeleton({super.key});

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

  Widget _thumb() => Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _bar(width: 90, height: 14),
              const Spacer(),
              _bar(width: 60, height: 12),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _thumb(),
              const SizedBox(width: 8),
              _thumb(),
              const SizedBox(width: 8),
              _thumb(),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: Colors.grey.shade200),
          const SizedBox(height: 12),
          _bar(width: 60, height: 12),
          const SizedBox(height: 8),
          Row(
            children: [
              _bar(width: 70, height: 16),
              const Spacer(),
              _bar(width: 80, height: 22),
            ],
          ),
        ],
      ),
    );
  }
}

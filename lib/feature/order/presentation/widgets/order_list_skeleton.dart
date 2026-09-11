import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_pharmacy/feature/order/presentation/widgets/order_item_skeleton.dart';

/// Shimmering placeholder list shown while [OrderCubit] is loading — same
/// layout/spacing as [OrderView]'s list, just fed fake cards.
class OrderListSkeleton extends StatelessWidget {
  const OrderListSkeleton({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      period: const Duration(milliseconds: 1200),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, __) => const OrderItemSkeleton(),
      ),
    );
  }
}

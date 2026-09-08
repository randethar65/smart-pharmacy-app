import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/feature/order/data/Models/order_response.dart';
import 'package:smart_pharmacy/feature/order/presentation/widgets/order_state_widget.dart';

/// One card in the orders list: number + date, item thumbnails, count,
/// total and a status pill.
class OrderItem extends StatelessWidget {
  const OrderItem({super.key, required this.order, this.onTap});

  final OrderResponse order;
  final VoidCallback? onTap;

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String get _date {
    final d = order.orderDate;
    return '${_months[d.month - 1]} ${d.day.toString().padLeft(2, '0')}, ${d.year}';
  }

  int get _count => order.items.fold(0, (sum, i) => sum + i.quantity);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Order #${order.id}',
                  style: const TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Text(
                  _date,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _Thumbs(items: order.items),
            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: 12),
            Text(
              '$_count ${_count == 1 ? 'item' : 'items'}',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  '\$${order.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                OrderStateWidget(status: order.orderStatus),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Thumbs extends StatelessWidget {
  const _Thumbs({required this.items});

  final List<OrderItemResponse> items;

  @override
  Widget build(BuildContext context) {
    const maxShown = 3;
    final shown = items.take(maxShown).toList();
    final extra = items.length - shown.length;

    return Row(
      children: [
        for (final it in shown) ...[
          _Thumb(url: it.productImage),
          const SizedBox(width: 8),
        ],
        if (extra > 0)
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.field,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '+$extra',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
      ],
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    const fallback = Icon(
      Icons.medication_outlined,
      size: 20,
      color: AppColors.textSecondary,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 44,
        width: 44,
        color: AppColors.field,
        alignment: Alignment.center,
        child: url == null || url!.isEmpty
            ? fallback
            : Image.network(
                url!,
                fit: BoxFit.cover,
                width: 44,
                height: 44,
                errorBuilder: (_, __, ___) => fallback,
              ),
      ),
    );
  }
}

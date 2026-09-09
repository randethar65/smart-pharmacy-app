import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/feature/order/data/models/order_response.dart';
import 'package:smart_pharmacy/feature/order/presentation/widgets/order_details/detail_card.dart';

/// "Items" card — one row per ordered product.
class OrderItemsCard extends StatelessWidget {
  const OrderItemsCard({super.key, required this.order});

  final OrderResponse order;

  @override
  Widget build(BuildContext context) {
    return DetailCard(
      title: 'Items',
      child: Column(
        children: [
          for (var i = 0; i < order.items.length; i++) ...[
            if (i > 0) const SizedBox(height: 14),
            _ItemRow(item: order.items[i]),
          ],
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item});

  final OrderItemResponse item;

  @override
  Widget build(BuildContext context) {
    const fallback = Icon(Icons.medication_outlined,
        size: 22, color: AppColors.textSecondary);

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 48,
            width: 48,
            color: AppColors.field,
            alignment: Alignment.center,
            child: item.productImage == null || item.productImage!.isEmpty
                ? fallback
                : Image.network(
                    item.productImage!,
                    height: 48,
                    width: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => fallback,
                  ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.productName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Qty: ${item.quantity}',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Text(
          '\$${item.subtotal.toStringAsFixed(2)}',
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

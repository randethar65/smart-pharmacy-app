import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/core/widgets/dashed_divider.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/widget/order_line_item.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/widget/summary_row.dart';
import 'package:smart_pharmacy/feature/cart/data/models/cart_model.dart';

/// Collapsible order breakdown: line items + subtotal + delivery + total.
class OrderSummaryCard extends StatefulWidget {
  const OrderSummaryCard({
    super.key,
    required this.cart,
    this.deliveryFee = 4.0,
  });

  final CartModel cart;
  final double deliveryFee;

  @override
  State<OrderSummaryCard> createState() => _OrderSummaryCardState();
}

class _OrderSummaryCardState extends State<OrderSummaryCard> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final cart = widget.cart;
    final total = cart.total + widget.deliveryFee;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => setState(() => _expanded = !_expanded),
            child: Row(
              children: [
                const Icon(Icons.receipt_long_outlined,
                    size: 20, color: AppColors.primary),
                const SizedBox(width: 10),
                const Text(
                  'Order Summary',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Text(
                  '${cart.count} items',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          if (_expanded) ...[
            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: 12),
            for (final item in cart.items) ...[
              OrderLineItem(item: item),
              const SizedBox(height: 12),
            ],
            const DashedDivider(),
            const SizedBox(height: 12),
            SummaryRow(
              label: 'Subtotal',
              value: '\$${cart.total.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 8),
            SummaryRow(
              label: 'Delivery Fee',
              value: '\$${widget.deliveryFee.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: 12),
          ] else
            const SizedBox(height: 12),
          SummaryRow(
            label: 'Total',
            value: '\$${total.toStringAsFixed(2)}',
            emphasize: true,
          ),
        ],
      ),
    );
  }
}

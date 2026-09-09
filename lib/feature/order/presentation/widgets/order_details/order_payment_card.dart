import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/feature/order/data/models/order_response.dart';
import 'package:smart_pharmacy/feature/order/presentation/widgets/order_details/detail_card.dart';

/// "Payment Summary" card — subtotal, delivery fee and the grand total.
class OrderPaymentCard extends StatelessWidget {
  const OrderPaymentCard({super.key, required this.order});

  final OrderResponse order;

  @override
  Widget build(BuildContext context) {
    final subtotal = order.items.fold<double>(0, (s, i) => s + i.subtotal);
    final delivery = (order.total - subtotal).clamp(0, double.infinity);

    return DetailCard(
      title: 'Payment Summary',
      child: Column(
        children: [
          _SummaryRow(label: 'Subtotal', value: '\$${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 10),
          _SummaryRow(label: 'Delivery', value: '\$${delivery.toStringAsFixed(2)}'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: AppColors.border),
          ),
          _SummaryRow(
            label: 'Total',
            value: '\$${order.total.toStringAsFixed(2)}',
            emphasize: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontFamily: emphasize ? 'PlusJakartaSans' : 'Inter',
      fontSize: emphasize ? 16 : 14,
      fontWeight: emphasize ? FontWeight.w700 : FontWeight.w400,
      color: emphasize ? AppColors.textPrimary : AppColors.textSecondary,
    );
    return Row(
      children: [
        Text(label, style: style),
        const Spacer(),
        Text(value, style: style.copyWith(color: AppColors.textPrimary)),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/widget/payment_method_item.dart';

/// Backend expects 'Cash' or 'Visa'.
enum PaymentMethod { cash, card }

/// White card: "Payment Method" header + two selectable rows.
/// Controlled by the parent — [selected] + [onChanged].
class PaymentMethodCard extends StatelessWidget {
  const PaymentMethodCard({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final PaymentMethod selected;
  final ValueChanged<PaymentMethod> onChanged;

  @override
  Widget build(BuildContext context) {
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
          const Row(
            children: [
              Icon(Icons.payments_outlined, size: 22, color: AppColors.primary),
              SizedBox(width: 10),
              Text(
                'Payment Method',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          PaymentMethodItem(
            isSelected: selected == PaymentMethod.cash,
            icon: Icons.local_shipping_outlined,
            title: 'Cash on delivery',
            desc: 'Pay directly to the courier',
            onTap: () => onChanged(PaymentMethod.cash),
          ),
          const SizedBox(height: 12),
          PaymentMethodItem(
            isSelected: selected == PaymentMethod.card,
            icon: Icons.credit_card,
            title: 'Credit / Debit Card',
            desc: 'Visa, Mastercard',
            onTap: () => onChanged(PaymentMethod.card),
          ),
        ],
      ),
    );
  }
}

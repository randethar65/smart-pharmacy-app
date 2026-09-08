import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/core/widgets/button_app.dart';

/// Shown when the user backs out of the Stripe checkout page. The order exists
/// but is unpaid — it can be paid later from the orders list.
class PaymentCancelledView extends StatelessWidget {
  const PaymentCancelledView({super.key});

  static const routeName = "PaymentCancelledView";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 32),
            Image.asset(
              'assets/images/Illustration Area (1).png',
              height: 128,
              width: 128,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            const Text(
              'Payment cancelled',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Payment cancelled — you can pay later from your orders.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                height: 1.5,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 48),
            PrimaryButton(
              uriSvg: 'assets/svgs/orders.svg',
              iconWidth: 16,
              iconHeight: 16,
              backgroundColor: AppColors.deepTeal,
              foregroundColor: Colors.white,
              label: 'Go to Orders',
              onPressed: () {
                // TODO: Navigator.pushNamed(context, OrdersView.routeName);
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.deepTeal,
                  side: const BorderSide(color: AppColors.deepTeal),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text('Try Again'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/core/widgets/button_app.dart';
import 'package:smart_pharmacy/feature/home/presentation/views/home_view.dart';

/// Shown after a card (Visa) payment is confirmed by Stripe.
class PaymentSuccessView extends StatelessWidget {
  const PaymentSuccessView({super.key});

  static const routeName = "PaymentSuccessView";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
           const SizedBox(height: 20,),
            // Badge + soft glow, layered as a Stack.
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primaryTint.withValues(alpha: 0.55),
                        AppColors.primaryTint.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
                const CircleAvatar(
                  radius:43,
                  backgroundColor: AppColors.primary,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.primaryTint,
                    child: Icon(
                      Icons.check,
                      size: 20,
                      color: AppColors.deepTeal,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Payment successful',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your order has been placed and is being processed. '
              'You will receive an email confirmation shortly.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                height: 1.5,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
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
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  HomeView.routeName,
                  (route) => false,
                ),
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
                child: const Text('Return Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

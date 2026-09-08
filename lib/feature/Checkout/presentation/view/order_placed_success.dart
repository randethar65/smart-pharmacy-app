import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/core/widgets/button_app.dart';
import 'package:smart_pharmacy/feature/home/presentation/views/home_view.dart';

/// Shown after a cash order is placed, or a card payment is confirmed.
class OrderPlacedSuccess extends StatelessWidget {
  const OrderPlacedSuccess({
    super.key,
    required this.orderId,
    required this.total,
  });

  static const routName = "OrderPlacedSuccess";

  final int orderId;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false, // no going "back" into the checkout form
        title: const Text(
          'Order Confirmed',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.deepTeal,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 32),
        child: Column(
          children: [
           Image.asset("assets/images/Background+Shadow.png",height:128 ,width:128 ,fit: BoxFit.cover,),
            const SizedBox(height: 32),
            Text(
              'Order #$orderId Placed',
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Your order for \$${total.toStringAsFixed(2)} has been '
              'successfully processed.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 56),
            PrimaryButton(
              backgroundColor: AppColors.deepTeal,
              foregroundColor: Colors.white,
              label: "View order",
              onPressed: () {
                // TODO: Navigator.pushNamed(context, OrdersView.routeName);
              },
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              backgroundColor: AppColors.blue,
              foregroundColor: AppColors.textPrimary,
              label: "Continue shopping",
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                HomeView.routeName,
                (route) => false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

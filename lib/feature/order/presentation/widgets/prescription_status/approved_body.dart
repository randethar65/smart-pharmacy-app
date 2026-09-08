import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/feature/home/presentation/views/home_view.dart';
import 'package:smart_pharmacy/feature/order/presentation/widgets/prescription_status/status_badge.dart';
import 'package:smart_pharmacy/feature/order/presentation/widgets/prescription_status/status_primary_button.dart';
import 'package:smart_pharmacy/feature/order/presentation/widgets/prescription_status/status_text.dart';

class ApprovedBody extends StatelessWidget {
  const ApprovedBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        const StatusBadge(
          color: AppColors.primary,
          halo: AppColors.primarySurface,
          icon: Icons.check,
        ),
        const SizedBox(height: 20),
        const StatusTitle('Prescription Approved'),
        const SizedBox(height: 8),
        const StatusSubtitle(
          'Your prescription has been verified. Your order is now being '
          'processed for delivery.',
        ),
        const Spacer(),
        StatusPrimaryButton(
          label: 'Track Order',
          icon: Icons.local_shipping_outlined,
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(height: 6),
        TextButton(
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            HomeView.routeName,
            (r) => false,
          ),
          style: TextButton.styleFrom(foregroundColor: AppColors.deepTeal),
          child: const Text('Continue Shopping'),
        ),
      ],
    );
  }
}

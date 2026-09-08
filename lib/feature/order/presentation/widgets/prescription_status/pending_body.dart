import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/feature/home/presentation/views/home_view.dart';
import 'package:smart_pharmacy/feature/order/presentation/widgets/prescription_status/status_badge.dart';
import 'package:smart_pharmacy/feature/order/presentation/widgets/prescription_status/status_primary_button.dart';
import 'package:smart_pharmacy/feature/order/presentation/widgets/prescription_status/status_text.dart';

class PendingBody extends StatelessWidget {
  const PendingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        const StatusBadge(
          color: AppColors.textSecondary,
          halo: AppColors.blue,
          icon: Icons.hourglass_top,
        ),
        const SizedBox(height: 20),
        const StatusTitle('Pending review'),
        const SizedBox(height: 8),
        const StatusSubtitle(
          'Our pharmacists are reviewing your prescription. This usually '
          'takes 1–2 hours.',
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _dot(done: true),
            _bar(done: true),
            _dot(done: true),
            _bar(done: false),
            _dot(done: false),
          ],
        ),
        const Spacer(),
        StatusPrimaryButton(
          label: 'Return to Home',
          icon: Icons.home_outlined,
          bg: AppColors.blue,
          fg: AppColors.deepTeal,
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            HomeView.routeName,
            (r) => false,
          ),
        ),
      ],
    );
  }

  Widget _dot({required bool done}) => Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: done ? AppColors.deepTeal : AppColors.border,
        ),
      );

  Widget _bar({required bool done}) => Container(
        width: 32,
        height: 3,
        color: done ? AppColors.deepTeal : AppColors.border,
      );
}

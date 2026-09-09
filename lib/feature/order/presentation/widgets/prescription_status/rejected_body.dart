import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/feature/home/presentation/views/home_view.dart';
import 'package:smart_pharmacy/feature/order/presentation/views/order_view.dart';
import 'package:smart_pharmacy/feature/order/presentation/widgets/prescription_status/pharmacist_note_card.dart';
import 'package:smart_pharmacy/feature/order/presentation/widgets/prescription_status/status_badge.dart';
import 'package:smart_pharmacy/feature/order/presentation/widgets/prescription_status/status_palette.dart';
import 'package:smart_pharmacy/feature/order/presentation/widgets/prescription_status/status_primary_button.dart';
import 'package:smart_pharmacy/feature/order/presentation/widgets/prescription_status/status_text.dart';

class RejectedBody extends StatelessWidget {
  const RejectedBody({super.key, this.note});

  /// Pharmacist's reason for the rejection (from the rejected prescription).
  final String? note;

  @override
  Widget build(BuildContext context) {
    final hasNote = note != null && note!.trim().isNotEmpty;

    return Column(
      children: [
        const SizedBox(height: 8),
        const StatusBadge(
          color: kRxCoral,
          halo: kRxCoralSurface,
          icon: Icons.priority_high,
          cornerIcon: Icons.close,
        ),
        const SizedBox(height: 20),
        const StatusTitle('Prescription Rejected'),
        const SizedBox(height: 8),
        const StatusSubtitle(
          'Your order was cancelled and the items have been released.',
        ),
        if (hasNote) ...[
          const SizedBox(height: 20),
          PharmacistNoteCard(note: note!),
        ],
        const Spacer(),
        StatusPrimaryButton(
          label: 'Go to Orders',
          icon: Icons.receipt_long,
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            OrderView.routName,
            (r) => r.settings.name == HomeView.routeName,
          ),
        ),
        const SizedBox(height: 6),
        TextButton.icon(
          onPressed: () {
            // TODO: contact support
          },
          icon: const Icon(Icons.headset_mic_outlined, size: 16),
          label: const Text('Contact Support'),
          style: TextButton.styleFrom(foregroundColor: AppColors.deepTeal),
        ),
      ],
    );
  }
}

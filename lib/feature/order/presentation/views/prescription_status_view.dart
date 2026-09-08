import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/widget/header.dart';
import 'package:smart_pharmacy/feature/order/presentation/widgets/prescription_status/approved_body.dart';
import 'package:smart_pharmacy/feature/order/presentation/widgets/prescription_status/pending_body.dart';
import 'package:smart_pharmacy/feature/order/presentation/widgets/prescription_status/rejected_body.dart';

enum PrescriptionOutcome { pending, approved, rejected }

/// UI only — one screen, three states (pending / approved / rejected).
/// [orderId] is carried for the later cubit wiring
/// (`GET /api/Prescriptions/order/{orderId}`).
class PrescriptionStatusView extends StatelessWidget {
  const PrescriptionStatusView({
    super.key,
    // required this.orderId,
    this.outcome = PrescriptionOutcome.approved,
  });

  static const routName = "PrescriptionStatusView";

  // final int orderId;
  final PrescriptionOutcome outcome;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const Header(title: 'Prescription Status'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: switch (outcome) {
            PrescriptionOutcome.rejected => const RejectedBody(),
            PrescriptionOutcome.approved => const ApprovedBody(),
            PrescriptionOutcome.pending => const PendingBody(),
          },
        ),
      ),
    );
  }
}

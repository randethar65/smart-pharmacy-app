import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/feature/Checkout/data/models/upload_prescription_response.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/manger/prescription/cubit/prescription_cubit.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/widget/header.dart';
import 'package:smart_pharmacy/feature/order/presentation/widgets/prescription_status/approved_body.dart';
import 'package:smart_pharmacy/feature/order/presentation/widgets/prescription_status/pending_body.dart';
import 'package:smart_pharmacy/feature/order/presentation/widgets/prescription_status/rejected_body.dart';

enum PrescriptionOutcome { pending, approved, rejected }

/// Shows the pharmacist's review outcome for an order's prescriptions.
/// The [PrescriptionCubit] is created + `getOrderPrescriptions(id)` is called
/// in the route (`GET /api/Prescriptions/order/{orderId}`).
class PrescriptionStatusView extends StatelessWidget {
  const PrescriptionStatusView({super.key, required this.orderId});

  static const routName = "PrescriptionStatusView";

  final int orderId;

  /// The backend is all-or-nothing: any rejection cancels the whole order,
  /// and the order only moves on once every prescription is approved.
  PrescriptionOutcome _outcomeFrom(List<PrescriptionResponse> list) {
    if (list.any((p) => p.status == 'Rejected')) {
      return PrescriptionOutcome.rejected;
    }
    if (list.isNotEmpty && list.every((p) => p.status == 'Approved')) {
      return PrescriptionOutcome.approved;
    }
    return PrescriptionOutcome.pending;
  }

  /// First non-empty note among the rejected prescriptions.
  String? _rejectedNote(List<PrescriptionResponse> list) {
    for (final p in list.where((p) => p.status == 'Rejected')) {
      final n = p.note?.trim();
      if (n != null && n.isNotEmpty) return n;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const Header(title: 'Prescription Status'),
      body: SafeArea(
        child: BlocBuilder<PrescriptionCubit, PrescriptionState>(
          builder: (context, state) {
            if (state is PrescriptionLoading || state is PrescriptionInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PrescriptionFailure) {
              return Center(
                child: TextButton(
                  onPressed: () => context
                      .read<PrescriptionCubit>()
                      .getOrderPrescriptions(id: orderId),
                  child: Text('${state.message} — Tap to retry'),
                ),
              );
            }

            if (state is PrescriptionsOrderSuccess) {
              final list = state.result;
              return Padding(
                padding: const EdgeInsets.all(24),
                child: switch (_outcomeFrom(list)) {
                  PrescriptionOutcome.rejected =>
                    RejectedBody(note: _rejectedNote(list)),
                  PrescriptionOutcome.approved => const ApprovedBody(),
                  PrescriptionOutcome.pending => const PendingBody(),
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

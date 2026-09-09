import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/upload_prescription_view.dart';
import 'package:smart_pharmacy/feature/order/data/models/order_response.dart';
import 'package:smart_pharmacy/feature/order/presentation/manger/order_detail.dart/cubit/order_detail_cubit.dart';
import 'package:smart_pharmacy/feature/order/presentation/views/prescription_status_view.dart';

/// Pinned bottom actions for the Order Details screen — shown only for the
/// statuses that actually have something to do.
class OrderActionBar extends StatelessWidget {
  const OrderActionBar({super.key, required this.order});

  final OrderResponse order;

  static const _coral = Color(0xFFA8372B);
  static const _cancelBg = Color(0xFFFDECEA);
  static const _cancelFg = Color(0xFFC0392B);

  Future<void> _confirmCancel(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel order?'),
        content: const Text(
          'This cannot be undone. Your items will be released.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: _cancelFg),
            child: const Text('Yes, cancel'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      context.read<OrderDetailCubit>().cancelOrder(id: order.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = order.orderStatus;
    final awaitingRx = s == 'AwaitingPrescription';
    final canPay = s == 'Pending';
    final canCancel = s == 'Pending' || s == 'AwaitingPrescription';
    final hasRx = order.prescriptionsCount > 0 ;

    if (!awaitingRx && !canPay && !canCancel && !hasRx) {
      return const SizedBox.shrink();
    }

    final secondary = <Widget>[
      if (hasRx)
        _BarButton(
          label: 'Prescription Status',
          bg: AppColors.deepTeal,
          fg: Colors.white,
          onPressed: () {
         Navigator.pushNamed(context,PrescriptionStatusView.routName,
         arguments: order.id);
          },
        ),
      if (canCancel)
        _BarButton(
          label: 'Cancel Order',
          bg: _cancelBg,
          fg: _cancelFg,
          onPressed: () => _confirmCancel(context),
        ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (awaitingRx)
                _PrimaryButton(
                  label: 'Upload Prescription',
                  icon: Icons.upload_file,
                  bg: _coral,
                  onPressed: () {
               Navigator.pushNamed(context,
                      UploadPrescriptionView.routeName, arguments: {'orderId': order.id});
                  },
                )
              else if (canPay)
                _PrimaryButton(
                      label: 'Pay \$${order.total.toStringAsFixed(2)}',
                      icon: Icons.credit_card,
                      bg: AppColors.deepTeal,
                  onPressed: () =>
                      context.read<OrderDetailCubit>().payOrder(order),
                ),
              if ((awaitingRx || canPay) && secondary.isNotEmpty)
                const SizedBox(height: 10),
              if (secondary.isNotEmpty)
                Row(
                  children: [
                    for (var i = 0; i < secondary.length; i++) ...[
                      if (i > 0) const SizedBox(width: 10),
                      Expanded(child: secondary[i]),
                    ],
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.bg,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color bg;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _BarButton extends StatelessWidget {
  const _BarButton({
    required this.label,
    required this.bg,
    required this.fg,
    required this.onPressed,
  });

  final String label;
  final Color bg;
  final Color fg;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

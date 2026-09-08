import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';

/// Small pill showing an order's status: soft background + matching icon/label.
class OrderStateWidget extends StatelessWidget {
  const OrderStateWidget({super.key, required this.status});

  /// Wire value from the API: "Pending" | "Processing" | "Shipped" |
  /// "Delivered" | "Cancelled" | "Paid" | "AwaitingPrescription".
  final String status;

  // amber
  static const _pendingBg = Color(0xFFFFF8E1);
  static const _pendingFg = Color(0xFFF57F17);
  // teal
  static const _paidBg = Color(0xFFA3FAEF);
  static const _paidFg = Color(0xFF0F766E);
  // blue
  static const _blueBg = Color(0xFFD8EDFF);
  static const _blueFg = Color(0xFF0070A0);
  // coral — needs the user's attention
  static const _rxBg = Color(0xFFFFEAE3);
  static const _rxFg = Color(0xFFE4572E);
  // green
  static const _greenBg = Color(0xFFE3F9E5);
  static const _greenFg = Color(0xFF207544);
  // red
  static const _redBg = Color(0xFFFDECEA);
  static const _redFg = Color(0xFFC0392B);

  ({String label, Color bg, Color fg, IconData icon}) get _style =>
      switch (status) {
        'AwaitingPrescription' => (
            label: 'Awaiting Rx',
            bg: _rxBg,
            fg: _rxFg,
            icon: Icons.description_outlined,
          ),
        'Pending' => (
            label: 'Pending Payment',
            bg: _pendingBg,
            fg: _pendingFg,
            icon: Icons.schedule,
          ),
        'Processing' => (
            label: 'Processing',
            bg: _blueBg,
            fg: _blueFg,
            icon: Icons.autorenew,
          ),
        'Shipped' => (
            label: 'Shipped',
            bg: _blueBg,
            fg: _blueFg,
            icon: Icons.local_shipping_outlined,
          ),
        'Delivered' => (
            label: 'Delivered',
            bg: _greenBg,
            fg: _greenFg,
            icon: Icons.inventory_2_outlined,
          ),
        'Paid' => (
            label: 'Paid',
            bg: _paidBg,
            fg: _paidFg,
            icon: Icons.check_circle,
          ),
        'Cancelled' => (
            label: 'Cancelled',
            bg: _redBg,
            fg: _redFg,
            icon: Icons.cancel_outlined,
          ),
        _ => (
            label: status,
            bg: AppColors.field,
            fg: AppColors.textSecondary,
            icon: Icons.info_outline,
          ),
      };

  @override
  Widget build(BuildContext context) {
    final s = _style;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: s.bg,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(s.icon, size: 17, color: s.fg),
          const SizedBox(width: 6),
          Text(
            s.label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: s.fg,
            ),
          ),
        ],
      ),
    );
  }
}

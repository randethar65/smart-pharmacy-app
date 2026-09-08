import 'package:flutter/material.dart';
import 'package:smart_pharmacy/feature/order/presentation/widgets/prescription_status/status_palette.dart';

/// Coral "PHARMACIST'S NOTE" card shown on the rejected state.
class PharmacistNoteCard extends StatelessWidget {
  const PharmacistNoteCard({super.key, required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kRxCoralSurface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.assignment_outlined, size: 18, color: kRxCoral),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "PHARMACIST'S NOTE",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: kRxCoral,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  note,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    height: 1.5,
                    color: kRxCoral,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

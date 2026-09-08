import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/feature/order/data/Models/order_response.dart';
import 'package:smart_pharmacy/feature/order/presentation/widgets/order_details/detail_card.dart';

/// "Delivery" card — map preview + the delivery address.
class OrderDeliveryCard extends StatelessWidget {
  const OrderDeliveryCard({super.key, required this.order});

  final OrderResponse order;

  @override
  Widget build(BuildContext context) {
    final address = [order.street, order.city]
        .where((p) => p.isNotEmpty)
        .join(', ');

    return DetailCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.location_on_outlined,
                  size: 18, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'Delivery',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/Map Placeholder.png',
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 120,
                color: AppColors.field,
                alignment: Alignment.center,
                child: const Icon(Icons.map_outlined,
                    color: AppColors.textSecondary),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            address.isEmpty ? '—' : address,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
          if (order.phoneNumber.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              order.phoneNumber,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

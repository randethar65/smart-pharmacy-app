import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/widget/checkout_map.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/widget/delivery_details_form.dart';

/// White card: "Delivery Details" header + map preview + the address form.
class DeliveryDetailsCard extends StatelessWidget {
  const DeliveryDetailsCard({
    super.key,
    required this.form,
    required this.city,
    required this.streetAddress,
    required this.phone,
  });

  final GlobalKey<FormState> form;
  final TextEditingController city;
  final TextEditingController streetAddress;
  final TextEditingController phone;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Header(),
          const SizedBox(height: 16),
          const CheckoutMap(),
          const SizedBox(height: 16),
          DeliveryDetailsForm(
            form: form,
            city: city,
            streetAddress: streetAddress,
            phone: phone,
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset('assets/svgs/location.svg', height: 20, width: 20),
        const SizedBox(width: 10),
        const Text(
          'Delivery Details',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

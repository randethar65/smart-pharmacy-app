import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/widgets/text_form_field_app.dart';

/// The three delivery fields. City and Street Address are required; Phone is
/// optional but must look like a phone number when filled.
class DeliveryDetailsForm extends StatelessWidget {
  const DeliveryDetailsForm({
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

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required field' : null;

  String? _optionalPhone(String? v) {
    if (v == null || v.trim().isEmpty) return null; // optional
    final digits = v.replaceAll(RegExp(r'\D'), '');
    return digits.length < 9 ? 'Enter a valid phone number' : null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: form,
      child: Column(
        children: [
          AppTextFormField(
            label: 'City',
            hint: 'e.g. Tulkarm',
            controller: city,
            textInputAction: TextInputAction.next,
            validator: _required,
          ),
          const SizedBox(height: 16),
          AppTextFormField(
            label: 'Street Address',
            hint: 'Building, street, area',
            controller: streetAddress,
            textInputAction: TextInputAction.next,
            validator: _required,
          ),
          const SizedBox(height: 16),
          AppTextFormField(
            label: 'Phone Number',
            hint: '+970 5X XXX XXXX',
            controller: phone,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            validator: _optionalPhone,
          ),
        ],
      ),
    );
  }
}

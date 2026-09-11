import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/core/widgets/button_app.dart';
import 'package:smart_pharmacy/core/widgets/text_form_field_app.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/widget/header.dart';
import 'package:smart_pharmacy/feature/profile/data/models/my_profile_response.dart';
import 'package:smart_pharmacy/feature/profile/data/models/update_my_profile_request.dart';
import 'package:smart_pharmacy/feature/profile/presentation/manger/cubit/profile_cubit.dart';

/// Prefilled from [profile]. Must be pushed with the same [ProfileCubit]
/// instance as the parent ProfileView (see MyAddressWidget) so Save can
/// simply pop back instead of re-fetching.
class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key, required this.profile});
   static const String routeName="EditProfileView";
  final MyProfileResponse profile;

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _form = GlobalKey<FormState>();
  late final _fullName =
      TextEditingController(text: widget.profile.fullName ?? '');
  late final _phone =
      TextEditingController(text: widget.profile.phoneNumber ?? '');
  late final _city = TextEditingController(text: widget.profile.city ?? '');
  late final _street =
      TextEditingController(text: widget.profile.street ?? '');

  @override
  void dispose() {
    _fullName.dispose();
    _phone.dispose();
    _city.dispose();
    _street.dispose();
    super.dispose();
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required field' : null;

  String? _optionalPhone(String? v) {
    if (v == null || v.trim().isEmpty) return null; // optional
    final digits = v.replaceAll(RegExp(r'\D'), '');
    return digits.length < 9 ? 'Enter a valid phone number' : null;
  }

  Future<void> _onSave() async {
    if (!_form.currentState!.validate()) return;
    await context.read<ProfileCubit>().updateProfile(UpdateMyProfileRequest(
          fullName: _fullName.text,
          phoneNumber: _phone.text,
          city: _city.text,
          street: _street.text,
        ));
    // نفس الـ cubit اللي عند ProfileView تحدّث لحالها (ProfileSuccess جاية من رد
    // الـ PATCH نفسه) — فقط pop، ما في داعي نفتح ProfileView جديدة ونعمل GET تاني.
    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const Header(title: 'Edit Profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Email is the confirmed login — shown, not editable.
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.field,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.alternate_email,
                        size: 18, color: AppColors.textSecondary),
                    const SizedBox(width: 10),
                    Text(
                      widget.profile.email,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              AppTextFormField(
                label: 'Full Name',
                hint: 'e.g. Mark Johnson',
                controller: _fullName,
                textInputAction: TextInputAction.next,
                validator: _required,
              ),
              const SizedBox(height: 16),
              AppTextFormField(
                label: 'Phone Number',
                hint: '+970 5X XXX XXXX',
                controller: _phone,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                validator: _optionalPhone,
              ),
              const SizedBox(height: 16),
              AppTextFormField(
                label: 'City',
                hint: 'e.g. Tulkarm',
                controller: _city,
                textInputAction: TextInputAction.next,
                validator: _required,
              ),
              const SizedBox(height: 16),
              AppTextFormField(
                label: 'Street Address',
                hint: 'Building, street, area',
                controller: _street,
                textInputAction: TextInputAction.done,
                validator: _required,
              ),
              const SizedBox(height: 32),
              PrimaryButton(label: 'Save Changes', onPressed: _onSave),
            ],
          ),
        ),
      ),
    );
  }
}
